package com.binah.cryptingtool.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

enum class EncryptionAlgorithm(val displayName: String, val description: String) {
    // Tier 1: Maximum Security - Modern & Post-Quantum Ready
    AES256("AES-256", "Advanced Encryption Standard - 256-bit (Maximum Security)"),
    SERPENT256("Serpent-256", "Serpent Block Cipher - 256-bit (Maximum Security)"),
    TWOFISH256("Twofish-256", "Twofish Block Cipher - 256-bit (Maximum Security)"),
    
    // Tier 2: High Security - Modern Algorithms
    AES192("AES-192", "Advanced Encryption Standard - 192-bit (High Security)"),
    AES128("AES-128", "Advanced Encryption Standard - 128-bit (High Security)"),
    SERPENT192("Serpent-192", "Serpent Block Cipher - 192-bit (High Security)"),
    SERPENT128("Serpent-128", "Serpent Block Cipher - 128-bit (High Security)"),
    TWOFISH192("Twofish-192", "Twofish Block Cipher - 192-bit (High Security)"),
    TWOFISH128("Twofish-128", "Twofish Block Cipher - 128-bit (High Security)"),
    
    // Tier 3: Strong Security - AES Finalists & Modern Ciphers
    RC6("RC6", "Rivest Cipher 6 - Variable Key Length"),
    MARS("MARS", "IBM MARS Block Cipher"),
    RC5("RC5", "Rivest Cipher 5 - Variable Parameters"),
    SKIPJACK("Skipjack", "NSA Skipjack Block Cipher"),
    
    // Tier 4: Reliable Security - Established Algorithms
    BLOWFISH("Blowfish", "Blowfish Block Cipher - Variable Key (32-448 bits)"),
    CAST128("CAST-128", "CAST-128 Block Cipher (128-bit key)"),
    CAST256("CAST-256", "CAST-256 Block Cipher (128/160/192/224/256-bit key)"),
    CAMELLIA("Camellia", "NTT/Mitsubishi Camellia Block Cipher"),
    
    // Tier 5: Stream Ciphers - High Performance
    CHACHA20("ChaCha20", "ChaCha20 Stream Cipher (256-bit key)"),
    SALSA20("Salsa20", "Salsa20 Stream Cipher (128/256-bit key)"),
    XSALSA20("XSalsa20", "Extended Salsa20 Stream Cipher (256-bit key)"),
    HC128("HC-128", "HC-128 Stream Cipher (128-bit key)"),
    HC256("HC-256", "HC-256 Stream Cipher (256-bit key)"),
    RABBIT("Rabbit", "Rabbit Stream Cipher (128-bit key)"),
    SOSEMANUK("Sosemanuk", "Sosemanuk Stream Cipher (128-256 bit key)"),
    
    // Tier 6: Specialized & National Algorithms
    ARIA("ARIA", "Korean ARIA Block Cipher (128/192/256-bit)"),
    SEED("SEED", "Korean SEED Block Cipher (128-bit key)"),
    SM4("SM4", "Chinese SM4 Block Cipher (128-bit key)"),
    GOST28147("GOST 28147-89", "Russian GOST Block Cipher (256-bit key)"),
    
    // Tier 7: Legacy Strong Algorithms
    DES3("3DES", "Triple Data Encryption Standard (168-bit effective)"),
    IDEA("IDEA", "International Data Encryption Algorithm (128-bit)"),
    RC2("RC2", "Rivest Cipher 2 - Variable Key Length"),
    SAFER("SAFER", "Secure And Fast Encryption Routine"),
    SAFER_PLUS("SAFER+", "Enhanced SAFER Block Cipher"),
    
    // Tier 8: Historical & Compatibility
    DES("DES", "Data Encryption Standard (56-bit key) - Legacy Only"),
    RC4("RC4", "Rivest Cipher 4 Stream Cipher - Legacy");
    
    fun getSupportedKeySizes(): List<Int> {
        return when (this) {
            // AES Family
            AES256 -> listOf(256)
            AES192 -> listOf(192)
            AES128 -> listOf(128)
            
            // Serpent Family
            SERPENT256 -> listOf(256)
            SERPENT192 -> listOf(192)
            SERPENT128 -> listOf(128)
            
            // Twofish Family
            TWOFISH256 -> listOf(256)
            TWOFISH192 -> listOf(192)
            TWOFISH128 -> listOf(128)
            
            // Stream Ciphers
            CHACHA20, XSALSA20, HC256, SOSEMANUK, GOST28147 -> listOf(256)
            SALSA20 -> listOf(128, 256)
            HC128, RABBIT -> listOf(128)
            
            // Variable key algorithms
            RC6, MARS -> listOf(128, 192, 256)
            RC5 -> listOf(128, 160, 192, 224, 256)
            BLOWFISH -> listOf(128, 192, 256, 448)
            CAST256 -> listOf(128, 160, 192, 224, 256)
            RC2 -> listOf(40, 64, 128)
            
            // Fixed key algorithms
            SKIPJACK, CAST128, CAMELLIA, ARIA, SEED, SM4, IDEA -> listOf(128)
            DES3 -> listOf(168)
            DES -> listOf(56)
            RC4 -> listOf(40, 128)
            SAFER, SAFER_PLUS -> listOf(128, 160)
        }
    }
    
    fun getSupportedModes(): List<OperationMode> {
        // Stream ciphers only support stream mode (represented as CTR)
        if (isStreamCipher()) {
            return listOf(OperationMode.CTR)
        }
        
        // Block ciphers support various modes
        return when (this) {
            // Modern block ciphers - full mode support
            AES256, AES192, AES128, SERPENT256, SERPENT192, SERPENT128,
            TWOFISH256, TWOFISH192, TWOFISH128, CAMELLIA, ARIA -> listOf(
                OperationMode.GCM,    // Authenticated encryption (preferred)
                OperationMode.CBC,    // Standard mode
                OperationMode.CFB,    // Cipher feedback
                OperationMode.OFB,    // Output feedback
                OperationMode.CTR,    // Counter mode
                OperationMode.ECB     // Electronic codebook (less secure)
            )
            
            // Good block ciphers - most modes
            RC6, MARS, CAST256, SEED, SM4, IDEA, BLOWFISH -> listOf(
                OperationMode.CBC,
                OperationMode.CFB,
                OperationMode.OFB,
                OperationMode.CTR,
                OperationMode.ECB
            )
            
            // Older/simpler block ciphers - basic modes
            CAST128, SKIPJACK, RC5, DES3, DES, RC2, SAFER, SAFER_PLUS -> listOf(
                OperationMode.CBC,
                OperationMode.CFB,
                OperationMode.OFB,
                OperationMode.ECB
            )
            
            // Research/specialized algorithms - limited modes
            GOST28147 -> listOf(
                OperationMode.CBC,
                OperationMode.ECB
            )
            
            else -> listOf(OperationMode.CBC, OperationMode.ECB)
        }
    }
    
    private fun isStreamCipher(): Boolean {
        return this in listOf(
            CHACHA20, SALSA20, XSALSA20, HC128, HC256,
            RABBIT, SOSEMANUK, RC4
        )
    }
}

enum class OperationMode(val displayName: String, val description: String) {
    CBC("CBC", "Cipher Block Chaining"),
    GCM("GCM", "Galois/Counter Mode"),
    ECB("ECB", "Electronic Codebook"),
    CFB("CFB", "Cipher Feedback"),
    OFB("OFB", "Output Feedback"),
    CTR("CTR", "Counter Mode")
}

@Parcelize
data class EncryptionConfig(
    val algorithm: EncryptionAlgorithm = EncryptionAlgorithm.AES256,
    val keySize: Int = 256,
    val mode: OperationMode = OperationMode.GCM,
    val password: String = "",
    val threadCount: Int = 4
) : Parcelable {
    
    companion object {
        val DEFAULT = EncryptionConfig()
    }
    
    fun copy(
        algorithm: EncryptionAlgorithm = this.algorithm,
        keySize: Int = this.keySize,
        mode: OperationMode = this.mode,
        password: String = this.password,
        threadCount: Int = this.threadCount
    ) = EncryptionConfig(algorithm, keySize, mode, password, threadCount)
}