pipeline {
    agent any
    stages {
        // SonarQube Analysis
        stage('SonarQube Analysis') {
            environment {
                sq_user = credentials('sq-user')
                sq_pass = credentials('sq-pass')
                sq_project = "owasppro"
                sq_host = "http://localhost:9000"
                sq_encoding = "UTF-8"
            }
            steps {
                echo 'Starting analysis code'
                sh 'cd /opt'
                sh 'rm -rf *'
                sh 'wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip'
                sh 'unzip -o sonar-scanner-cli-4.8.0.2856-linux.zip'
                sh 'cd sonar-scanner-4.8.0.2856-linux/'
                sh 'chmod +x sonar-scanner'
                sh 'ln -s /opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner'
                sh '''
                #!/bin/bash
                echo -e "sonar.projectKey=${sq_project}\nsonar.host.url=${sq_host}\nsonar.sourceEncoding=${sq_encoding}\nsonar.login=${sq_user}\nsonar.password=${sq_password}" > /opt/sonar-scanner-4.8.0.2856-linux/conf/sonar-scanner.properties"
                '''
                sh 'sonar-scanner -h'
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
                docker container prune -af
                set -e
                docker run --restart always -d -p 8080:80 --name owasp-bricks troke12/owasp-bricks:${BUILD_NUMBER}'
                '''
            }
        }
    }
}