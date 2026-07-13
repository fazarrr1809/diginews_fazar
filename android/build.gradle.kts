plugins {
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Konfigurasi direktori output build Flutter
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get().asFile
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    project.layout.buildDirectory.set(newBuildDir.resolve(project.name))
}

subprojects {
    plugins.withId("com.android.library") {
        val androidExtension = project.extensions.getByName("android") as? com.android.build.gradle.BaseExtension
        androidExtension?.apply {
            compileSdkVersion(35)
            defaultConfig.targetSdkVersion(35)
            if (namespace == null) {
                namespace = "com.example." + project.name.replace("-", "_")
            }
        }
    }
    plugins.withId("com.android.application") {
        val androidExtension = project.extensions.getByName("android") as? com.android.build.gradle.BaseExtension
        androidExtension?.apply {
            compileSdkVersion(35)
            defaultConfig.targetSdkVersion(35)
            if (namespace == null) {
                namespace = "com.example." + project.name.replace("-", "_")
            }
        }
    }
}