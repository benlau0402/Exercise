pipeline {
  agent any

  tools {
    jdk 'jdk21'   // Configure in Manage Jenkins → Global Tool Configuration
  }

  environment {
    APP_DIR = 'Exercise'
  }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
    ansiColor('xterm')
  }

  triggers {
    // Webhook from GitHub/ngrok will trigger builds.
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Gradle Build & Test') {
      steps {
        dir(env.APP_DIR) {
          sh 'chmod +x ./gradlew'
          sh './gradlew --no-daemon clean build test'
        }
      }
      post {
        always {
          // Publish JUnit test results
          junit "${env.APP_DIR}/build/test-results/test/*.xml"
          // Keep the built jar for reference
          archiveArtifacts artifacts: "${env.APP_DIR}/build/libs/*.jar", fingerprint: true
        }
      }
    }
  }

  post {
    success { echo "Build #${env.BUILD_NUMBER} ✅ (Gradle build & tests passed)" }
    failure { echo "Build #${env.BUILD_NUMBER} ❌ (Gradle build or tests failed)" }
  }
}