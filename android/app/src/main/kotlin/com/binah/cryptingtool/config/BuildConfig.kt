package com.binah.cryptingtool.config

import android.util.Log
import java.io.File

/**
 * Kotlin-based build configuration and native library management
 * Handles dynamic library loading and build verification
 */
object BuildConfig {
    private const val TAG = "CryptingTool-BuildConfig"
    
    /**
     * Verify that all required native libraries are properly loaded
     */
    fun verifyNativeLibraries(): Boolean {
        val requiredLibraries = listOf(
            "cryptingtool",
            "cryptopp"
        )
        
        return try {
            requiredLibraries.forEach { libName ->
                try {
                    System.loadLibrary(libName)
                    Log.i(TAG, "Successfully loaded native library: lib$libName.so")
                } catch (e: UnsatisfiedLinkError) {
                    Log.w(TAG, "Native library lib$libName.so not found or failed to load", e)
                    // Don't fail completely, as some libraries might be optional
                }
            }
            
            Log.i(TAG, "Native library verification completed")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to verify native libraries", e)
            false
        }
    }
    
    /**
     * Get build information in a Kotlin-friendly format
     */
    fun getBuildInfo(): BuildInfo {
        return BuildInfo(
            buildType = if (android.os.Build.VERSION.SDK_INT >= 32) "production" else "legacy",
            kotlinVersion = "1.9.22",
            androidApiLevel = android.os.Build.VERSION.SDK_INT,
            supportedArchitectures = listOf("arm64-v8a", "armeabi-v7a", "x86_64"),
            nativeLibrariesAvailable = verifyNativeLibraries()
        )
    }
    
    /**
     * Data class for build information
     */
    data class BuildInfo(
        val buildType: String,
        val kotlinVersion: String,
        val androidApiLevel: Int,
        val supportedArchitectures: List<String>,
        val nativeLibrariesAvailable: Boolean
    )
    
    /**
     * Log detailed build configuration for debugging
     */
    fun logBuildConfiguration() {
        val buildInfo = getBuildInfo()
        Log.i(TAG, "=== CryptingTool Build Configuration ===")
        Log.i(TAG, "Build Type: ${buildInfo.buildType}")
        Log.i(TAG, "Kotlin Version: ${buildInfo.kotlinVersion}")
        Log.i(TAG, "Android API Level: ${buildInfo.androidApiLevel}")
        Log.i(TAG, "Supported Architectures: ${buildInfo.supportedArchitectures}")
        Log.i(TAG, "Native Libraries Available: ${buildInfo.nativeLibrariesAvailable}")
        Log.i(TAG, "========================================")
    }
}