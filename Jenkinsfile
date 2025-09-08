pipeline {
  agent any

  environment {
    APP_DIR  = 'Exercise'                 // Gradle project lives here
    JAR_NAME = 'Exercise-1.0.0.jar'       // optional hint; auto-fallback if different
  }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Sanity') {
      steps {
        sh '''
          echo "Workspace:"; pwd
          echo "Root files:"; ls -la | sed -n '1,80p'
          echo "Exercise/ files:"; ls -la Exercise || true
        '''
      }
    }

    stage('Build & Test (Gradle wrapper at repo root)') {
      steps {
        sh '''
          set -e
          # Ensure wrapper is executable
          chmod +x ./gradlew || true

          # Run from repo root, but target the Exercise project
          ./gradlew --no-daemon -p Exercise clean build test
        '''
      }
      post {
        always {
          // JUnit XML is produced under the subproject
          junit 'Exercise/build/test-results/test/*.xml'
          // Archive built jars from the subproject
          archiveArtifacts artifacts: 'Exercise/build/libs/*.jar', fingerprint: true
        }
      }
    }

    stage('Deploy (run JAR)') {
      steps {
        sh '''
          set -e
          CANDIDATE="Exercise/build/libs/'"${JAR_NAME}"'"
          if [ -f Exercise/build/libs/"${JAR_NAME}" ]; then
            JAR_PATH="Exercise/build/libs/${JAR_NAME}"
          else
            echo "Hint JAR not found. Auto-detecting…"
            JAR_PATH=$(ls -1 Exercise/build/libs/*.jar | head -n 1)
          fi
          echo "Running: ${JAR_PATH}"
          java -jar "${JAR_PATH}"
        '''
      }
    }
  }

  post {
    always {
      echo 'Archiving artifacts & cleaning workspace'
      archiveArtifacts artifacts: 'Exercise/build/libs/*.jar', fingerprint: true
      deleteDir()
    }
    success { echo "Build #${env.BUILD_NUMBER} ✅" }
    failure { echo "Build #${env.BUILD_NUMBER} ❌" }
  }
}