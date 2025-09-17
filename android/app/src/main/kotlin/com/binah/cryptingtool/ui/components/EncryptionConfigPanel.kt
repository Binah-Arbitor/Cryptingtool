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
import com.binah.cryptingtool.models.EncryptionAlgorithm
import com.binah.cryptingtool.models.EncryptionConfig
import com.binah.cryptingtool.models.OperationMode
import com.binah.cryptingtool.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EncryptionConfigPanel(
    config: EncryptionConfig,
    isLocked: Boolean,
    onConfigChanged: (EncryptionConfig) -> Unit,
    modifier: Modifier = Modifier
) {
    var showAlgorithmDropdown by remember { mutableStateOf(false) }
    var showModeDropdown by remember { mutableStateOf(false) }
    var showKeySizeDropdown by remember { mutableStateOf(false) }
    
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
                    text = "ENCRYPTION CONFIGURATION",
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 1.sp
                    ),
                    color = TealAccent
                )
                
                Icon(
                    imageVector = Icons.Default.Security,
                    contentDescription = null,
                    tint = TealAccent,
                    modifier = Modifier.size(24.dp)
                )
            }
            
            // Algorithm selection
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "Algorithm",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = LightGray
                )
                
                ExposedDropdownMenuBox(
                    expanded = showAlgorithmDropdown,
                    onExpandedChange = { showAlgorithmDropdown = !isLocked && it }
                ) {
                    OutlinedTextField(
                        value = config.algorithm.displayName,
                        onValueChange = { },
                        readOnly = true,
                        enabled = !isLocked,
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(),
                        trailingIcon = {
                            ExposedDropdownMenuDefaults.TrailingIcon(
                                expanded = showAlgorithmDropdown
                            )
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = TealAccent,
                            unfocusedBorderColor = LightGray.copy(alpha = 0.3f),
                            focusedTextColor = LightGray,
                            unfocusedTextColor = LightGray
                        ),
                        shape = RoundedCornerShape(8.dp)
                    )
                    
                    ExposedDropdownMenu(
                        expanded = showAlgorithmDropdown,
                        onDismissRequest = { showAlgorithmDropdown = false }
                    ) {
                        EncryptionAlgorithm.entries.forEach { algorithm ->
                            DropdownMenuItem(
                                text = {
                                    Column {
                                        Text(
                                            text = algorithm.displayName,
                                            fontWeight = FontWeight.Medium
                                        )
                                        Text(
                                            text = algorithm.description,
                                            style = MaterialTheme.typography.bodySmall,
                                            color = LightGray.copy(alpha = 0.7f)
                                        )
                                    }
                                },
                                onClick = {
                                    onConfigChanged(config.copy(algorithm = algorithm))
                                    showAlgorithmDropdown = false
                                }
                            )
                        }
                    }
                }
                
                Text(
                    text = config.algorithm.description,
                    style = MaterialTheme.typography.bodySmall,
                    color = CyanAccent.copy(alpha = 0.8f)
                )
            }
            
            // Key size selection
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "Key Size",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = LightGray
                )
                
                ExposedDropdownMenuBox(
                    expanded = showKeySizeDropdown,
                    onExpandedChange = { showKeySizeDropdown = !isLocked && it }
                ) {
                    OutlinedTextField(
                        value = "${config.keySize} bits",
                        onValueChange = { },
                        readOnly = true,
                        enabled = !isLocked,
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(),
                        trailingIcon = {
                            ExposedDropdownMenuDefaults.TrailingIcon(
                                expanded = showKeySizeDropdown
                            )
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = TealAccent,
                            unfocusedBorderColor = LightGray.copy(alpha = 0.3f),
                            focusedTextColor = LightGray,
                            unfocusedTextColor = LightGray
                        ),
                        shape = RoundedCornerShape(8.dp)
                    )
                    
                    ExposedDropdownMenu(
                        expanded = showKeySizeDropdown,
                        onDismissRequest = { showKeySizeDropdown = false }
                    ) {
                        config.algorithm.getSupportedKeySizes().forEach { keySize ->
                            DropdownMenuItem(
                                text = {
                                    Text(
                                        text = "$keySize bits",
                                        fontWeight = FontWeight.Medium
                                    )
                                },
                                onClick = {
                                    onConfigChanged(config.copy(keySize = keySize))
                                    showKeySizeDropdown = false
                                }
                            )
                        }
                    }
                }
            }
            
            // Operation mode selection
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "Operation Mode",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = LightGray
                )
                
                ExposedDropdownMenuBox(
                    expanded = showModeDropdown,
                    onExpandedChange = { showModeDropdown = !isLocked && it }
                ) {
                    OutlinedTextField(
                        value = config.mode.displayName,
                        onValueChange = { },
                        readOnly = true,
                        enabled = !isLocked,
                        modifier = Modifier
                            .fillMaxWidth()
                            .menuAnchor(),
                        trailingIcon = {
                            ExposedDropdownMenuDefaults.TrailingIcon(
                                expanded = showModeDropdown
                            )
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = TealAccent,
                            unfocusedBorderColor = LightGray.copy(alpha = 0.3f),
                            focusedTextColor = LightGray,
                            unfocusedTextColor = LightGray
                        ),
                        shape = RoundedCornerShape(8.dp)
                    )
                    
                    ExposedDropdownMenu(
                        expanded = showModeDropdown,
                        onDismissRequest = { showModeDropdown = false }
                    ) {
                        config.algorithm.getSupportedModes().forEach { mode ->
                            DropdownMenuItem(
                                text = {
                                    Column {
                                        Text(
                                            text = mode.displayName,
                                            fontWeight = FontWeight.Medium
                                        )
                                        Text(
                                            text = mode.description,
                                            style = MaterialTheme.typography.bodySmall,
                                            color = LightGray.copy(alpha = 0.7f)
                                        )
                                    }
                                },
                                onClick = {
                                    onConfigChanged(config.copy(mode = mode))
                                    showModeDropdown = false
                                }
                            )
                        }
                    }
                }
                
                Text(
                    text = config.mode.description,
                    style = MaterialTheme.typography.bodySmall,
                    color = LimeGreen.copy(alpha = 0.8f)
                )
            }
            
            // Password input
            Column(
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    text = "Password",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontWeight = FontWeight.SemiBold
                    ),
                    color = LightGray
                )
                
                OutlinedTextField(
                    value = config.password,
                    onValueChange = { password ->
                        onConfigChanged(config.copy(password = password))
                    },
                    enabled = !isLocked,
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = {
                        Text(
                            text = "Enter encryption password",
                            color = LightGray.copy(alpha = 0.5f)
                        )
                    },
                    leadingIcon = {
                        Icon(
                            imageVector = Icons.Default.Key,
                            contentDescription = null,
                            tint = OrangeAccent,
                            modifier = Modifier.size(20.dp)
                        )
                    },
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = TealAccent,
                        unfocusedBorderColor = LightGray.copy(alpha = 0.3f),
                        focusedTextColor = LightGray,
                        unfocusedTextColor = LightGray
                    ),
                    shape = RoundedCornerShape(8.dp)
                )
            }
        }
    }
}