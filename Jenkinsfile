pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-login')   // Jenkins credentials ID
        DOCKER_IMAGE = "rs1510/bluegreen:1.0.0"
        BLUE_CONTAINER = "blue_app"
        GREEN_CONTAINER = "green_app"
        NGINX_CONTAINER = "bluegreen_nginx"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/rsr1510/bluegreen.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: "$DOCKERHUB_CREDENTIALS", url: 'https://index.docker.io/v1/']) {
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy - Blue/Green Switch') {
            steps {
                script {
                    // Check if blue is running
                    def blueRunning = sh(script: "docker ps --filter 'name=$BLUE_CONTAINER' --filter 'status=running' -q", returnStdout: true).trim()
                    
                    if (blueRunning) {
                        echo "🔵 Blue is currently live. Deploying Green..."
                        sh """
                            docker run -d --name $GREEN_CONTAINER -p 8082:8080 $DOCKER_IMAGE
                            sleep 5
                            docker exec $NGINX_CONTAINER sed -i 's/blue_app/green_app/' /etc/nginx/conf.d/default.conf
                            docker exec $NGINX_CONTAINER nginx -s reload
                            docker stop $BLUE_CONTAINER && docker rm $BLUE_CONTAINER
                        """
                    } else {
                        echo "🟢 Green is currently live. Deploying Blue..."
                        sh """
                            docker run -d --name $BLUE_CONTAINER -p 8081:8080 $DOCKER_IMAGE
                            sleep 5
                            docker exec $NGINX_CONTAINER sed -i 's/green_app/blue_app/' /etc/nginx/conf.d/default.conf
                            docker exec $NGINX_CONTAINER nginx -s reload
                            docker stop $GREEN_CONTAINER && docker rm $GREEN_CONTAINER
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo "✅ Blue-Green deployment completed."
            sh 'docker ps -a'
        }
    }
}
