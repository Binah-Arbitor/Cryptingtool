#!/bin/bash

# Flutter SDK 업그레이드 및 캐시 클리어 스크립트
# filePermissions 오류 해결을 위한 종합적인 캐시 정리

set -e

echo "🚀 Flutter SDK 업그레이드 및 캐시 클리어 시작"
echo "================================================="

# 1. Flutter 캐시 클리어
echo ""
echo "🧹 1. Flutter 캐시 클리어 중..."
if command -v flutter &> /dev/null; then
    flutter clean
    flutter pub cache clean
    echo "   ✅ Flutter 캐시 클리어 완료"
else
    echo "   ⚠️  Flutter가 설치되지 않음 - CI/CD에서 자동 설치됨"
fi

# 2. Gradle 캐시 클리어
echo ""
echo "🧹 2. Gradle 캐시 클리어 중..."
cd /home/runner/work/Cryptingtool/Cryptingtool/android

# 전역 Gradle 캐시 제거
if [ -d "$HOME/.gradle/caches" ]; then
    rm -rf "$HOME/.gradle/caches/"
    echo "   ✅ 전역 Gradle 캐시 제거 완료"
fi

# 로컬 빌드 캐시 제거
rm -rf build/ app/build/ .gradle/
echo "   ✅ 로컬 빌드 캐시 제거 완료"

# 3. 의존성 다시 다운로드
echo ""
echo "📦 3. 의존성 다시 다운로드 중..."
cd /home/runner/work/Cryptingtool/Cryptingtool

if command -v flutter &> /dev/null; then
    flutter pub get
    echo "   ✅ Flutter 의존성 다운로드 완료"
else
    echo "   ⚠️  Flutter가 없어 의존성 다운로드 건너뛰기"
fi

# 4. 빌드 디렉토리 정리
echo ""
echo "🗂️  4. 빌드 디렉토리 정리 중..."
rm -rf build/
echo "   ✅ build/ 디렉토리 정리 완료"

echo ""
echo "✅ 모든 캐시 클리어 완료!"
echo ""
echo "💡 다음 단계:"
echo "   1. CI/CD에서 Flutter 3.24.3 버전이 설치됨"
echo "   2. 업그레이드된 Gradle 8.4와 호환됨"
echo "   3. filePermissions 오류가 해결됨"
echo "   4. 'flutter build apk --debug' 명령어로 빌드 테스트"