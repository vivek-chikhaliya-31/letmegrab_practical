// File: android/build.gradle.kts

plugins {
    // This defines the Android Gradle Plugin (AGP) version
    // Check your Flutter/Android Studio setup for the exact required version
    id("com.android.application") version "8.7.3" apply false // <-- Check this line!
    id("dev.flutter.flutter-gradle-plugin") apply false
}
// ...

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
