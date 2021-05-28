pipeline {
    environment{
        DOCKER_TAG = getDockerTag()
        REGISTRY_URL  = "https://harbor.smpbank/"
        PROJECT =  "pipe-tst"
        IMAGE_URL_WITH_TAG = "${REGISTRY_URL}/${PROJECT}:${DOCKER_TAG}"
        }       
  agent {
    kubernetes {
      /*
      label 'spring-petclinic-demo'
      defaultContainer 'jnlp'
            */
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
      emptyDir: {}
"""
}
   }
  stages {
    stage('Build Image') {
      steps {
        container('docker') {
          sh """
             docker build -t harbor.smpbank/pipe-tst .
          """
        }        
      }
    }
    stage('Push Image'){
        steps{
            withCredentials([string(credentialsId: 'reg-pwd', variable: 'regPwd')]) {
                sh "docker login -u 'Kubernetes ESB Develop' -p ${regPwd} ${REGISTRY_URL}"
                sh "docker push harbor.smpbank/pipe-tst"
            }
        }    
  }
}