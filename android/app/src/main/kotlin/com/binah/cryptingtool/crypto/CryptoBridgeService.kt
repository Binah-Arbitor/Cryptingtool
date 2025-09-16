package com.binah.cryptingtool.crypto

import com.binah.cryptingtool.models.EncryptionConfig
import java.io.File
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Service for performing cryptographic operations using the C++ backend via JNI
 */
class CryptoBridgeService {
    
    companion object {
        private const val LIBRARY_NAME = "cryptingtool"
        private var isInitialized = false
        
        init {
            try {
                System.loadLibrary(LIBRARY_NAME)
                isInitialized = true
                println("✅ CryptingTool native library loaded successfully")
            } catch (e: UnsatisfiedLinkError) {
                println("❌ Failed to load CryptingTool native library: ${e.message}")
                isInitialized = false
            }
        }
        
        fun initialize(): Boolean {
            return if (isInitialized) {
                val version = getVersion()
                println("✅ CryptingTool backend initialized - Version: $version")
                true
            } else {
                println("❌ Failed to initialize CryptingTool backend")
                false
            }
        }
        
        fun testRoundTrip(): Boolean {
            if (!isInitialized) return false
            
            return try {
                val testData = "Hello, CryptingTool!".toByteArray()
                val encrypted = processData(
                    CryptoConstants.ALGORITHM_AES,
                    CryptoConstants.MODE_CBC,
                    256,
                    CryptoConstants.OPERATION_ENCRYPT,
                    "test123",
                    testData
                )
                
                if (encrypted != null && encrypted.isNotEmpty()) {
                    val decrypted = processData(
                        CryptoConstants.ALGORITHM_AES,
                        CryptoConstants.MODE_CBC,
                        256,
                        CryptoConstants.OPERATION_DECRYPT,
                        "test123",
                        encrypted
                    )
                    
                    decrypted != null && String(decrypted) == "Hello, CryptingTool!"
                } else {
                    false
                }
            } catch (e: Exception) {
                println("Round trip test failed: ${e.message}")
                false
            }
        }
    }
    
    /**
     * Native function declarations
     */
    private external fun cryptoBridgeProcess(
        algorithm: Int,
        mode: Int,
        keySize: Int,
        operation: Int,
        password: String,
        passwordLen: Int,
        inputData: ByteArray,
        inputLen: Int,
        outputData: ByteArray,
        outputLen: IntArray,
        iv: ByteArray?,
        authTag: ByteArray?
    ): Int
    
    external fun getVersion(): String?
    
    external fun getSupportedAlgorithms(): IntArray?
    
    external fun getSupportedModes(): IntArray?
    
    /**
     * High-level encryption function
     */
    suspend fun encryptData(config: EncryptionConfig, data: ByteArray): ByteArray? {
        return withContext(Dispatchers.Default) {
            if (!isInitialized) {
                throw IllegalStateException("Crypto bridge not initialized")
            }
            
            processData(
                CryptoConstants.algorithmToNative(config.algorithm),
                CryptoConstants.modeToNative(config.mode),
                config.keySize,
                CryptoConstants.OPERATION_ENCRYPT,
                config.password,
                data
            )
        }
    }
    
    /**
     * High-level decryption function
     */
    suspend fun decryptData(config: EncryptionConfig, data: ByteArray): ByteArray? {
        return withContext(Dispatchers.Default) {
            if (!isInitialized) {
                throw IllegalStateException("Crypto bridge not initialized")
            }
            
            processData(
                CryptoConstants.algorithmToNative(config.algorithm),
                CryptoConstants.modeToNative(config.mode),
                config.keySize,
                CryptoConstants.OPERATION_DECRYPT,
                config.password,
                data
            )
        }
    }
    
    /**
     * File encryption function
     */
    suspend fun encryptFile(config: EncryptionConfig, inputFile: File, outputFile: File): Boolean {
        return withContext(Dispatchers.IO) {
            try {
                val inputData = inputFile.readBytes()
                val encryptedData = encryptData(config, inputData)
                
                if (encryptedData != null) {
                    outputFile.writeBytes(encryptedData)
                    true
                } else {
                    false
                }
            } catch (e: Exception) {
                println("File encryption error: ${e.message}")
                false
            }
        }
    }
    
    /**
     * File decryption function
     */
    suspend fun decryptFile(config: EncryptionConfig, inputFile: File, outputFile: File): Boolean {
        return withContext(Dispatchers.IO) {
            try {
                val inputData = inputFile.readBytes()
                val decryptedData = decryptData(config, inputData)
                
                if (decryptedData != null) {
                    outputFile.writeBytes(decryptedData)
                    true
                } else {
                    false
                }
            } catch (e: Exception) {
                println("File decryption error: ${e.message}")
                false
            }
        }
    }
    
    /**
     * Low-level data processing function
     */
    private fun processData(
        algorithm: Int,
        mode: Int,
        keySize: Int,
        operation: Int,
        password: String,
        inputData: ByteArray
    ): ByteArray? {
        if (!isInitialized) return null
        
        val outputBuffer = ByteArray(inputData.size + 1024) // Add padding for encryption overhead
        val outputLen = IntArray(1)
        val iv = ByteArray(16) // Standard IV size
        val authTag = ByteArray(16) // Standard auth tag size for GCM
        
        val result = cryptoBridgeProcess(
            algorithm,
            mode,
            keySize,
            operation,
            password,
            password.length,
            inputData,
            inputData.size,
            outputBuffer,
            outputLen,
            iv,
            authTag
        )
        
        return if (result == CryptoConstants.STATUS_SUCCESS && outputLen[0] > 0) {
            outputBuffer.copyOf(outputLen[0])
        } else {
            println("Crypto operation failed with status: $result")
            null
        }
    }
    
    /**
     * Get error message for status code
     */
    fun getErrorMessage(statusCode: Int): String {
        return when (statusCode) {
            CryptoConstants.STATUS_SUCCESS -> "Success"
            CryptoConstants.STATUS_INVALID_PARAMS -> "Invalid parameters"
            CryptoConstants.STATUS_UNSUPPORTED_ALGORITHM -> "Unsupported algorithm"
            CryptoConstants.STATUS_UNSUPPORTED_MODE -> "Unsupported mode"
            CryptoConstants.STATUS_INVALID_KEY_SIZE -> "Invalid key size"
            CryptoConstants.STATUS_MEMORY_ERROR -> "Memory error"
            CryptoConstants.STATUS_CRYPTO_ERROR -> "Cryptographic error"
            CryptoConstants.STATUS_PASSWORD_TOO_SHORT -> "Password too short"
            CryptoConstants.STATUS_OUTPUT_BUFFER_TOO_SMALL -> "Output buffer too small"
            else -> "Unknown error ($statusCode)"
        }
    }
}