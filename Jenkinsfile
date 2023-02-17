pipeline {
    agent any
    stages {
        // Add environment for sonar project properties
        //stage('Add environment for sonar project') {
        //    environment {
        //        sq_user    = credentials('sq-user')
        //        sq_pass    = credentials('sq-pass')
        //        sq_key     = credentials('sq-key')
        //    }
        //    steps {
        //        sh '''
        //        #!/bin/bash
        //        echo -e "\nsonar.projectKey=${sq_key}\nsonar.login=${sq_user}\nsonar.password=${sq_pass}" > sonar-project.properties
        //        ls -l
        //        '''
        //    }
        //}
        // SonarQube Analysis
        stage('SonarQube Analysis') {
            environment {
                SONARQUBE_URL           = credentials('url-sonarqube')
                SONARQUBE_PROJECT_KEY   = credentials('key-sonarqube')
                SONARQUBE_TOKEN         = credentials('token-sonarqube')
            }
            steps {
                echo 'Starting to inspect and scan the code analysis with SonarQube...'
                sh '''
                #!/bin/bash
                docker run --rm \
                -e SONAR_HOST_URL=${SONARQUBE_URL} \
                -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${SONARQUBE_PROJECT_KEY}" \
                -e SONAR_LOGIN=${SONARQUBE_TOKEN} \
                -v "$(pwd):/usr/src" \
                sonarsource/sonar-scanner-cli
                '''
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