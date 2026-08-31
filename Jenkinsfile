pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node18'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME   = 'pavankumarkn/zomato-devops-app'
        IMAGE_TAG    = 'latest'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Source Code') {
            steps {
                git branch: 'main', url: 'https://github.com/pavankumarkn-gi/zomato-devops-terraform-jenkins.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    sh 'npm install --production'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=zomato-devops-app \
                        -Dsonar.projectName="Zomato DevOps App"
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true, credentialsId: 'sonar-token'
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./app --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Trivy Filesystem Scan') {
            steps {
                sh 'trivy fs --severity HIGH,CRITICAL --format table -o trivy-fs-report.txt .'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL --format table -o trivy-image-report.txt ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Docker Hub Push') {
            steps {
                withDockerRegistry(credentialsId: 'docker') {
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    if [ $(docker ps -a -q -f name=zomato-app) ]; then
                        docker stop zomato-app || true
                        docker rm zomato-app || true
                    fi
                    docker run -d --name zomato-app -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                    sleep 3
                    curl -s -f http://localhost:3000/api/health || exit 1
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-*.txt', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline completed successfully and Zomato App is live!'
        }
        failure {
            echo 'Pipeline execution failed. Check logs for details.'
        }
    }
}