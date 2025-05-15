pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Deploy with Ansible'){
            steps {
                sh 'pwd && ls -l'
                sh 'cd terraform-ec2'
                sh 'pwd && ls -l'
                sh 'ansible-playbook -i inventory.ini playbook.yaml'
            }
        }
    }
}

