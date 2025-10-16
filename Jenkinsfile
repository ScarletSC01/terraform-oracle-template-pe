pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Selecciona la acción de Terraform a ejecutar'
        )
    }

    environment {
        PROJECT_ID = "jenkins-terraform-demo-472920"
        REGION     = "southamerica-west1"
        ZONE       = "southamerica-west1-a"
    }

    stages {

        stage('Preparar credenciales') {
            steps {
                withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GCP_KEY_FILE')]) {
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

        stage('Ejecutar Terraform') {
            steps {
                script {
                    // Guardar credenciales en un archivo temporal
                    writeFile file: 'credentials.json', text: CREDENTIALS_CONTENT

                    // Construir comando según la acción seleccionada
                    def baseCommand = """
                        terraform ${params.ACTION} \\
                          -var="credentials_content=$(cat credentials.json)" \\
                          -var="project_id=${PROJECT_ID}" \\
                          -var="region=${REGION}" \\
                          -var="zone=${ZONE}"
                    """

                    if (params.ACTION == 'plan') {
                        sh "${baseCommand} -out=tfplan"
                    } else if (params.ACTION == 'apply') {
                        sh "terraform apply -auto-approve tfplan"
                    } else if (params.ACTION == 'destroy') {
                        sh "${baseCommand} -auto-approve"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Acción de Terraform '${params.ACTION}' ejecutada correctamente en ${PROJECT_ID}."
        }
        failure {
            echo "Error ejecutando la acción de Terraform '${params.ACTION}' en ${PROJECT_ID}."
        }
    }
}
