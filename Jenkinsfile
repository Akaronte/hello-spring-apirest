pipeline {
    agent none
    stages {
        stage('compile') {
                agent {
                    docker {
                        image 'maven:3-alpine'
                        args '-v $HOME/.m2:/root/.m2'
                    }
                }
            steps {
                sh 'mvn package'
                stash name: "jar", includes: "target/**/*.jar"
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/**/*.jar', fingerprint: true
                    junit 'target/surefire-reports/**/*.xml'
                }
            }
        }
        stage('Dockerfile') {
            agent {
                node {
                    label 'master'
                }
            }
            steps {
                script{
                    unstash 'jar'
                    docker.withRegistry('https://kluster.tk:5000', 'kluster.tk') {
                        def customImage = docker.build("hello:${env.BUILD_ID}")
                        customImage.push()
                        def customImageLatest = docker.build("hello:latest")
                        customImageLatest.push()
                    }
                }
            }
            post{
                cleanup {
                echo "CLEAN"
                cleanWs()
                }
            }
        }
    }
}