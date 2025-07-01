
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")


// pluginManagement {
//     def flutterSdkPath = {
//         def properties = new Properties()
//         file("local.properties").withInputStream { properties.load(it) }
//         def flutterSdkPath = properties.getProperty("flutter.sdk")
//         assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
//         return flutterSdkPath
//     }()

//     includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

//     repositories {
//         google()
//         mavenCentral()
//         gradlePluginPortal()
//     }
// }
// //Explaination:
// //the plugins block which specifies plugins used by the app uses Plugin DSL syntax
// plugins {
//     id "dev.flutter.flutter-plugin-loader" version "1.0.0"
//     id "com.android.application" version "8.1.0" apply false
//     id "org.jetbrains.kotlin.android" version "1.8.22" apply false //{agpVersion} and {kotlinVersion} were taken from android/build.gradle
//     // START: FlutterFire Configuration
//     id "com.google.gms.google-services" version "4.4.2" apply false //version: 4.3.10 of 'com.google.gms:google-services' is taken from old buildscript block from android/build.gradle
//     // END: FlutterFire Configuration
// }

// include ":app"
