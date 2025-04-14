pipeline {
    agent any
    
    environment {
        TF_VAR_gcp_credentials = credentials('gcp-terraform-creds')
        GOOGLE_APPLICATION_CREDENTIALS = "${env.TF_VAR_gcp_credentials}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp-terraform-creds', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh """
                        terraform plan \
                          -var="gcp_project=${GCP_PROJECT}" \
                          -var="gcp_region=${GCP_REGION}" \
                          -var="gcp_zone=${GCP_ZONE}" \
                          -out=tfplan
                        """
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Get Instance IP') {
            steps {
                script {
                    def tfOutput = sh(script: 'terraform output -raw instance_ip', returnStdout: true).trim()
                    env.INSTANCE_IP = tfOutput
                    echo "Instance IP: ${env.INSTANCE_IP}"
                }
            }
        }
        
        stage('SSH to Instance') {
            steps {
                script {
                    // This assumes you have SSH keys set up for the instance
                    // You may need to add the public key to the instance metadata
                    sh "gcloud compute ssh --zone ${GCP_ZONE} terraform-vm --project ${GCP_PROJECT}"
                    
                    // Or using regular SSH (if you have the private key in Jenkins):
                    // ssh -i /path/to/private/key user@${env.INSTANCE_IP}
                }
            }
        }
    }
    
    post {
        always {
            sh 'terraform destroy -auto-approve'
        }
    }
}
