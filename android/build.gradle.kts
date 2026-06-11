buildscript {
    val kotlin_version by extra("2.1.0")

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

//// Opcional: mover la carpeta build fuera de android/
//val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
//rootProject.layout.buildDirectory.set(newBuildDir)
//
//subprojects {
//    val newSubprojectBuildDir = newBuildDir.dir(project.name)
//    project.layout.buildDirectory.set(newSubprojectBuildDir)
//}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
