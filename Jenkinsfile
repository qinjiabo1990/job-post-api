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

    // Building Docker images
    stage('Building image') {
      steps{
        script {
          sh "docker build -t ${IMAGE_REPO_NAME} --build-arg MONGO_URL=${MONGO_URL} ."
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
}