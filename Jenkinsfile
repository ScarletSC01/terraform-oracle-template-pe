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
        PROJECT_ID = 'jenkins-terraform-demo'  
        REGION     = 'southamerica-west1'          // Región de Perú
        ZONE       = 'southamerica-west1-a'        // Zona de Perú
    }

    stages {
        stage('Preparar credenciales') {
            steps {
                withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GCP_KEY_FILE')]) { // Cambiado credencial para Perú
                    script {
                        // Leer contenido del archivo JSON para pasarlo como variable a Terraform
                        env.CREDENTIALS_JSON = readFile(env.GCP_KEY_FILE).trim()
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
                   // Guardar el contenido del JSON de credenciales en un archivo temporal
            writeFile file: 'credentials.json', text: CREDENTIALS_CONTENT

            // Ejecutar Terraform con el archivo de credenciales
            sh """
                terraform plan \
                  -var="credentials_content=\$(cat credentials.json)" \
                  -var="project_id=${PROJECT_ID}" \
                  -var="region=${REGION}" \
                  -var="zone=${ZONE}" \
                  -out=tfplan
            """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Acción de Terraform '${params.ACTION}' completada correctamente."
        }
        failure {
            echo "Error ejecutando la acción de Terraform '${params.ACTION}'."
        }
    }
}
