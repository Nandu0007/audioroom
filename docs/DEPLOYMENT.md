# Deployment Guide - AudioRoom Ninja

This guide covers deploying AudioRoom Ninja to various platforms including iOS, Android, and Web.

## Prerequisites

- Flutter SDK (≥3.16.0)
- Xcode (for iOS deployment)
- Android Studio (for Android deployment)
- Valid developer accounts (Apple, Google Play)
- Firebase project configured
- Code signing certificates

## Environment Setup

### 1. Environment Variables

Create a `.env` file in the project root:

```bash
# API Keys
GOOGLE_TRANSLATE_API_KEY=your_translation_api_key
LIVEKIT_API_KEY=your_livekit_api_key
LIVEKIT_SECRET_KEY=your_livekit_secret

# Firebase Config
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_API_KEY=your_firebase_api_key

# App Configuration
APP_NAME=AudioRoom Ninja
APP_VERSION=2.0.0
BUILD_NUMBER=1
```

### 2. Firebase Configuration

Ensure you have the following files:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `web/firebase-config.js`

## Build Commands

### Development Builds

```bash
# Debug mode (development)
flutter run --debug

# Profile mode (performance testing)
flutter run --profile --flavor dev

# Release mode (production testing)
flutter run --release --flavor prod
```

### Production Builds

#### Android

```bash
# Build APK
flutter build apk --release --flavor prod

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release --flavor prod

# Build with different architectures
flutter build apk --release --split-per-abi --flavor prod
```

#### iOS

```bash
# Build for iOS
flutter build ios --release --flavor prod

# Build and archive for App Store
flutter build ipa --release --flavor prod
```

#### Web

```bash
# Build for web
flutter build web --release --web-renderer canvaskit

# Build with PWA support
flutter build web --release --pwa-strategy offline-first
```

## Platform-Specific Configuration

### Android Configuration

#### `android/app/build.gradle`
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.nandu.audioroom.ninja"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "2.0.0"
        multiDexEnabled true
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    
    flavorDimensions "environment"
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
        }
        prod {
            dimension "environment"
        }
    }
}
```

#### App Signing

1. Generate release keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../upload-keystore.jks
```

### iOS Configuration

#### `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>AudioRoom Ninja</string>
<key>CFBundleIdentifier</key>
<string>com.nandu.audioroom.ninja</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>2.0.0</string>

<!-- Permissions -->
<key>NSMicrophoneUsageDescription</key>
<string>AudioRoom Ninja needs microphone access for voice communication in audio rooms.</string>
<key>NSCameraUsageDescription</key>
<string>AudioRoom Ninja needs camera access for profile pictures and screen sharing.</string>
```

## App Store Deployment

### iOS App Store

1. **Prepare for submission**:
```bash
flutter build ipa --release --flavor prod
```

2. **Upload to App Store Connect**:
   - Use Xcode → Product → Archive
   - Or use Transporter app
   - Or command line: `xcrun altool --upload-app`

3. **App Store metadata**:
   - App name: "AudioRoom Ninja"
   - Subtitle: "Social Audio Platform"
   - Keywords: "audio, chat, social, voice, rooms, ninja"
   - Category: Social Networking
   - Age rating: 12+ (due to user-generated content)

### Google Play Store

1. **Prepare for submission**:
```bash
flutter build appbundle --release --flavor prod
```

2. **Upload to Google Play Console**:
   - Create new release
   - Upload the `.aab` file
   - Fill in release notes

3. **Play Store metadata**:
   - Title: "AudioRoom Ninja - Social Audio"
   - Short description: "Revolutionary social audio platform with AI features"
   - Full description: Include features, benefits, and usage instructions
   - Category: Social
   - Content rating: Rated for 12+

## Web Deployment

### Firebase Hosting

1. **Install Firebase CLI**:
```bash
npm install -g firebase-tools
firebase login
```

2. **Initialize Firebase hosting**:
```bash
firebase init hosting
```

3. **Deploy to Firebase**:
```bash
flutter build web --release
firebase deploy --only hosting
```

### Custom Domain

1. **Configure custom domain in Firebase Console**
2. **Add DNS records**:
```
Type: A
Name: @
Value: 151.101.1.195

Type: A  
Name: @
Value: 151.101.65.195
```

## Performance Optimization

### Build Optimization

```bash
# Analyze bundle size
flutter build apk --analyze-size --target-platform android-arm64

# Tree shaking for web
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# Enable obfuscation
flutter build apk --release --obfuscate --split-debug-info=debug-info/
```

### Asset Optimization

1. **Compress images**:
```bash
# Use imagemin or similar tools
for file in assets/images/*.png; do
  pngquant --quality=65-80 "$file" --output "${file%.png}-compressed.png"
done
```

2. **Optimize fonts**:
   - Use only required font weights
   - Subset fonts for specific languages

## Monitoring & Analytics

### Crashlytics Setup

```dart
// main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(MyApp());
}
```

### Performance Monitoring

```dart
// Track performance
final trace = FirebasePerformance.instance.newTrace('room_join');
await trace.start();
// ... room join logic
await trace.stop();
```

## CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy AudioRoom Ninja

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build_and_test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - run: flutter pub get
    - run: flutter test
    - run: flutter build web --release
    
    - name: Deploy to Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        projectId: audioroom-ninja
```

## Security Considerations

1. **API Keys**: Never commit API keys to version control
2. **Certificate Pinning**: Implement for production
3. **Code Obfuscation**: Enable for release builds
4. **Permissions**: Request minimal necessary permissions
5. **Data Encryption**: Encrypt sensitive local data

## Rollback Strategy

1. **Version Control**: Tag releases for easy rollback
2. **Staged Rollout**: Use platform-specific staged rollout features
3. **Feature Flags**: Implement feature toggles for quick disabling
4. **Monitoring**: Set up alerts for crash rates and performance metrics

## Post-Deployment Checklist

- [ ] App launches successfully on all target devices
- [ ] All features work as expected
- [ ] Audio quality meets standards
- [ ] Performance metrics are acceptable
- [ ] Crash-free rate > 99.5%
- [ ] App store metadata is accurate
- [ ] Analytics are tracking correctly
- [ ] User feedback channels are active

## Support & Maintenance

- Monitor app store reviews and ratings
- Track crash reports and fix critical issues quickly
- Update dependencies regularly for security
- Plan regular feature updates and improvements
- Maintain documentation and changelogs

---

For questions about deployment, contact the development team or create an issue in the repository.