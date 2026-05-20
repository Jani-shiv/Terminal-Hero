import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load signing properties from `key.properties` if present (keystore kept out of VCS)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val configuredStoreFile = keystoreProperties.getProperty("storeFile") ?: "app/release-keystore.jks"
val storeFileFromAndroidDir = rootProject.file(configuredStoreFile)
val storeFileFromRepoRoot = rootProject.projectDir.parentFile.resolve(configuredStoreFile)
val releaseStoreFile =
    if (storeFileFromAndroidDir.exists()) storeFileFromAndroidDir else storeFileFromRepoRoot
val hasReleaseKeystore = keystorePropertiesFile.exists() && releaseStoreFile.exists()

android {
    namespace = "com.terminalhero.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.terminalhero.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = maxOf(23, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Create a release signing config only when the referenced keystore exists.
    if (hasReleaseKeystore) {
        signingConfigs.create("release") {
            storeFile = releaseStoreFile
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            // Use release signing config if present, otherwise fall back to debug signing.
            signingConfig = signingConfigs.findByName("release") ?: signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
