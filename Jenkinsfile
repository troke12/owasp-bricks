pipeline {
    agent any
    stages {
        // SonarQube Analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Starting analysis code'
                sh 'sudo sonar-scanner'
            }
        }
        // Build the docker images
        stage('Build the docker') {
            steps {
                echo 'Start building docker...'
                sh 'docker build -t troke12/owasp-bricks:${BUILD_NUMBER} .'
            }
        }
        // Deploy it
        stage('Deploy to the server') {
            steps {
                echo 'Starting deploy the application....'
                sh '''
                #!/bin/bash
                set +e
                docker stop owasp-bricks
                docker container prune -f
                set -e
                docker run --restart always -d -p 3220:80 --name owasp-bricks troke12/owasp-bricks:${BUILD_NUMBER}
                docker image prune -af
                '''
            }
        }
    }
}