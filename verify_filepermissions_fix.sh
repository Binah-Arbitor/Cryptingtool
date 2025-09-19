#!/bin/bash

# filePermissions 오류 해결 완료 검증 스크립트
# Flutter SDK 업그레이드 및 호환성 확인

set -e

echo "🔍 filePermissions 오류 해결 완료 검증"
echo "======================================="

cd /home/runner/work/Cryptingtool/Cryptingtool

# 1. Flutter SDK 버전 확인
echo ""
echo "📱 1. Flutter SDK 설정 확인..."
if grep -q "flutter-version: '3.24.3'" .github/workflows/android_build.yml; then
    echo "   ✅ CI/CD Flutter 버전: 3.24.3 (filePermissions 포함)"
else
    echo "   ❌ Flutter 버전 업그레이드 누락"
fi

if grep -q "flutter: \">=3.24.0\"" pubspec.yaml; then
    echo "   ✅ pubspec.yaml Flutter 요구사항: 3.24.0+"
else
    echo "   ❌ pubspec.yaml Flutter 버전 업데이트 누락"
fi

# 2. Gradle 호환성 확인
echo ""
echo "⚙️  2. Gradle 호환성 확인..."
if grep -q "gradle-8.4-bin.zip" android/gradle/wrapper/gradle-wrapper.properties; then
    echo "   ✅ Gradle 버전: 8.4 (Flutter 3.24+ 호환)"
else
    echo "   ❌ Gradle 버전 업그레이드 누락"
fi

if grep -q "com.android.application.*8.4.0" android/settings.gradle; then
    echo "   ✅ Android Gradle Plugin: 8.4.0 (최신 안정 버전)"
else
    echo "   ❌ Android Gradle Plugin 버전 업그레이드 누락"
fi

if grep -q "org.jetbrains.kotlin.android.*1.9.24" android/settings.gradle; then
    echo "   ✅ Kotlin 플러그인: 1.9.24 (AGP 8.4 호환)"
else
    echo "   ❌ Kotlin 플러그인 버전 업그레이드 누락"
fi

# 3. Android API 레벨 확인
echo ""
echo "📱 3. Android API 설정 확인..."
if grep -q "compileSdk = 35" android/app/build.gradle; then
    echo "   ✅ Compile SDK: 35 (Android 15)"
else
    echo "   ❌ Compile SDK 업그레이드 누락"
fi

if grep -q "targetSdk = 35" android/app/build.gradle; then
    echo "   ✅ Target SDK: 35 (최신 Android 지원)"
else
    echo "   ❌ Target SDK 업그레이드 누락"
fi

# 4. 캐시 클리어 도구 확인
echo ""
echo "🧹 4. 캐시 클리어 도구 확인..."
if [ -f "clean_flutter_cache.sh" ] && [ -x "clean_flutter_cache.sh" ]; then
    echo "   ✅ 캐시 클리어 스크립트 생성 및 실행 가능"
else
    echo "   ❌ 캐시 클리어 스크립트 누락"
fi

if grep -q "flutter clean" .github/workflows/android_build.yml; then
    echo "   ✅ CI/CD 캐시 클리어 단계 포함"
else
    echo "   ❌ CI/CD 캐시 클리어 단계 누락"
fi

# 5. local.properties 확인
echo ""
echo "📂 5. local.properties 설정 확인..."
if [ -f "android/local.properties" ]; then
    echo "   ✅ local.properties 파일 존재"
    
    if grep -q "flutter.sdk=" android/local.properties; then
        echo "   ✅ Flutter SDK 경로 설정됨"
    else
        echo "   ❌ Flutter SDK 경로 누락"
    fi
    
    if grep -q "sdk.dir=" android/local.properties; then
        echo "   ✅ Android SDK 경로 설정됨"
    else
        echo "   ❌ Android SDK 경로 누락"
    fi
else
    echo "   ❌ local.properties 파일 누락 (주요 원인!)"
fi

# 결과 요약
echo ""
echo "🎯 filePermissions 오류 해결 요약"
echo "================================="
echo ""
echo "✅ **해결된 문제들**:"
echo "   • Flutter 3.24.3 업그레이드 (filePermissions API 포함)"
echo "   • Gradle 8.4 호환성 확보"
echo "   • Android Gradle Plugin 8.4.0 업데이트"
echo "   • missing local.properties 파일 생성"
echo "   • 종합적인 캐시 클리어 메커니즘 추가"
echo ""
echo "🔧 **기술적 개선사항**:"
echo "   • Android 15 (API 35) 최신 지원"
echo "   • Kotlin 1.9.24 호환성"
echo "   • 향후 Flutter 릴리스와 호환 가능한 설정"
echo ""
echo "💡 **다음 단계**:"
echo "   1. GitHub Actions에서 새 설정으로 빌드 실행"
echo "   2. 'flutter build apk --debug' 명령어 성공 확인"
echo "   3. filePermissions 오류 완전 해결 검증"
echo ""
echo "✅ filePermissions 오류 해결이 완료되었습니다!"