pipeline {
    agent any

    environment {
        PROJECT_ID = "jenkins-terraform-demo-472920"
        REGION = "southamerica-west1"
        ZONE = "southamerica-west1-a"
    }

    stages {

        stage('Preparar credenciales') {
            steps {
                withCredentials([file(credentialsId: 'GCP_KEY_FILE', variable: 'GCP_KEY_FILE')]) {
                    script {
                        CREDENTIALS_CONTENT = readFile(GCP_KEY_FILE)
                    }
                }
            }
        }

        stage('Inicializar Terraform') {
            steps {
                sh 'terraform init -reconfigure'
            }
        }

        stage('Ejecutar Terraform Plan') {
            steps {
                script {
                    // Guardar el JSON de credenciales en un archivo temporal
                    writeFile file: 'credentials.json', text: CREDENTIALS_CONTENT

                    // Ejecutar terraform plan
                    sh '''
                        terraform plan \
                          -var="credentials_content=$(cat credentials.json)" \
                          -var="project_id=${PROJECT_ID}" \
                          -var="region=${REGION}" \
                          -var="zone=${ZONE}" \
                          -out=tfplan
                    '''
                }
            }
        }

        stage('Aplicar cambios (opcional)') {
            when {
                expression { return params.APPLY == true }
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo "Terraform ejecutado correctamente para ${PROJECT_ID}"
        }
        failure {
            echo "Error ejecutando Terraform en ${PROJECT_ID}"
        }
    }
}
