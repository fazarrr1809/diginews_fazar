pluginManagement {
    // Perbaikan utama: Cek FLUTTER_ROOT milik server GitHub dahulu, jika tidak ada baru baca local.properties secara aman
    val flutterSdkPath = System.getenv("FLUTTER_ROOT") ?: run {
        val properties = java.util.Properties()
        val localPropertiesFile = rootDir.resolve("local.properties")
        if (localPropertiesFile.exists()) {
            localPropertiesFile.inputStream().use { properties.load(it) }
        }
        properties.getProperty("flutter.sdk") ?: error("Flutter SDK tidak ditemukan di local.properties")
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
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")