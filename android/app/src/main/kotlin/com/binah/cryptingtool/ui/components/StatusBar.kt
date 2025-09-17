package com.binah.cryptingtool.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.binah.cryptingtool.models.ProcessingProgress
import com.binah.cryptingtool.models.ProcessingStatus
import com.binah.cryptingtool.ui.theme.*

@Composable
fun StatusBar(
    progress: ProcessingProgress,
    statusMessage: String,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        shape = RoundedCornerShape(12.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Status header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    StatusIcon(progress.status)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = progress.status.displayName.uppercase(),
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 1.sp
                        ),
                        color = getStatusColor(progress.status)
                    )
                }
                
                if (progress.status == ProcessingStatus.PROCESSING) {
                    Text(
                        text = progress.getFormattedProgress(),
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = CyanAccent
                    )
                }
            }
            
            // Progress bar (only shown when processing)
            if (progress.status == ProcessingStatus.PROCESSING) {
                Column(
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    LinearProgressIndicator(
                        progress = { progress.getByteProgress() },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(6.dp)
                            .clip(RoundedCornerShape(3.dp)),
                        color = CyanAccent,
                        trackColor = LightGray.copy(alpha = 0.2f),
                        strokeCap = StrokeCap.Round,
                    )
                    
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(
                            text = progress.getEstimatedTimeRemaining(),
                            style = MaterialTheme.typography.bodySmall,
                            color = LightGray.copy(alpha = 0.7f)
                        )
                        
                        Text(
                            text = "${progress.bytesProcessed}/${progress.totalBytes} bytes",
                            style = MaterialTheme.typography.bodySmall,
                            color = LightGray.copy(alpha = 0.7f)
                        )
                    }
                }
            }
            
            // Status message
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Default.Info,
                    contentDescription = null,
                    tint = LightGray.copy(alpha = 0.6f),
                    modifier = Modifier.size(16.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = statusMessage,
                    style = MaterialTheme.typography.bodyMedium,
                    color = LightGray
                )
            }
            
            // Current operation (if available)
            if (!progress.currentOperation.isNullOrEmpty()) {
                Row(
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.PlayArrow,
                        contentDescription = null,
                        tint = CyanAccent,
                        modifier = Modifier.size(16.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = progress.currentOperation!!,
                        style = MaterialTheme.typography.bodySmall.copy(
                            fontWeight = FontWeight.Medium
                        ),
                        color = CyanAccent
                    )
                }
            }
        }
    }
}

@Composable
private fun StatusIcon(status: ProcessingStatus) {
    when (status) {
        ProcessingStatus.READY -> {
            Icon(
                imageVector = Icons.Default.CheckCircle,
                contentDescription = null,
                tint = LimeGreen,
                modifier = Modifier.size(20.dp)
            )
        }
        ProcessingStatus.PROCESSING -> {
            val rotation by rememberInfiniteTransition(label = "processingRotation").animateFloat(
                initialValue = 0f,
                targetValue = 360f,
                animationSpec = infiniteRepeatable(
                    animation = tween(1000, easing = LinearEasing),
                    repeatMode = RepeatMode.Restart
                ),
                label = "rotation"
            )
            
            Icon(
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = CyanAccent,
                modifier = Modifier
                    .size(20.dp)
                    .graphicsLayer { rotationZ = rotation }
            )
        }
        ProcessingStatus.SUCCESS -> {
            Icon(
                imageVector = Icons.Default.CheckCircle,
                contentDescription = null,
                tint = LimeGreen,
                modifier = Modifier.size(20.dp)
            )
        }
        ProcessingStatus.ERROR -> {
            Icon(
                imageVector = Icons.Default.Error,
                contentDescription = null,
                tint = ErrorRed,
                modifier = Modifier.size(20.dp)
            )
        }
        ProcessingStatus.PAUSED -> {
            Icon(
                imageVector = Icons.Default.Pause,
                contentDescription = null,
                tint = OrangeAccent,
                modifier = Modifier.size(20.dp)
            )
        }
        ProcessingStatus.CANCELLED -> {
            Icon(
                imageVector = Icons.Default.Cancel,
                contentDescription = null,
                tint = ErrorRed,
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

private fun getStatusColor(status: ProcessingStatus) = when (status) {
    ProcessingStatus.READY -> LimeGreen
    ProcessingStatus.PROCESSING -> CyanAccent
    ProcessingStatus.SUCCESS -> LimeGreen
    ProcessingStatus.ERROR -> ErrorRed
    ProcessingStatus.PAUSED -> OrangeAccent
    ProcessingStatus.CANCELLED -> ErrorRed
}