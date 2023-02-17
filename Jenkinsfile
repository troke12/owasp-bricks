pipeline {
    agent any
    stages {
        // SonarQube Analysis
        stage('SonarQube Analysis') {
            when { branch 'main' }
            environment {
                SONARQUBE_URL           = credentials('url-sonarqube')
                SONARQUBE_PROJECT_KEY   = credentials('key-sonarqube')
                SONARQUBE_TOKEN         = credentials('token-sonarqube')
                REPOSITORY              = "owasp-bricks"
            }
            steps {
                echo 'Starting to inspect and scan the code analysis with SonarQube...'
                sh 'docker run \
                --rm \
                -e SONAR_HOST_URL="http://${SONARQUBE_URL}" \
                -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${SONARQUBE_PROJECT_KEY}" \
                -e SONAR_LOGIN=${SONARQUBE_TOKEN} \
                -v "${REPOSITORY}:/usr/src" \
                sonarsource/sonar-scanner-cli'
            }
        }
        // Build the docker images
        stage('Build the docker') {
            when { branch 'main' }
            steps {
                echo 'Start building docker...'
                sh 'docker build -t troke12/owasp-bricks:${BUILD_NUMBER} .'
            }
        }
        // Deploy it
        stage('Deploy to the server') {
            when { branch 'main' }
            steps {
                echo 'Starting deploy the application....'
                sh '''
                #!/bin/bash
                set +e
                docker stop owasp-bricks
                docker container prune -af
                set -e
                docker run --restart always -d -p 8080:80 --name owasp-bricks troke12/owasp-bricks:${BUILD_NUMBER}'
                '''
            }
        }
    }
}