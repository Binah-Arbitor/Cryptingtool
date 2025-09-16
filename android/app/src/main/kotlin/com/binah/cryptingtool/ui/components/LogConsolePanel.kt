package com.binah.cryptingtool.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.binah.cryptingtool.models.LogEntry
import com.binah.cryptingtool.models.LogLevel
import com.binah.cryptingtool.ui.theme.*

@Composable
fun LogConsolePanel(
    logEntries: List<LogEntry>,
    onClearLogs: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier.padding(20.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "SYSTEM LOG",
                        style = MaterialTheme.typography.titleMedium.copy(
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 1.sp
                        ),
                        color = TealAccent
                    )
                    
                    Spacer(modifier = Modifier.width(12.dp))
                    
                    Card(
                        colors = CardDefaults.cardColors(
                            containerColor = CyanAccent.copy(alpha = 0.2f)
                        ),
                        shape = RoundedCornerShape(6.dp)
                    ) {
                        Text(
                            text = "${logEntries.size}",
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                            style = MaterialTheme.typography.bodySmall.copy(
                                fontWeight = FontWeight.Bold
                            ),
                            color = CyanAccent
                        )
                    }
                }
                
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    IconButton(
                        onClick = onClearLogs,
                        colors = IconButtonDefaults.iconButtonColors(
                            contentColor = OrangeAccent
                        )
                    ) {
                        Icon(
                            imageVector = Icons.Default.Clear,
                            contentDescription = "Clear logs",
                            modifier = Modifier.size(20.dp)
                        )
                    }
                    
                    Icon(
                        imageVector = Icons.Default.Terminal,
                        contentDescription = null,
                        tint = TealAccent,
                        modifier = Modifier.size(24.dp)
                    )
                }
            }
            
            // Console display
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(300.dp),
                colors = CardDefaults.cardColors(
                    containerColor = DarkerGray
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                if (logEntries.isEmpty()) {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Icon(
                                imageVector = Icons.Default.Code,
                                contentDescription = null,
                                tint = LightGray.copy(alpha = 0.3f),
                                modifier = Modifier.size(48.dp)
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = "Console ready...",
                                style = MaterialTheme.typography.bodyMedium,
                                color = LightGray.copy(alpha = 0.5f),
                                fontFamily = FontFamily.Monospace
                            )
                        }
                    }
                } else {
                    LazyColumn(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(12.dp),
                        verticalArrangement = Arrangement.spacedBy(4.dp),
                        reverseLayout = false // Keep newest at top since we add to position 0
                    ) {
                        items(logEntries) { logEntry ->
                            LogEntryItem(logEntry = logEntry)
                        }
                    }
                }
            }
            
            // Log level indicators
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Real-time system monitoring",
                    style = MaterialTheme.typography.bodySmall,
                    color = LightGray.copy(alpha = 0.7f)
                )
                
                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    LogLevelIndicator(LogLevel.INFO, "Info")
                    LogLevelIndicator(LogLevel.SUCCESS, "Success")
                    LogLevelIndicator(LogLevel.WARNING, "Warning")
                    LogLevelIndicator(LogLevel.ERROR, "Error")
                }
            }
        }
    }
}

@Composable
private fun LogEntryItem(
    logEntry: LogEntry,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier.fillMaxWidth(),
        verticalAlignment = Alignment.Top
    ) {
        // Level indicator
        Box(
            modifier = Modifier
                .size(8.dp)
                .clip(CircleShape)
                .background(getLogLevelColor(logEntry.level))
        )
        
        Spacer(modifier = Modifier.width(8.dp))
        
        // Timestamp and source
        Column(
            modifier = Modifier.width(80.dp)
        ) {
            Text(
                text = logEntry.getFormattedTime(),
                style = MaterialTheme.typography.bodySmall.copy(
                    fontSize = 10.sp
                ),
                color = LightGray.copy(alpha = 0.6f),
                fontFamily = FontFamily.Monospace
            )
            if (!logEntry.source.isNullOrEmpty()) {
                Text(
                    text = logEntry.source!!,
                    style = MaterialTheme.typography.bodySmall.copy(
                        fontSize = 9.sp,
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = getLogLevelColor(logEntry.level).copy(alpha = 0.8f),
                    fontFamily = FontFamily.Monospace
                )
            }
        }
        
        Spacer(modifier = Modifier.width(12.dp))
        
        // Message
        Text(
            text = logEntry.message,
            style = MaterialTheme.typography.bodySmall.copy(
                fontSize = 11.sp
            ),
            color = LightGray,
            fontFamily = FontFamily.Monospace,
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
private fun LogLevelIndicator(
    level: LogLevel,
    label: String,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Box(
            modifier = Modifier
                .size(6.dp)
                .clip(CircleShape)
                .background(getLogLevelColor(level))
        )
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall.copy(
                fontSize = 10.sp
            ),
            color = LightGray.copy(alpha = 0.6f)
        )
    }
}

private fun getLogLevelColor(level: LogLevel): Color {
    return when (level) {
        LogLevel.INFO -> CyanAccent
        LogLevel.SUCCESS -> LimeGreen
        LogLevel.WARNING -> OrangeAccent
        LogLevel.ERROR -> ErrorRed
    }
}