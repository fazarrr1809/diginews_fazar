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

// PERBAIKAN FINAL: Menggunakan pemanggilan fungsi targetSdkVersion(35) 
// tanpa operator '=' agar lolos dari validasi ApiVersion di server GitHub
subprojects {
    afterEvaluate {
        val androidExtension = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (androidExtension != null) {
            androidExtension.compileSdkVersion(35)
            androidExtension.defaultConfig.targetSdkVersion(35)
        }
    }
}