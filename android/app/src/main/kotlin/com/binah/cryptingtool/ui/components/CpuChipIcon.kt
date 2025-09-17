package com.binah.cryptingtool.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.binah.cryptingtool.ui.theme.TealAccent

@Composable
fun CpuChipIcon(
    size: Dp,
    showGlow: Boolean = false,
    modifier: Modifier = Modifier
) {
    val glowAnimation = rememberInfiniteTransition(label = "cpuGlow")
    val glowAlpha by glowAnimation.animateFloat(
        initialValue = 0.3f,
        targetValue = 0.8f,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "glowAlpha"
    )
    
    Box(
        modifier = modifier
            .size(size)
            .clip(RoundedCornerShape(6.dp))
            .background(TealAccent.copy(alpha = 0.2f))
    ) {
        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            drawCpuChip(showGlow, if (showGlow) glowAlpha else 1f)
        }
    }
}

private fun DrawScope.drawCpuChip(showGlow: Boolean, alpha: Float) {
    val chipColor = TealAccent.copy(alpha = alpha)
    val strokeWidth = 1.dp.toPx()
    val chipSize = size.minDimension
    val padding = chipSize * 0.1f
    
    // Main chip body
    drawRect(
        color = chipColor,
        topLeft = Offset(padding, padding),
        size = androidx.compose.ui.geometry.Size(
            chipSize - padding * 2,
            chipSize - padding * 2
        )
    )
    
    // Internal grid pattern
    val gridSpacing = chipSize * 0.15f
    val gridColor = chipColor.copy(alpha = alpha * 0.6f)
    
    // Vertical grid lines
    for (i in 1..4) {
        val x = padding + (chipSize - padding * 2) * i / 5
        drawLine(
            color = gridColor,
            start = Offset(x, padding),
            end = Offset(x, chipSize - padding),
            strokeWidth = strokeWidth * 0.5f
        )
    }
    
    // Horizontal grid lines
    for (i in 1..4) {
        val y = padding + (chipSize - padding * 2) * i / 5
        drawLine(
            color = gridColor,
            start = Offset(padding, y),
            end = Offset(chipSize - padding, y),
            strokeWidth = strokeWidth * 0.5f
        )
    }
    
    // Corner pins
    val pinSize = chipSize * 0.05f
    val pinColor = chipColor.copy(alpha = alpha * 0.8f)
    
    // Top pins
    for (i in 1..3) {
        val x = padding + (chipSize - padding * 2) * i / 4
        drawRect(
            color = pinColor,
            topLeft = Offset(x - pinSize / 2, 0f),
            size = androidx.compose.ui.geometry.Size(pinSize, padding)
        )
        // Bottom pins
        drawRect(
            color = pinColor,
            topLeft = Offset(x - pinSize / 2, chipSize - padding),
            size = androidx.compose.ui.geometry.Size(pinSize, padding)
        )
    }
    
    // Left pins
    for (i in 1..3) {
        val y = padding + (chipSize - padding * 2) * i / 4
        drawRect(
            color = pinColor,
            topLeft = Offset(0f, y - pinSize / 2),
            size = androidx.compose.ui.geometry.Size(padding, pinSize)
        )
        // Right pins
        drawRect(
            color = pinColor,
            topLeft = Offset(chipSize - padding, y - pinSize / 2),
            size = androidx.compose.ui.geometry.Size(padding, pinSize)
        )
    }
    
    // Center processing core
    val coreSize = chipSize * 0.3f
    val coreOffset = (chipSize - coreSize) / 2
    drawRect(
        color = chipColor.copy(alpha = alpha * 1.2f),
        topLeft = Offset(coreOffset, coreOffset),
        size = androidx.compose.ui.geometry.Size(coreSize, coreSize)
    )
    
    // Core details
    val detailSize = coreSize * 0.2f
    val detailSpacing = coreSize * 0.3f
    for (i in 0..1) {
        for (j in 0..1) {
            drawRect(
                color = chipColor.copy(alpha = alpha * 0.4f),
                topLeft = Offset(
                    coreOffset + detailSpacing + i * detailSize * 1.5f,
                    coreOffset + detailSpacing + j * detailSize * 1.5f
                ),
                size = androidx.compose.ui.geometry.Size(detailSize, detailSize)
            )
        }
    }
}