pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dock') // DockerHub credentials ID
        GIT_CREDENTIALS = credentials('git-creds')  // GitHub credentials ID
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Cloning repository using Git credentials..."
                    git credentialsId: 'git-creds', url: 'https://github.com/rsr1510/bluegreen.git', branch: 'main'
                }
            }
        }

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
