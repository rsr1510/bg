pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dock') // ID in Jenkins credentials
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh 'docker build -t rs1510/bluegreen:1.0.0 .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo "Logging into DockerHub and pushing image..."
                    sh """
                        echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                        docker push rs1510/bluegreen:1.0.0
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying application via docker compose..."
                    // If compose file is named docker-compose.yml
                    sh 'docker compose down || true'
                    sh 'docker compose up -d'
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up Docker login...'
                sh 'docker logout || true'
            }
        }
    }
}
