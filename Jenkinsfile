pipeline {
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
        REGISTRY_URL  = "172.31.34.232:8080"
        PROJECT =  "pipe-tst"
        IMAGE_URL_WITH_TAG = "${REGISTRY_URL}/${PROJECT}:${DOCKER_TAG}"
    }
    stages{
        stage('Build Docker Image'){
            steps{
                sh "curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | \
                tar zxvf - --strip 1 -C /usr/bin docker/docker"
                sh "docker build . -t ${IMAGE_URL_WITH_TAG}"
            }
        }
        stage('Push Image'){
            steps{
                withCredentials([string(credentialsId: 'reg-pwd', variable: 'regPwd')]) {
                    sh "docker login -u 'Kubernetes ESB Develop' -p ${regPwd} ${REGISTRY_URL}"
                    sh "docker push ${IMAGE_URL_WITH_TAG}"
                }
            }
        }
        /*
        stage('Docker Deploy Dev'){
            steps{
                sshagent(['tomcat-dev']) {
                    withCredentials([string(credentialsId: 'nexus-pwd', variable: 'nexusPwd')]) {
                        sh "ssh ec2-user@172.31.0.38 docker login -u admin -p ${nexusPwd} ${NEXUS_URL}"
                    }
					// Remove existing container, if container name does not exists still proceed with the build
					sh script: "ssh ec2-user@172.31.0.38 docker rm -f nodeapp",  returnStatus: true
                    
                    sh "ssh ec2-user@172.31.0.38 docker run -d -p 8080:8080 --name nodeapp ${IMAGE_URL_WITH_TAG}"
                }
            }
        }
        */
    }
}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}