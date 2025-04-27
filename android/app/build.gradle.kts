plugins {
    id("com.android.application")
    id("kotlin-android")
    // ✅ Le plugin Flutter
    id("dev.flutter.flutter-gradle-plugin")
    // ✅ Ne surtout PAS préciser la version ici
    id("com.google.gms.google-services")
}

android {
    namespace = "sn.terangaagro.teranga_agro_mobile"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        jvmToolchain(17)
    }

    defaultConfig {
        applicationId = "sn.terangaagro.teranga_agro_mobile"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Applique Google Services ici à la fin
apply(plugin = "com.google.gms.google-services")
