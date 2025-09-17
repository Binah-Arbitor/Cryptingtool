package com.binah.cryptingtool.crypto

import com.binah.cryptingtool.models.EncryptionAlgorithm
import com.binah.cryptingtool.models.EncryptionConfig
import com.binah.cryptingtool.models.OperationMode

object CryptoConstants {
    // Algorithm identifiers - Tier 1-2: Modern High Security
    const val ALGORITHM_AES = 1
    const val ALGORITHM_SERPENT = 2
    const val ALGORITHM_TWOFISH = 3
    
    // Tier 3: Strong Security - AES Finalists & Modern Ciphers
    const val ALGORITHM_RC6 = 4
    const val ALGORITHM_MARS = 5
    const val ALGORITHM_RC5 = 6
    const val ALGORITHM_SKIPJACK = 7
    
    // Tier 4: Reliable Security - Established Algorithms
    const val ALGORITHM_BLOWFISH = 8
    const val ALGORITHM_CAST128 = 9
    const val ALGORITHM_CAST256 = 10
    const val ALGORITHM_CAMELLIA = 11
    
    // Tier 5: Stream Ciphers - High Performance
    const val ALGORITHM_CHACHA20 = 12
    const val ALGORITHM_SALSA20 = 13
    const val ALGORITHM_XSALSA20 = 14
    const val ALGORITHM_HC128 = 15
    const val ALGORITHM_HC256 = 16
    const val ALGORITHM_RABBIT = 17
    const val ALGORITHM_SOSEMANUK = 18
    
    // Tier 6: Specialized & National Algorithms
    const val ALGORITHM_ARIA = 19
    const val ALGORITHM_SEED = 20
    const val ALGORITHM_SM4 = 21
    const val ALGORITHM_GOST28147 = 22
    
    // Tier 7: Legacy Strong Algorithms
    const val ALGORITHM_DES3 = 23
    const val ALGORITHM_IDEA = 24
    const val ALGORITHM_RC2 = 25
    const val ALGORITHM_SAFER = 26
    const val ALGORITHM_SAFER_PLUS = 27
    
    // Tier 8: Historical & Compatibility
    const val ALGORITHM_DES = 28
    const val ALGORITHM_RC4 = 29
    
    // Mode identifiers
    const val MODE_CBC = 1
    const val MODE_GCM = 2
    const val MODE_ECB = 3
    const val MODE_CFB = 4
    const val MODE_OFB = 5
    const val MODE_CTR = 6
    
    // Operation types
    const val OPERATION_ENCRYPT = 1
    const val OPERATION_DECRYPT = 2
    
    // Status codes
    const val STATUS_SUCCESS = 0
    const val STATUS_INVALID_PARAMS = -1
    const val STATUS_UNSUPPORTED_ALGORITHM = -2
    const val STATUS_UNSUPPORTED_MODE = -3
    const val STATUS_INVALID_KEY_SIZE = -4
    const val STATUS_MEMORY_ERROR = -5
    const val STATUS_CRYPTO_ERROR = -6
    const val STATUS_PASSWORD_TOO_SHORT = -7
    const val STATUS_OUTPUT_BUFFER_TOO_SMALL = -8
    const val STATUS_UNKNOWN_ERROR = -9
    
    fun algorithmToNative(algorithm: EncryptionAlgorithm): Int {
        return when (algorithm) {
            EncryptionAlgorithm.AES256, EncryptionAlgorithm.AES192, EncryptionAlgorithm.AES128 -> ALGORITHM_AES
            EncryptionAlgorithm.SERPENT256, EncryptionAlgorithm.SERPENT192, EncryptionAlgorithm.SERPENT128 -> ALGORITHM_SERPENT
            EncryptionAlgorithm.TWOFISH256, EncryptionAlgorithm.TWOFISH192, EncryptionAlgorithm.TWOFISH128 -> ALGORITHM_TWOFISH
            EncryptionAlgorithm.RC6 -> ALGORITHM_RC6
            EncryptionAlgorithm.MARS -> ALGORITHM_MARS
            EncryptionAlgorithm.RC5 -> ALGORITHM_RC5
            EncryptionAlgorithm.SKIPJACK -> ALGORITHM_SKIPJACK
            EncryptionAlgorithm.BLOWFISH -> ALGORITHM_BLOWFISH
            EncryptionAlgorithm.CAST128 -> ALGORITHM_CAST128
            EncryptionAlgorithm.CAST256 -> ALGORITHM_CAST256
            EncryptionAlgorithm.CAMELLIA -> ALGORITHM_CAMELLIA
            EncryptionAlgorithm.CHACHA20 -> ALGORITHM_CHACHA20
            EncryptionAlgorithm.SALSA20 -> ALGORITHM_SALSA20
            EncryptionAlgorithm.XSALSA20 -> ALGORITHM_XSALSA20
            EncryptionAlgorithm.HC128 -> ALGORITHM_HC128
            EncryptionAlgorithm.HC256 -> ALGORITHM_HC256
            EncryptionAlgorithm.RABBIT -> ALGORITHM_RABBIT
            EncryptionAlgorithm.SOSEMANUK -> ALGORITHM_SOSEMANUK
            EncryptionAlgorithm.ARIA -> ALGORITHM_ARIA
            EncryptionAlgorithm.SEED -> ALGORITHM_SEED
            EncryptionAlgorithm.SM4 -> ALGORITHM_SM4
            EncryptionAlgorithm.GOST28147 -> ALGORITHM_GOST28147
            EncryptionAlgorithm.DES3 -> ALGORITHM_DES3
            EncryptionAlgorithm.IDEA -> ALGORITHM_IDEA
            EncryptionAlgorithm.RC2 -> ALGORITHM_RC2
            EncryptionAlgorithm.SAFER -> ALGORITHM_SAFER
            EncryptionAlgorithm.SAFER_PLUS -> ALGORITHM_SAFER_PLUS
            EncryptionAlgorithm.DES -> ALGORITHM_DES
            EncryptionAlgorithm.RC4 -> ALGORITHM_RC4
        }
    }
    
    fun modeToNative(mode: OperationMode): Int {
        return when (mode) {
            OperationMode.CBC -> MODE_CBC
            OperationMode.GCM -> MODE_GCM
            OperationMode.ECB -> MODE_ECB
            OperationMode.CFB -> MODE_CFB
            OperationMode.OFB -> MODE_OFB
            OperationMode.CTR -> MODE_CTR
        }
    }
}