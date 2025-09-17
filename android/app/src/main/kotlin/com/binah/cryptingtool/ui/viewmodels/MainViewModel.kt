package com.binah.cryptingtool.ui.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.binah.cryptingtool.crypto.CryptoBridgeService
import com.binah.cryptingtool.models.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.File
import java.util.Date

class MainViewModel : ViewModel() {
    
    private val cryptoBridge = CryptoBridgeService()
    
    // Configuration
    private val _config = MutableStateFlow(EncryptionConfig.DEFAULT)
    val config: StateFlow<EncryptionConfig> = _config.asStateFlow()
    
    // File management
    private val _selectedFile = MutableStateFlow<FileInfo?>(null)
    val selectedFile: StateFlow<FileInfo?> = _selectedFile.asStateFlow()
    
    // Processing state
    private val _progress = MutableStateFlow(ProcessingProgress())
    val progress: StateFlow<ProcessingProgress> = _progress.asStateFlow()
    
    // Logging
    private val _logEntries = MutableStateFlow<List<LogEntry>>(emptyList())
    val logEntries: StateFlow<List<LogEntry>> = _logEntries.asStateFlow()
    
    // Status
    private val _statusMessage = MutableStateFlow("System ready")
    val statusMessage: StateFlow<String> = _statusMessage.asStateFlow()
    
    private val _isProcessing = MutableStateFlow(false)
    val isProcessing: StateFlow<Boolean> = _isProcessing.asStateFlow()
    
    private val _isInitialized = MutableStateFlow(false)
    val isInitialized: StateFlow<Boolean> = _isInitialized.asStateFlow()
    
    init {
        initializeSystem()
    }
    
    fun initializeSystem() {
        viewModelScope.launch {
            addLog(LogEntry.info("Initializing CryptingTool system...", "SYSTEM"))
            
            val initialized = CryptoBridgeService.initialize()
            _isInitialized.value = initialized
            
            if (initialized) {
                addLog(LogEntry.success("System initialized successfully", "SYSTEM"))
                _statusMessage.value = "Ready for operations"
                
                // Test crypto functionality
                val testResult = CryptoBridgeService.testRoundTrip()
                if (testResult) {
                    addLog(LogEntry.success("Backend functionality verified", "CRYPTO"))
                } else {
                    addLog(LogEntry.warning("Backend test failed, but continuing...", "CRYPTO"))
                }
            } else {
                addLog(LogEntry.error("Failed to initialize system", "SYSTEM"))
                _statusMessage.value = "System initialization failed"
            }
        }
    }
    
    fun updateConfig(newConfig: EncryptionConfig) {
        _config.value = newConfig
        addLog(LogEntry.info(
            "Configuration updated: ${newConfig.algorithm.displayName} ${newConfig.keySize}-bit ${newConfig.mode.displayName}",
            "CONFIG"
        ))
    }
    
    fun selectFile(file: File) {
        try {
            val fileInfo = FileInfo.fromFile(file)
            _selectedFile.value = fileInfo
            addLog(LogEntry.info(
                "File selected: ${fileInfo.name} (${fileInfo.getFormattedSize()})",
                "FILE"
            ))
            _statusMessage.value = "File selected: ${fileInfo.name}"
        } catch (e: Exception) {
            addLog(LogEntry.error("Failed to select file: ${e.message}", "FILE"))
        }
    }
    
    fun encryptFile() {
        val currentFile = _selectedFile.value
        if (currentFile == null) {
            addLog(LogEntry.error("No file selected for encryption", "CRYPTO"))
            return
        }
        
        viewModelScope.launch {
            try {
                _isProcessing.value = true
                _statusMessage.value = "Encrypting ${currentFile.name}..."
                
                addLog(LogEntry.info(
                    "Starting encryption: ${_config.value.algorithm.displayName} ${_config.value.keySize}-bit ${_config.value.mode.displayName}",
                    "CRYPTO"
                ))
                
                val inputFile = File(currentFile.path)
                val outputFile = File(currentFile.path + ".encrypted")
                
                // Update progress
                _progress.value = _progress.value.copy(
                    status = ProcessingStatus.PROCESSING,
                    currentOperation = "Encrypting file...",
                    totalBytes = currentFile.size,
                    totalChunks = 1
                )
                
                val startTime = System.currentTimeMillis()
                val success = cryptoBridge.encryptFile(_config.value, inputFile, outputFile)
                val endTime = System.currentTimeMillis()
                
                if (success) {
                    _progress.value = _progress.value.copy(
                        status = ProcessingStatus.SUCCESS,
                        currentChunk = 1,
                        bytesProcessed = currentFile.size,
                        elapsedMillis = endTime - startTime,
                        currentOperation = "Encryption complete"
                    )
                    
                    addLog(LogEntry.success(
                        "File encrypted successfully: ${outputFile.name}",
                        "CRYPTO"
                    ))
                    _statusMessage.value = "Encryption completed successfully"
                } else {
                    _progress.value = _progress.value.copy(
                        status = ProcessingStatus.ERROR,
                        currentOperation = "Encryption failed"
                    )
                    addLog(LogEntry.error("Encryption failed", "CRYPTO"))
                    _statusMessage.value = "Encryption failed"
                }
            } catch (e: Exception) {
                _progress.value = _progress.value.copy(
                    status = ProcessingStatus.ERROR,
                    currentOperation = "Encryption error"
                )
                addLog(LogEntry.error("Encryption error: ${e.message}", "CRYPTO"))
                _statusMessage.value = "Encryption error occurred"
            } finally {
                _isProcessing.value = false
            }
        }
    }
    
    fun decryptFile() {
        val currentFile = _selectedFile.value
        if (currentFile == null) {
            addLog(LogEntry.error("No file selected for decryption", "CRYPTO"))
            return
        }
        
        viewModelScope.launch {
            try {
                _isProcessing.value = true
                _statusMessage.value = "Decrypting ${currentFile.name}..."
                
                addLog(LogEntry.info(
                    "Starting decryption: ${_config.value.algorithm.displayName} ${_config.value.keySize}-bit ${_config.value.mode.displayName}",
                    "CRYPTO"
                ))
                
                val inputFile = File(currentFile.path)
                val outputPath = if (currentFile.path.endsWith(".encrypted")) {
                    currentFile.path.removeSuffix(".encrypted")
                } else {
                    currentFile.path + ".decrypted"
                }
                val outputFile = File(outputPath)
                
                // Update progress
                _progress.value = _progress.value.copy(
                    status = ProcessingStatus.PROCESSING,
                    currentOperation = "Decrypting file...",
                    totalBytes = currentFile.size,
                    totalChunks = 1
                )
                
                val startTime = System.currentTimeMillis()
                val success = cryptoBridge.decryptFile(_config.value, inputFile, outputFile)
                val endTime = System.currentTimeMillis()
                
                if (success) {
                    _progress.value = _progress.value.copy(
                        status = ProcessingStatus.SUCCESS,
                        currentChunk = 1,
                        bytesProcessed = currentFile.size,
                        elapsedMillis = endTime - startTime,
                        currentOperation = "Decryption complete"
                    )
                    
                    addLog(LogEntry.success(
                        "File decrypted successfully: ${outputFile.name}",
                        "CRYPTO"
                    ))
                    _statusMessage.value = "Decryption completed successfully"
                } else {
                    _progress.value = _progress.value.copy(
                        status = ProcessingStatus.ERROR,
                        currentOperation = "Decryption failed"
                    )
                    addLog(LogEntry.error("Decryption failed", "CRYPTO"))
                    _statusMessage.value = "Decryption failed"
                }
            } catch (e: Exception) {
                _progress.value = _progress.value.copy(
                    status = ProcessingStatus.ERROR,
                    currentOperation = "Decryption error"
                )
                addLog(LogEntry.error("Decryption error: ${e.message}", "CRYPTO"))
                _statusMessage.value = "Decryption error occurred"
            } finally {
                _isProcessing.value = false
            }
        }
    }
    
    fun cancelOperation() {
        viewModelScope.launch {
            _isProcessing.value = false
            _progress.value = _progress.value.copy(
                status = ProcessingStatus.CANCELLED,
                currentOperation = "Operation cancelled"
            )
            addLog(LogEntry.warning("Operation cancelled by user", "SYSTEM"))
            _statusMessage.value = "Operation cancelled"
        }
    }
    
    fun clearLogs() {
        _logEntries.value = emptyList()
        addLog(LogEntry.info("Log console cleared", "SYSTEM"))
    }
    
    private fun addLog(logEntry: LogEntry) {
        val currentLogs = _logEntries.value.toMutableList()
        currentLogs.add(0, logEntry) // Add to top
        
        // Keep only last 100 entries
        if (currentLogs.size > 100) {
            currentLogs.removeAt(currentLogs.size - 1)
        }
        
        _logEntries.value = currentLogs
    }
}