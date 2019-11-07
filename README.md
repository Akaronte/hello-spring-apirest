# hello-spring-apirest
Compile spring app with maven adn declare jenkins pipeline for compile test create docker image and push in a docker private registry


This is a very simple app maven api rest for example compile and push image with jenkinsfile.

Build

```
mvn package
```

Run

```
java -jar .\target\hello-spring-apirest-0.1.0.jar
```

send http request to port 8080 with path /hello

```
curl http://localhosts:8080/hello
```

reponse with:

```
{"id": 1,"content": "Hello, World!"}
```

video example:

[![maven jenkins video example](https://piensoluegoinstalo.com/wp-content/uploads/2019/10/jenkinsx.png)](https://youtu.be/OJTLXDVGVVU)

```
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
                    cleanWs()
                }
            }
        }
    }
}
```
