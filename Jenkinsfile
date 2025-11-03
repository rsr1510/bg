pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('35f96797-19e6-46bd-baf0-9dbcdae66bb5')
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t rs1510/bluegreen:1.0.0 .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push rs1510/bluegreen:1.0.0
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }

    post {
        always {
            node('master') {
                echo 'Cleaning up Docker login...'
                sh 'docker logout'
            }
        }
    }
}
