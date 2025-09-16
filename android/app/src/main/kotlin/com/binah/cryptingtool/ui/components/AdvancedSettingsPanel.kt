package com.binah.cryptingtool.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.binah.cryptingtool.models.EncryptionConfig
import com.binah.cryptingtool.ui.theme.*
import kotlin.math.roundToInt

@Composable
fun AdvancedSettingsPanel(
    config: EncryptionConfig,
    isLocked: Boolean,
    onConfigChanged: (EncryptionConfig) -> Unit,
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
                Text(
                    text = "ADVANCED",
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 1.sp
                    ),
                    color = TealAccent
                )
                
                Icon(
                    imageVector = Icons.Default.Settings,
                    contentDescription = null,
                    tint = TealAccent,
                    modifier = Modifier.size(24.dp)
                )
            }
            
            // Thread count setting
            Column(
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Threads",
                        style = MaterialTheme.typography.bodyMedium.copy(
                            fontWeight = FontWeight.SemiBold
                        ),
                        color = LightGray
                    )
                    
                    Card(
                        colors = CardDefaults.cardColors(
                            containerColor = CyanAccent.copy(alpha = 0.2f)
                        ),
                        shape = RoundedCornerShape(6.dp)
                    ) {
                        Text(
                            text = "${config.threadCount}",
                            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
                            style = MaterialTheme.typography.bodyMedium.copy(
                                fontWeight = FontWeight.Bold
                            ),
                            color = CyanAccent
                        )
                    }
                }
                
                Slider(
                    value = config.threadCount.toFloat(),
                    onValueChange = { value ->
                        if (!isLocked) {
                            onConfigChanged(config.copy(threadCount = value.roundToInt()))
                        }
                    },
                    enabled = !isLocked,
                    valueRange = 1f..16f,
                    steps = 15,
                    colors = SliderDefaults.colors(
                        thumbColor = TealAccent,
                        activeTrackColor = TealAccent.copy(alpha = 0.8f),
                        inactiveTrackColor = LightGray.copy(alpha = 0.3f)
                    )
                )
                
                Text(
                    text = "Optimal: 4-8 threads for most systems",
                    style = MaterialTheme.typography.bodySmall,
                    color = LightGray.copy(alpha = 0.7f)
                )
            }
            
            // Performance info
            Card(
                colors = CardDefaults.cardColors(
                    containerColor = DarkerGray
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                Column(
                    modifier = Modifier.padding(12.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Speed,
                            contentDescription = null,
                            tint = LimeGreen,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "Performance",
                            style = MaterialTheme.typography.bodySmall.copy(
                                fontWeight = FontWeight.SemiBold
                            ),
                            color = LimeGreen
                        )
                    }
                    
                    val performanceLevel = when {
                        config.threadCount <= 2 -> "Basic"
                        config.threadCount <= 4 -> "Balanced"
                        config.threadCount <= 8 -> "High"
                        else -> "Maximum"
                    }
                    
                    val performanceColor = when {
                        config.threadCount <= 2 -> OrangeAccent
                        config.threadCount <= 4 -> CyanAccent
                        config.threadCount <= 8 -> LimeGreen
                        else -> TealAccent
                    }
                    
                    Text(
                        text = "$performanceLevel Performance Mode",
                        style = MaterialTheme.typography.bodySmall,
                        color = performanceColor
                    )
                    
                    Text(
                        text = "Using ${config.threadCount} processing thread${if (config.threadCount == 1) "" else "s"}",
                        style = MaterialTheme.typography.bodySmall,
                        color = LightGray.copy(alpha = 0.7f)
                    )
                }
            }
            
            // Algorithm strength indicator
            Card(
                colors = CardDefaults.cardColors(
                    containerColor = DarkerGray
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                Column(
                    modifier = Modifier.padding(12.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Shield,
                            contentDescription = null,
                            tint = TealAccent,
                            modifier = Modifier.size(16.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(
                            text = "Security Level",
                            style = MaterialTheme.typography.bodySmall.copy(
                                fontWeight = FontWeight.SemiBold
                            ),
                            color = TealAccent
                        )
                    }
                    
                    val securityLevel = when {
                        config.algorithm.name.contains("256") -> "Maximum"
                        config.algorithm.name.contains("192") -> "High"
                        config.algorithm.name.contains("128") -> "Standard"
                        else -> "Variable"
                    }
                    
                    val securityColor = when {
                        config.algorithm.name.contains("256") -> TealAccent
                        config.algorithm.name.contains("192") -> LimeGreen
                        config.algorithm.name.contains("128") -> CyanAccent
                        else -> OrangeAccent
                    }
                    
                    Text(
                        text = "$securityLevel Security",
                        style = MaterialTheme.typography.bodySmall,
                        color = securityColor
                    )
                    
                    Text(
                        text = "${config.keySize}-bit encryption key",
                        style = MaterialTheme.typography.bodySmall,
                        color = LightGray.copy(alpha = 0.7f)
                    )
                }
            }
            
            // Quick presets
            Text(
                text = "Quick Presets",
                style = MaterialTheme.typography.bodyMedium.copy(
                    fontWeight = FontWeight.SemiBold
                ),
                color = LightGray
            )
            
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                FilterChip(
                    onClick = {
                        if (!isLocked) {
                            onConfigChanged(config.copy(threadCount = 2))
                        }
                    },
                    label = { Text("Low") },
                    selected = config.threadCount == 2,
                    enabled = !isLocked,
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = OrangeAccent.copy(alpha = 0.3f),
                        selectedLabelColor = OrangeAccent
                    )
                )
                
                FilterChip(
                    onClick = {
                        if (!isLocked) {
                            onConfigChanged(config.copy(threadCount = 4))
                        }
                    },
                    label = { Text("Balanced") },
                    selected = config.threadCount == 4,
                    enabled = !isLocked,
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = CyanAccent.copy(alpha = 0.3f),
                        selectedLabelColor = CyanAccent
                    )
                )
                
                FilterChip(
                    onClick = {
                        if (!isLocked) {
                            onConfigChanged(config.copy(threadCount = 8))
                        }
                    },
                    label = { Text("High") },
                    selected = config.threadCount == 8,
                    enabled = !isLocked,
                    colors = FilterChipDefaults.filterChipColors(
                        selectedContainerColor = LimeGreen.copy(alpha = 0.3f),
                        selectedLabelColor = LimeGreen
                    )
                )
            }
        }
    }
}