pipeline {
  agent any

  environment {
    APP_DIR  = 'Exercise'                 // your app is inside /Exercise
    JAR_NAME = 'Exercise-1.0.0.jar'       // optional hint; we auto-fallback if different
  }

  options {
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  stages {
    stage('Checkout') {
      steps {
        // If your Jenkins job is already linked to this repo, you can use: checkout scm
        checkout scm
      }
    }

    stage('Build') {
      steps {
        dir(env.APP_DIR) {
          sh 'chmod +x ./gradlew || true'
          sh './gradlew --no-daemon clean build'
        }
      }
    }

    stage('Test') {
      steps {
        dir(env.APP_DIR) {
          sh './gradlew --no-daemon test'
        }
      }
      post {
        always {
          junit "${env.APP_DIR}/build/test-results/test/*.xml"
        }
      }
    }

    stage('Deploy (run JAR)') {
      steps {
        dir(env.APP_DIR) {
          sh '''
            set -e
            echo "Running packaged JAR..."

            # Prefer the configured JAR_NAME; else pick the first JAR under build/libs
            CANDIDATE="build/libs/$JAR_NAME"
            if [ -f "$CANDIDATE" ]; then
              JAR_PATH="$CANDIDATE"
            else
              echo "Hint JAR not found ($CANDIDATE). Auto-detecting..."
              JAR_PATH=$(ls -1 build/libs/*.jar | head -n 1)
              echo "Using: $JAR_PATH"
            fi

            # Run the console app (prints then exits)
            java -jar "$JAR_PATH"
          '''
        }
      }
    }
  }

  post {
    always {
      echo 'Archiving artifacts & cleaning workspace'
      archiveArtifacts artifacts: "${env.APP_DIR}/build/libs/*.jar", fingerprint: true
      deleteDir()
    }
    success { echo "Build #${env.BUILD_NUMBER} ✅" }
    failure { echo "Build #${env.BUILD_NUMBER} ❌" }
  }
}