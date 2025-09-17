package com.binah.cryptingtool.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.io.File
import java.util.Date

enum class ProcessingStatus(val displayName: String, val description: String) {
    READY("Ready", "System ready for operations"),
    PROCESSING("Processing", "Operation in progress"),
    SUCCESS("Success", "Operation completed successfully"),
    ERROR("Error", "Operation failed"),
    PAUSED("Paused", "Operation paused"),
    CANCELLED("Cancelled", "Operation cancelled")
}

@Parcelize
data class FileInfo(
    val path: String,
    val name: String,
    val size: Long,
    val extension: String,
    val lastModified: Date
) : Parcelable {
    
    companion object {
        fun fromFile(file: File): FileInfo {
            val name = file.name
            val extension = if (name.contains('.')) {
                name.substringAfterLast('.').lowercase()
            } else ""
            
            return FileInfo(
                path = file.absolutePath,
                name = name,
                size = file.length(),
                extension = extension,
                lastModified = Date(file.lastModified())
            )
        }
    }
    
    fun getFormattedSize(): String {
        return when {
            size < 1024 -> "$size B"
            size < 1024 * 1024 -> "%.1f KB".format(size / 1024.0)
            size < 1024 * 1024 * 1024 -> "%.1f MB".format(size / (1024.0 * 1024.0))
            else -> "%.1f GB".format(size / (1024.0 * 1024.0 * 1024.0))
        }
    }
    
    fun getFormattedLastModified(): String {
        val now = Date()
        val difference = now.time - lastModified.time
        val days = difference / (1000 * 60 * 60 * 24)
        val hours = difference / (1000 * 60 * 60)
        val minutes = difference / (1000 * 60)
        
        return when {
            days > 0 -> "${days} days ago"
            hours > 0 -> "${hours} hours ago"
            minutes > 0 -> "${minutes} minutes ago"
            else -> "Just now"
        }
    }
}

@Parcelize
data class ProcessingProgress(
    val currentChunk: Int = 0,
    val totalChunks: Int = 0,
    val bytesProcessed: Long = 0,
    val totalBytes: Long = 0,
    val elapsedMillis: Long = 0,
    val status: ProcessingStatus = ProcessingStatus.READY,
    val currentOperation: String? = null
) : Parcelable {
    
    fun getChunkProgress(): Float {
        return if (totalChunks == 0) 0f else currentChunk.toFloat() / totalChunks.toFloat()
    }
    
    fun getByteProgress(): Float {
        return if (totalBytes == 0L) 0f else bytesProcessed.toFloat() / totalBytes.toFloat()
    }
    
    fun getFormattedProgress(): String {
        val percentage = (getByteProgress() * 100).let { "%.1f".format(it) }
        return "$percentage% ($currentChunk/$totalChunks chunks)"
    }
    
    fun getEstimatedTimeRemaining(): String {
        if (bytesProcessed == 0L || elapsedMillis == 0L) return "Calculating..."
        
        val bytesPerSecond = bytesProcessed * 1000.0 / elapsedMillis
        val remainingBytes = totalBytes - bytesProcessed
        val remainingSeconds = (remainingBytes / bytesPerSecond).toInt()
        
        return when {
            remainingSeconds < 60 -> "${remainingSeconds}s remaining"
            remainingSeconds < 3600 -> "${remainingSeconds / 60}m remaining"
            else -> "${remainingSeconds / 3600}h remaining"
        }
    }
}