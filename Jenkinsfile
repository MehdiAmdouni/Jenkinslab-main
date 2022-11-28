def commit_id
pipeline {
    agent any

    stages {
        
        stage('preparation') {
            steps {
                checkout scm
                sh "git rev-parse --short HEAD > .git/commit-id"
                script {
                    commit_id = readFile('.git/commit-id').trim()
                }
            }
        }
    
        stage ('build') {
            steps {
                echo 'building maven workload'
                sh "mvn clean install"
                echo 'build complete'
            }
        }
        stage ('Code Quality') {
            steps {
                echo 'testing code quality'
               sh "mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=jenkinslab \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=36d45c3581c7155fe7c01c0dd87a2792b0283771"

                echo 'Quality Test Complete'
            }        
        }       

        stage ("image build") {
            steps {
                echo 'building docker image'
                sh "docker build -t 192.168.86.142:8082/iteam/position-simulator:be13827 ."
                sh "docker push 192.168.86.142:8082/iteam/position-simulator:be13827 "
                echo 'docker image built'
            }
        }

        stage ("Deploy") {
            steps {
                echo "Deploying in a Kubernetes Cluster be13827"
                
                sh "sed -i -r 's|richardchesterwood/k8s-fleetman-position-simulator:release2|192.168.86.142:8082/iteam/position-simulator:be13827|' workloads.yaml"
                sh 'docker login -u admin -p root 192.168.86.142:8082'
                sh "kubectl apply -f workloads.yaml"
                sh "kubectl apply -f services.yaml"
                sh "kubectl get all"
                echo 'Deployment completed'
            }
        }
    }
}