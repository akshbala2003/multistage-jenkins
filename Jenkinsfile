pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-west-2'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare Workspaces') {
            parallel {
                stage('Prepare Dev') {
                    steps {
                        dir('dev') {
                            sh '''
                                cp -r ../modules .
                                cp ../*.tf .
                                cp ../environments/dev.tfvars .
                            '''
                        }
                    }
                }
                stage('Prepare Staging') {
                    steps {
                        dir('staging') {
                            sh '''
                                cp -r ../modules .
                                cp ../*.tf .
                                cp ../environments/staging.tfvars .
                            '''
                        }
                    }
                }
                stage('Prepare Prod') {
                    steps {
                        dir('prod') {
                            sh '''
                                cp -r ../modules .
                                cp ../*.tf .
                                cp ../environments/prod.tfvars .
                            '''
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            parallel {
                stage('Init - Dev') {
                    steps {
                        dir('dev') {
                            script {
                                terraformInit('dev')
                            }
                        }
                    }
                }
                stage('Init - Staging') {
                    steps {
                        dir('staging') {
                            script {
                                terraformInit('staging')
                            }
                        }
                    }
                }
                stage('Init - Prod') {
                    steps {
                        dir('prod') {
                            script {
                                terraformInit('prod')
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            parallel {
                stage('Plan - Dev') {
                    steps {
                        dir('dev') {
                            script {
                                terraformPlan('dev')
                            }
                        }
                    }
                }
                stage('Plan - Staging') {
                    steps {
                        dir('staging') {
                            script {
                                terraformPlan('staging')
                            }
                        }
                    }
                }
                stage('Plan - Prod') {
                    steps {
                        dir('prod') {
                            script {
                                terraformPlan('prod')
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            parallel {
                stage('Apply - Dev') {
                    steps {
                        dir('dev') {
                            script {
                                terraformApply('dev')
                            }
                        }
                    }
                }
                stage('Apply - Staging') {
                    steps {
                        dir('staging') {
                            script {
                                terraformApply('staging')
                            }
                        }
                    }
                }
                stage('Apply - Prod') {
                    steps {
                        dir('prod') {
                            script {
                                terraformApply('prod')
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Infrastructure successfully deployed!'
        }
        failure {
            echo 'Infrastructure deployment failed!'
        }
    }
}

def terraformInit(environment) {
    sh "terraform init -backend-config=key=multistage/${environment}/terraform.tfstate -no-color"
}

def terraformPlan(environment) {
    sh "terraform plan -var-file=${environment}.tfvars -out=${environment}.tfplan -no-color"
}

def terraformApply(environment) {
    sh "terraform apply -auto-approve ${environment}.tfplan"
} 