pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command: ["sleep"]
      args: ["99d"]
    - name: jgit
      image: alpine/git:latest
      command: ["sleep"]
      args: ["99d"]
"""
        }
    }

    environment {
        ECR_REGISTRY = "801867401886.dkr.ecr.eu-west-2.amazonaws.com"
        IMAGE_NAME   = "final-project"
        // Використовуємо номер білда як тег, щоб Argo CD бачив зміни
        IMAGE_TAG    = "build-${BUILD_NUMBER}"
        REPO_URL     = "https://github.com/Oleksandra-Mu/devops-ci-cd-homeworks.git"
        CHART_PATH   = "final-project/django-chart"
    }

    stages {
        stage('Build & Push to ECR') {
            steps {
                container('kaniko') {
                    sh """
                    /kaniko/executor \
                      --context ${WORKSPACE} \
                      --dockerfile ${WORKSPACE}/Dockerfile \
                      --destination ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
                      --cache=true
                    """
                }
            }
        }

        stage('Update Git Manifest for Argo CD') {
            steps {
                container('jgit') {
                    withCredentials([string(credentialsId: 'github-token', variable: 'G_TOKEN')]) {
                        sh """
                        # 1. Дозволяємо Git працювати в цій папці (лікуємо помилку 128)
                        git config --global --add safe.directory ${WORKSPACE}
                        
                        # 2. Налаштовуємо користувача
                        git config --global user.email "jenkins@example.com"
                        git config --global user.name "Jenkins CI"
                        
                        # 3. Оновлюємо тег
                        sed -i "s/tag: .*/tag: ${IMAGE_TAG}/g" ${CHART_PATH}/values.yaml
                        
                        # 4. Фіксуємо зміни
                        git add ${CHART_PATH}/values.yaml
                        git commit -m "Update image tag to ${IMAGE_TAG} [skip ci]"
                        
                        # 5. Пушимо
                        git push https://${G_TOKEN}@github.com/Oleksandra-Mu/devops-ci-cd-homeworks.git HEAD:final-project
                        """
                    }
                }
            }
        }
    }
}