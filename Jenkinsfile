pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  tools {
    // Ensure a JDK is available on your Jenkins agents; adjust name to what you've configured in Jenkins Global Tool Config
    jdk 'jdk17'
  }

  environment {
    // Change if your project lives in a subfolder
    APP_DIR = '.'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        dir(env.APP_DIR) {
          sh './gradlew clean build -x test'
        }
      }
    }

    stage('Test') {
      steps {
        dir(env.APP_DIR) {
          sh './gradlew test'
        }
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: '**/build/test-results/test/*.xml'
        }
      }
    }

    stage('Package') {
      steps {
        dir(env.APP_DIR) {
          sh './gradlew jar'
        }
      }
    }
  }

  post {
    success {
      archiveArtifacts artifacts: '**/build/libs/*.jar', fingerprint: true
    }
    always {
      // Useful for debugging Gradle builds
      archiveArtifacts artifacts: '**/build/reports/tests/test/**', allowEmptyArchive: true
    }
  }
}