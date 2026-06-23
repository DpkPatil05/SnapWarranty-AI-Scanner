plugins {
    id("com.android.application")
    id("kotlin-android")
    // Add the Google services Gradle plugin
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load the properties from your key.properties file
val keyProperties = Properties().apply {
    val keyPropertiesFile = rootProject.file("key.properties")
    if (keyPropertiesFile.exists()) {
        load(FileInputStream(keyPropertiesFile))
    }
}

android {
    namespace = "com.deepx.snap_warranty"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Define the signing configuration
    signingConfigs {
        create("release") {
            keyAlias = keyProperties.getProperty("keyAlias")
            keyPassword = keyProperties.getProperty("keyPassword")
            storeFile = file(keyProperties.getProperty("storeFile"))
            storePassword = keyProperties.getProperty("storePassword")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.deepx.snap_warranty"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk =
            flutter.minSdkVersion // Minimum for some plugins, though flutter.minSdkVersion is usually 21+
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    dependencies {
        // Core library desugaring for Java 8+ API support on older devices (Required by flutter_local_notifications)
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

        // Import the Firebase BoM
        implementation(platform("com.google.firebase:firebase-bom:34.15.0"))
        // Add the dependencies for Firebase products you want to use
        implementation("com.google.firebase:firebase-analytics")
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            // Enable R8 code minification and resource shrinking for production
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
