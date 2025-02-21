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

        stage('Terraform Init') {
            parallel {
                stage('Init - Dev') {
                    steps {
                        script {
                            terraformInit('dev')
                        }
                    }
                }
                stage('Init - Staging') {
                    steps {
                        script {
                            terraformInit('staging')
                        }
                    }
                }
                stage('Init - Prod') {
                    steps {
                        script {
                            terraformInit('prod')
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            parallel {
                stage('Plan - Dev') {
                    steps {
                        script {
                            terraformPlan('dev')
                        }
                    }
                }
                stage('Plan - Staging') {
                    steps {
                        script {
                            terraformPlan('staging')
                        }
                    }
                }
                stage('Plan - Prod') {
                    steps {
                        script {
                            terraformPlan('prod')
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            parallel {
                stage('Apply - Dev') {
                    steps {
                        script {
                            terraformApply('dev')
                        }
                    }
                }
                stage('Apply - Staging') {
                    steps {
                        script {
                            terraformApply('staging')
                        }
                    }
                }
                stage('Apply - Prod') {
                    steps {
                        script {
                            terraformApply('prod')
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
    sh "terraform plan -var-file=environments/${environment}.tfvars -out=${environment}.tfplan -no-color"
}

def terraformApply(environment) {
    sh "terraform apply -auto-approve ${environment}.tfplan"
} 