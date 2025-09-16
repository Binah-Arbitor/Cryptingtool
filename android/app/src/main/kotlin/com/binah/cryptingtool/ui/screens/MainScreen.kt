package com.binah.cryptingtool.ui.screens

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.binah.cryptingtool.models.ProcessingStatus
import com.binah.cryptingtool.ui.components.*
import com.binah.cryptingtool.ui.theme.*
import com.binah.cryptingtool.ui.viewmodels.MainViewModel
import java.io.File

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(
    viewModel: MainViewModel
) {
    val config by viewModel.config.collectAsStateWithLifecycle()
    val selectedFile by viewModel.selectedFile.collectAsStateWithLifecycle()
    val progress by viewModel.progress.collectAsStateWithLifecycle()
    val logEntries by viewModel.logEntries.collectAsStateWithLifecycle()
    val statusMessage by viewModel.statusMessage.collectAsStateWithLifecycle()
    val isProcessing by viewModel.isProcessing.collectAsStateWithLifecycle()
    
    val context = LocalContext.current
    val filePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri ->
        uri?.let {
            try {
                val file = File(it.path ?: "")
                if (file.exists()) {
                    viewModel.selectFile(file)
                }
            } catch (e: Exception) {
                // Handle file selection error
            }
        }
    }
    
    Box {
        // Animated background
        AnimatedBackground()
        
        Column {
            // Top App Bar
            TopAppBar(
                title = {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // CPU Chip Icon
                        CpuChipIcon(
                            size = 32.dp,
                            showGlow = true
                        )
                        
                        Spacer(modifier = Modifier.width(12.dp))
                        
                        Column {
                            Text(
                                text = "CRYPTINGTOOL",
                                style = MaterialTheme.typography.headlineMedium.copy(
                                    fontWeight = FontWeight.Bold,
                                    letterSpacing = 1.2.sp
                                )
                            )
                            Text(
                                text = "High-Performance Encryption Suite",
                                style = MaterialTheme.typography.bodySmall.copy(
                                    color = CyanAccent,
                                    fontSize = 10.sp,
                                    letterSpacing = 0.5.sp
                                )
                            )
                        }
                    }
                },
                actions = {
                    // System status indicator
                    Row(
                        modifier = Modifier.padding(end = 16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .clip(CircleShape)
                                .background(
                                    if (isProcessing) CyanAccent else LimeGreen
                                )
                        )
                        
                        Spacer(modifier = Modifier.width(8.dp))
                        
                        Text(
                            text = if (isProcessing) "PROCESSING" else "READY",
                            style = MaterialTheme.typography.bodySmall.copy(
                                color = if (isProcessing) CyanAccent else LimeGreen,
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 10.sp
                            )
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
            
            // Main content
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                // File I/O Panel
                FileIOPanel(
                    selectedFile = selectedFile,
                    isProcessing = isProcessing,
                    onFileSelect = { filePickerLauncher.launch("*/*") },
                    onEncrypt = { viewModel.encryptFile() },
                    onDecrypt = { viewModel.decryptFile() }
                )
                
                // Configuration panels row
                Row(
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    // Encryption Configuration Panel
                    EncryptionConfigPanel(
                        modifier = Modifier.weight(2f),
                        config = config,
                        isLocked = isProcessing,
                        onConfigChanged = { viewModel.updateConfig(it) }
                    )
                    
                    // Advanced Settings Panel
                    AdvancedSettingsPanel(
                        modifier = Modifier.weight(1f),
                        config = config,
                        isLocked = isProcessing,
                        onConfigChanged = { viewModel.updateConfig(it) }
                    )
                }
                
                // Log Console Panel
                LogConsolePanel(
                    logEntries = logEntries,
                    onClearLogs = { viewModel.clearLogs() }
                )
                
                // Bottom space for status bar
                Spacer(modifier = Modifier.height(80.dp))
            }
        }
        
        // Bottom status bar
        StatusBar(
            modifier = Modifier.align(Alignment.BottomCenter),
            progress = progress,
            statusMessage = statusMessage
        )
        
        // Floating action button for emergency stop
        if (isProcessing) {
            FloatingActionButton(
                onClick = { viewModel.cancelOperation() },
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .padding(16.dp),
                containerColor = ErrorRed,
                contentColor = LightGray
            ) {
                Icon(
                    imageVector = Icons.Default.Stop,
                    contentDescription = "Cancel Operation"
                )
            }
        }
    }
}

@Composable
private fun AnimatedBackground() {
    val animationValue by rememberInfiniteTransition(label = "background").animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(10000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "backgroundAnimation"
    )
    
    Canvas(
        modifier = Modifier.fillMaxSize()
    ) {
        drawCircuitPattern(animationValue)
    }
}

private fun DrawScope.drawCircuitPattern(animationValue: Float) {
    val spacing = 100.dp.toPx()
    val offset = animationValue * spacing
    
    // Draw grid pattern
    val gridColor = TealAccent.copy(alpha = 0.02f)
    for (x in (-offset.toInt() until size.width.toInt() step spacing.toInt())) {
        drawLine(
            color = gridColor,
            start = Offset(x, 0f),
            end = Offset(x, size.height),
            strokeWidth = 0.5.dp.toPx()
        )
    }
    
    for (y in (-offset.toInt() until size.height.toInt() step spacing.toInt())) {
        drawLine(
            color = gridColor,
            start = Offset(0f, y),
            end = Offset(size.width, y),
            strokeWidth = 0.5.dp.toPx()
        )
    }
    
    // Draw animated circuit paths
    val pathColor = TealAccent.copy(alpha = 0.05f)
    val pathCount = 8
    for (i in 0 until pathCount) {
        val startX = (size.width / pathCount) * i
        val animatedY = (animationValue * size.height * 2) % size.height
        
        // Draw circuit path
        drawLine(
            color = pathColor,
            start = Offset(startX, animatedY),
            end = Offset(startX + 50.dp.toPx(), animatedY),
            strokeWidth = 1.dp.toPx()
        )
        drawLine(
            color = pathColor,
            start = Offset(startX + 50.dp.toPx(), animatedY),
            end = Offset(startX + 50.dp.toPx(), animatedY + 30.dp.toPx()),
            strokeWidth = 1.dp.toPx()
        )
        drawLine(
            color = pathColor,
            start = Offset(startX + 50.dp.toPx(), animatedY + 30.dp.toPx()),
            end = Offset(startX + 100.dp.toPx(), animatedY + 30.dp.toPx()),
            strokeWidth = 1.dp.toPx()
        )
        
        // Draw connection node
        drawCircle(
            color = pathColor,
            radius = 2.dp.toPx(),
            center = Offset(startX + 50.dp.toPx(), animatedY + 15.dp.toPx())
        )
    }
}