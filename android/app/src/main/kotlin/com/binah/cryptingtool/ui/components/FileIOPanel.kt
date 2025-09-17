package com.binah.cryptingtool.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import com.binah.cryptingtool.models.FileInfo
import com.binah.cryptingtool.ui.theme.*

@Composable
fun FileIOPanel(
    selectedFile: FileInfo?,
    isProcessing: Boolean,
    onFileSelect: () -> Unit,
    onEncrypt: () -> Unit,
    onDecrypt: () -> Unit,
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
                    text = "FILE I/O OPERATIONS",
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 1.sp
                    ),
                    color = TealAccent
                )
                
                Icon(
                    imageVector = Icons.Default.Folder,
                    contentDescription = null,
                    tint = TealAccent,
                    modifier = Modifier.size(24.dp)
                )
            }
            
            // File selection section
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = DarkerGray
                ),
                shape = RoundedCornerShape(8.dp)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Selected File",
                            style = MaterialTheme.typography.bodyMedium.copy(
                                fontWeight = FontWeight.SemiBold
                            ),
                            color = LightGray
                        )
                        
                        Button(
                            onClick = onFileSelect,
                            enabled = !isProcessing,
                            colors = ButtonDefaults.buttonColors(
                                containerColor = TealAccent.copy(alpha = 0.2f),
                                contentColor = TealAccent
                            ),
                            shape = RoundedCornerShape(8.dp)
                        ) {
                            Icon(
                                imageVector = Icons.Default.AttachFile,
                                contentDescription = null,
                                modifier = Modifier.size(18.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("SELECT FILE")
                        }
                    }
                    
                    if (selectedFile != null) {
                        // File information display
                        Card(
                            colors = CardDefaults.cardColors(
                                containerColor = DarkGray.copy(alpha = 0.3f)
                            ),
                            shape = RoundedCornerShape(6.dp)
                        ) {
                            Column(
                                modifier = Modifier.padding(12.dp),
                                verticalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                Row(
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.Description,
                                        contentDescription = null,
                                        tint = CyanAccent,
                                        modifier = Modifier.size(20.dp)
                                    )
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text(
                                        text = selectedFile.name,
                                        style = MaterialTheme.typography.bodyMedium.copy(
                                            fontWeight = FontWeight.Medium
                                        ),
                                        color = LightGray
                                    )
                                }
                                
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween
                                ) {
                                    Text(
                                        text = "Size: ${selectedFile.getFormattedSize()}",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = LightGray.copy(alpha = 0.7f)
                                    )
                                    Text(
                                        text = "Modified: ${selectedFile.getFormattedLastModified()}",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = LightGray.copy(alpha = 0.7f)
                                    )
                                }
                                
                                if (selectedFile.extension.isNotEmpty()) {
                                    Text(
                                        text = "Type: ${selectedFile.extension.uppercase()}",
                                        style = MaterialTheme.typography.bodySmall,
                                        color = OrangeAccent
                                    )
                                }
                            }
                        }
                    } else {
                        // No file selected placeholder
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(80.dp)
                                .background(
                                    DarkGray.copy(alpha = 0.3f),
                                    RoundedCornerShape(6.dp)
                                )
                                .border(
                                    1.dp,
                                    LightGray.copy(alpha = 0.2f),
                                    RoundedCornerShape(6.dp)
                                ),
                            contentAlignment = Alignment.Center
                        ) {
                            Column(
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Default.FileUpload,
                                    contentDescription = null,
                                    tint = LightGray.copy(alpha = 0.5f),
                                    modifier = Modifier.size(32.dp)
                                )
                                Text(
                                    text = "No file selected",
                                    style = MaterialTheme.typography.bodySmall,
                                    color = LightGray.copy(alpha = 0.5f)
                                )
                            }
                        }
                    }
                }
            }
            
            // Operation buttons
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Button(
                    onClick = onEncrypt,
                    enabled = selectedFile != null && !isProcessing,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = LimeGreen.copy(alpha = 0.2f),
                        contentColor = LimeGreen
                    ),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.Lock,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "ENCRYPT",
                        fontWeight = FontWeight.Bold
                    )
                }
                
                Button(
                    onClick = onDecrypt,
                    enabled = selectedFile != null && !isProcessing,
                    modifier = Modifier.weight(1f),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = OrangeAccent.copy(alpha = 0.2f),
                        contentColor = OrangeAccent
                    ),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.LockOpen,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "DECRYPT",
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}