package com.binah.cryptingtool.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val DarkColorScheme = darkColorScheme(
    primary = TealAccent,
    secondary = LimeGreen,
    tertiary = CyanAccent,
    background = DarkGray,
    surface = DarkerGray,
    onPrimary = DarkGray,
    onSecondary = DarkGray,
    onTertiary = DarkGray,
    onBackground = LightGray,
    onSurface = LightGray,
    error = ErrorRed,
    onError = LightGray
)

private val LightColorScheme = lightColorScheme(
    primary = TealAccent,
    secondary = LimeGreen,
    tertiary = CyanAccent,
    background = LightGray,
    surface = White,
    onPrimary = White,
    onSecondary = White,
    onTertiary = White,
    onBackground = DarkGray,
    onSurface = DarkGray,
    error = ErrorRed,
    onError = White
)

@Composable
fun CryptingToolTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) {
        DarkColorScheme
    } else {
        LightColorScheme
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}