subprojects {
    afterEvaluate {
        if (project.extensions.findByName("android") != null) {
            @Suppress("UNCHECKED_CAST")
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            android.compileOptions.sourceCompatibility = JavaVersion.VERSION_17
            android.compileOptions.targetCompatibility = JavaVersion.VERSION_17
            
            // Nếu plugin có sử dụng Kotlin, cũng sẽ thiết lập jvmTarget về 17
            if (project.plugins.hasPlugin("org.jetbrains.kotlin.android")) {
                val kotlinOptions = project.extensions.getByName("kotlinOptions") as org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions
                kotlinOptions.jvmTarget = "17"
            }
        }
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
