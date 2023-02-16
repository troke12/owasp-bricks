pipeline {
    agent any
    stages {
        // SonarQube Analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Inspect code with sonar-scanner and upload result to SonarQube server'
                sh 'docker run \
                --rm \
                -e SONAR_HOST_URL="http://${SONARQUBE_URL}" \
                -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${YOUR_PROJECT_KEY}" \
                -e SONAR_LOGIN="myAuthenticationToken" \
                -v "${YOUR_REPO}:/usr/src" \
                sonarsource/sonar-scanner-cli'
            }
        }
        // Build the docker images
        stage('Build For Master') {
            when { branch 'master' }
            environment {

            }
            steps {
                echo 'Starting building for master'
                sh 'docker build -t troke12/owasp-bricks:${BUILD_NUMBER} .'
            }
        }
        // Deploy it
        stage('Deploy to production server') {
            when { branch 'master' }
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