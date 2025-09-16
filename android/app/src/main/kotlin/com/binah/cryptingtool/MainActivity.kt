package com.binah.cryptingtool

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.os.Bundle
import android.util.Log
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.binah.cryptingtool.config.BuildConfig

/**
 * MainActivity for CryptingTool - Kotlin-based Android layer
 * Optimized for Android 12+ (API 32+) with modern Kotlin features
 */
class MainActivity : FlutterActivity() {
    
    companion object {
        private const val TAG = "CryptingTool"
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        try {
            GeneratedPluginRegistrant.registerWith(flutterEngine)
            Log.i(TAG, "Flutter engine configured successfully with Kotlin-based MainActivity")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to configure Flutter engine", e)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Log build configuration for debugging
        BuildConfig.logBuildConfiguration()
        
        // Modern Android UI optimizations using Kotlin
        configureModernAndroidUI()
        
        Log.i(TAG, "CryptingTool MainActivity initialized with Kotlin optimizations")
        Log.d(TAG, "Target API: ${android.os.Build.VERSION.SDK_INT}, Min supported: 32")
    }
    
    /**
     * Configure modern Android UI features using Kotlin
     */
    private fun configureModernAndroidUI() {
        try {
            // Enable edge-to-edge display for modern Android versions
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                window?.let { window ->
                    WindowCompat.setDecorFitsSystemWindows(window, false)
                    
                    // Configure status bar and navigation bar
                    WindowInsetsControllerCompat(window, window.decorView).apply {
                        isAppearanceLightStatusBars = false
                        isAppearanceLightNavigationBars = false
                    }
                }
            }
            
            Log.d(TAG, "Modern Android UI features configured")
        } catch (e: Exception) {
            Log.w(TAG, "Failed to configure modern UI features, continuing with defaults", e)
        }
    }
    
    override fun onResume() {
        super.onResume()
        Log.d(TAG, "MainActivity resumed - Kotlin-based activity lifecycle")
    }
    
    override fun onPause() {
        super.onPause()
        Log.d(TAG, "MainActivity paused - Kotlin-based activity lifecycle")
    }
}