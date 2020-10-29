pipeline {                                                                                                                                                                                                                              
  triggers {
        cron('H 01 * * *')
    }
  agent {
    kubernetes {
      yaml """
kind: Pod
metadata:
  name: needsleep-update
spec:
  containers:
  - name: jnlp
    workingDir: /tmp/jenkins
    resources:
      limits:
        memory: 250Mi
        cpu: 200m
      requests:
        memory: 250Mi
        cpu: 100m
  - name: aurbuild
    workingDir: /tmp/jenkins
    image: brokenpip3/dockerbaseciarch:1.4
    imagePullPolicy: Always
    command:
    - /usr/bin/cat
    tty: true
    resources:
      limits:
        memory: 250Mi
        cpu: 200m
      requests:
        memory: 250Mi
        cpu: 100m
    volumeMounts:
      - name: repo-pvc
        mountPath: /srv/repo
  imagePullSecrets:
  - name: registry-brokenpip3
  volumes:
  - name: repo-pvc
    persistentVolumeClaim: 
      claimName: repo-pvc
"""
    }
  }

stages {
    stage('Check dep') {
      steps {
          container('aurbuild') {
            sh './list-pkg.sh*'
       }}
      }   
    stage('Build packages') {
        steps {
          container('aurbuild') {
            echo 'Updating or add new packages to repo'
            script {
                def packages = [:]
                env.WORKSPACE = pwd()
                def file = readFile "${env.WORKSPACE}/pkg-list"
                def lines = file.readLines()
                lines.each {
                    packages["package ${it}"] = {
                        build job: '../my-pkgbuild/master', parameters: [[$class: 'StringParameterValue', name: 'PACKAGENAME', value: "$it"]], wait: false
                    }
                }                   
                parallel packages
            }
        }
    }
}
}
}
