pipeline {
  agent {
    kubernetes {
      yaml """
kind: Pod
metadata:
  name: my-pkgbuild
spec:
  containers:
  - name: aurbuild
    workingDir: /tmp/jenkins
    image: brokenpip3/dockerbaseciarch:1.7
    imagePullPolicy: Always
    command:
    - /usr/bin/cat
    tty: true
    resources:
      limits:
        memory: 2Gi
        cpu: 2
      requests:
        memory: 1Gi
        cpu: 1
    volumeMounts:
      - name: repo-pvc
        mountPath: /srv/repo
  nodeSelector:
    owner: brokenpip3
  imagePullSecrets:
  - name: registry-brokenpip3
  volumes:
  - name: repo-pvc
    persistentVolumeClaim:
      claimName: repo-pvc
"""
    }}
        options { disableConcurrentBuilds()
                    timeout(time: 10, unit: 'MINUTES')
                }

  parameters {
        string(name: 'PACKAGENAME', description: 'Aur package to build')}

  stages {
    stage("Setname") {
            steps {
                // use name of the patchset as the build name
                buildName "${params.PACKAGENAME} #${BUILD_NUMBER}"
                buildDescription "${BUILD_NUMBER}"
            }
        }
    stage('pacman update') {
      steps {
		    container('aurbuild') {
            sh 'sudo pacman -Sy'
        }
       }
      }
    stage('install dep') {
      steps {
		container('aurbuild')
    {
      sh "cd pkgbuild/${params.PACKAGENAME} && makepkg -s -o --noconfirm"
    }
    }
    }
    stage('build') {
      steps {
		container('aurbuild')
    {
      sh "cd pkgbuild/${params.PACKAGENAME} && makepkg -scf --noconfirm"
    }
    }
    }
    stage('update repo') {
      steps {
		      container('aurbuild')
          {
          sh 'repoctl update'
          }
    }
    }
    stage('check new version') {
      steps {
		      container('aurbuild')
          {
          sh "./check_version.sh ${params.PACKAGENAME}"
          }
    }
    }
    stage('build-newver') {
      steps {
		      container('aurbuild')
          {
            script {
             if (fileExists('newversion')) {
             sh "cd pkgbuild/${params.PACKAGENAME} && makepkg -scf --noconfirm"
           } else {
             echo 'No new version'
        }
    }
    }
    }
    }
}
}
