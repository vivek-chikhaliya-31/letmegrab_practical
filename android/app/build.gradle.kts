plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.todo_practical"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.todo_practical"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 33
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // FIX: Replaced Groovy syntax 'multiDexEnabled true' with Kotlin property assignment.
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        // FIX: The coreLibraryDesugaringEnabled property belongs inside the 'compileOptions' block, but
        // it must be set using the assignment operator '=' in Kotlin Script.
        isCoreLibraryDesugaringEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- REQUIRED ADDITION ---
dependencies {
    // This line is essential for core library desugaring to function.
    // It provides the necessary Java 8 APIs (like Streams, time) for older Android versions.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}