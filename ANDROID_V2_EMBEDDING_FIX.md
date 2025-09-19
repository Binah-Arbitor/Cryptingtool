# Android v2 Embedding Migration Fix

## 문제 상황 (Problem)
`flutter build apk --debug` 실행 시 Android v1 embedding 사용으로 인한 빌드 실패

```
Build failed due to use of deleted Android v1 embedding
```

## 해결 방법 (Solution)

### ✅ 완료된 작업 (Completed Changes)

#### 1. AndroidManifest.xml 업데이트
```xml
<!-- Flutter v2 embedding 메타데이터 추가 -->
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />

<!-- Flutter 초기화를 위한 테마 추가 -->
<meta-data
    android:name="io.flutter.embedding.android.NormalTheme"
    android:resource="@style/NormalTheme" />
```

#### 2. MainActivity.kt 변경
```kotlin
// 이전: ComponentActivity (Kotlin Compose)
class MainActivity : ComponentActivity() { ... }

// 변경 후: FlutterActivity (Flutter v2 embedding)
class MainActivity: FlutterActivity() {
}
```

#### 3. 빌드 설정 업데이트

**android/app/build.gradle:**
```gradle
plugins {
    id "com.android.application"
    id "org.jetbrains.kotlin.android"
    id "dev.flutter.flutter-gradle-plugin"  // Flutter 플러그인 추가
}

flutter {
    source '../..'  // Flutter 소스 설정
}
```

**android/settings.gradle:**
```gradle
plugins {
    id "dev.flutter.flutter-gradle-plugin" version "1.0.0" apply false
    id "com.android.application" version "8.2.1" apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}
```

#### 4. 테마 설정 추가
```xml
<!-- res/values/themes.xml -->
<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@color/dark_gray</item>
</style>
```

### 🔧 사용 방법 (How to Use)

#### 1. Flutter SDK 설치 및 설정
```bash
# Flutter SDK 다운로드
git clone https://github.com/flutter/flutter.git -b stable

# 환경 변수 설정
export PATH="$PATH:`pwd`/flutter/bin"

# Flutter 의존성 확인
flutter doctor
```

#### 2. local.properties 파일 설정
```bash
# android/local.properties 파일 생성/수정
flutter.sdk=/path/to/your/flutter
sdk.dir=/path/to/your/android/sdk
```

#### 3. 빌드 실행
```bash
# 디버그 APK 빌드
flutter build apk --debug

# 릴리즈 APK 빌드  
flutter build apk --release
```

### 📋 주요 변경사항 (Key Changes)

| 구성 요소 | 변경 전 | 변경 후 |
|----------|---------|---------|
| MainActivity | ComponentActivity (Kotlin) | FlutterActivity (Flutter) |
| 빌드 시스템 | Pure Android Gradle | Flutter Gradle Plugin |
| Embedding | Android v1 (deprecated) | Android v2 (현재 표준) |
| UI 프레임워크 | Jetpack Compose | Flutter |

### ⚠️ 주의사항 (Important Notes)

1. **Flutter SDK 필요**: 이제 Flutter SDK가 설치되어 있어야 빌드할 수 있습니다
2. **플러그인 호환성**: 모든 Flutter 플러그인이 v2 embedding과 호환됩니다
3. **네이티브 코드**: 기존 C++ 코드는 그대로 유지됩니다

### 🧪 테스트 방법 (Testing)

```bash
# 1. Flutter 프로젝트 의존성 설치
flutter pub get

# 2. Android 라이선스 승인
flutter doctor --android-licenses

# 3. 빌드 테스트
flutter build apk --debug

# 4. 디바이스/에뮬레이터에서 실행
flutter run
```

### 🔍 문제 해결 (Troubleshooting)

#### 빌드 실패 시:
```bash
# Flutter 캐시 정리
flutter clean
flutter pub get

# Gradle 캐시 정리
cd android
./gradlew clean

# 전체 리빌드
flutter build apk --debug --verbose
```

#### 플러그인 오류 시:
```bash
# 플러그인 재생성
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### ✅ 성공 확인 (Success Verification)

빌드가 성공하면 다음과 같은 메시지가 표시됩니다:
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
```

이제 Android v1 embedding 오류 없이 `flutter build apk --debug` 명령이 성공적으로 실행됩니다.