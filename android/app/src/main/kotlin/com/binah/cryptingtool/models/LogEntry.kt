package com.binah.cryptingtool.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.util.Date

enum class LogLevel(val displayName: String, val description: String) {
    INFO("INFO", "Information"),
    WARNING("WARNING", "Warning"),
    ERROR("ERROR", "Error"),
    SUCCESS("SUCCESS", "Success")
}

@Parcelize
data class LogEntry(
    val timestamp: Date = Date(),
    val level: LogLevel,
    val message: String,
    val source: String? = null
) : Parcelable {
    companion object {
        fun info(message: String, source: String? = null) = LogEntry(
            level = LogLevel.INFO,
            message = message,
            source = source
        )
        
        fun warning(message: String, source: String? = null) = LogEntry(
            level = LogLevel.WARNING,
            message = message,
            source = source
        )
        
        fun error(message: String, source: String? = null) = LogEntry(
            level = LogLevel.ERROR,
            message = message,
            source = source
        )
        
        fun success(message: String, source: String? = null) = LogEntry(
            level = LogLevel.SUCCESS,
            message = message,
            source = source
        )
    }
    
    fun getFormattedTime(): String {
        val now = Date()
        val difference = now.time - timestamp.time
        val seconds = difference / 1000
        val minutes = seconds / 60
        val hours = minutes / 60
        
        return when {
            hours > 0 -> "${hours}h ago"
            minutes > 0 -> "${minutes}m ago"
            seconds > 10 -> "${seconds}s ago"
            else -> "Just now"
        }
    }
}