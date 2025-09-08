pipeline {
  agent any

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    APP_DIR = '.'   // change if your Gradle project is in a subfolder
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Prepare') {
      steps {
        dir(env.APP_DIR) {
          sh 'chmod +x ./gradlew'
          sh './gradlew --version'   // sanity check Java/Gradle
        }
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
      archiveArtifacts artifacts: '**/build/reports/tests/test/**', allowEmptyArchive: true
    }
  }
}