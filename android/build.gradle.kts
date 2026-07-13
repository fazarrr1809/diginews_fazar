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
    afterEvaluate {
        val androidExtension = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        androidExtension?.apply {
            compileSdkVersion(35)
            defaultConfig.targetSdkVersion(35)
            
            if (namespace == null) {
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                var manifestPackage: String? = null
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    val match = Regex("package=\"([^\"]+)\"").find(content)
                    if (match != null) {
                        manifestPackage = match.groupValues[1]
                    }
                }
                namespace = manifestPackage ?: ("com.example." + project.name.replace("-", "_"))
            }
        }
    }
}