pipeline {
  agent any
  environment {
    AWS_ACCOUNT_ID="471970311922"
    AWS_DEFAULT_REGION="ap-southeast-2" 
    IMAGE_REPO_NAME="bob-job-post-api"
    IMAGE_TAG="latest"
    REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    MONGO_URL=credentials("MONGO_URL")
  }

  stages {
    stage('Logging into AWS ECR') {
      steps {
        script {
          sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
        } 
      }
    }

    stage('Cloning Git') {
      steps {
        checkout(
          [
            $class: 'GitSCM', 
            branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, 
            extensions: [], 
            submoduleCfg: [], 
            userRemoteConfigs: [[
              credentialsId: '', 
              url: 'https://github.com/qinjiabo1990/job-post-api.git'
            ]]
          ]
        ) 
      }
    }

    stage('Create .env File') {
            steps {
                script {
                    // Define the content of your .env file
                    def envContent = '
                        MONGO_URL=$MONGO_URL
                        PORT=5000
                        '

                    // Write the content to a .env file
                    writeFile file: '.env', text: envContent
                }
            }
        }

    // Building Docker images
    stage('Building image') {
      steps{
        script {
          // dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
          sh "docker build -t ${IMAGE_REPO_NAME} ."
        }
      }
    }

// Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
      steps{ 
        script {
          sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
          sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
  }

  post {
        always {
            // Clean up the .env file after use (optional)
            deleteFile file: '.env'
        }
    }
}