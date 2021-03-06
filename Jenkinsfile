pipeline {
  environment{
        DOCKER_TAG = "0.1"
        REGISTRY_URL  = "https://hub.docker.com/"
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
  - name: kubectl
    image: ksxack/kubectl
    command:
    - cat
    tty: true  
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
  /*
    stage('Build Image') {
      steps {
        container('docker') {
          sh """
             docker build -t ksxack/tst-py .
          """
        }        
      }
    }
    stage('Push Image'){
        steps{
            container('docker') {
                withCredentials([string(credentialsId: 'reg-passwd', variable: 'regPwd')]) {
                    sh "docker login -u ksxack -p 9ASxpNA1" // ${REGISTRY_URL}" 
                    sh "docker push ksxack/tst-py"
                }
            }    
        }   
    }    
    */ 
    stage('Deploy to Test') {
        steps{
            container('kubectl') {
                withCredentials([file(credentialsId: 'k8s-stage-file', variable: 'FILE')]) {
                    sh "mkdir ~/.kube"
                    sh "echo ${FILE}"
                    sh "cat ${FILE} > ~/.kube/config"
                    sh "kubectl apply -f deployment.yaml -n test"
                }
            }    
        }    
    }         
  }
}