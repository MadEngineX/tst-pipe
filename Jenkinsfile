pipeline {
    agent {
        environment{
            DOCKER_TAG = getDockerTag()
            REGISTRY_URL  = "https://harbor.smpbank/"
            PROJECT =  "pipe-tst"
            IMAGE_URL_WITH_TAG = "${REGISTRY_URL}/${PROJECT}:${DOCKER_TAG}"
        }        
        kubernetes {
            label 'spring-petclinic-demo'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: cd-jenkins
  containers:
  - name: maven
    image: maven:latest
    command:
    - cat
    tty: true
    volumeMounts:
      - mountPath: "/root/.m2"
        name: m2
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
    - name: m2
      persistentVolumeClaim:
        claimName: m2
"""
}
}
    stages{
        stage('Build Docker Image'){
            steps{
                /*
                sh "curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | \
                tar zxvf - --strip 1 -C /usr/bin docker/docker"
                sh "sudo dockerd"
                */
                container('docker') {
                sh """
                    docker build -t ${IMAGE_URL_WITH_TAG} .
                """                
                //sh "docker build . -t ${IMAGE_URL_WITH_TAG}"
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
