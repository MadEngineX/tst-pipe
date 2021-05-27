pipeline {
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
    stage('Push') {
      steps {
        container('docker') {
          sh """
             docker build -t https://harbor.smpbank/pipe-tst .
          """
        }
      }
    }
  }
}