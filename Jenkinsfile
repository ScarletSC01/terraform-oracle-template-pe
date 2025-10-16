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
                    writeFile file: 'gcp_key.json', text: env.CREDENTIALS_JSON
                    def tfvars = "-var=\"credentials_content=${env.CREDENTIALS_JSON}\" -var=\"project_id=${PROJECT_ID}\" -var=\"region=${REGION}\" -var=\"zone=${ZONE}\""
                    if (params.ACTION == 'plan') {
                        sh "terraform plan ${tfvars} -out=tfplan"
                    } else if (params.ACTION == 'apply') {
                        sh "terraform apply -auto-approve ${tfvars}"
                    } else if (params.ACTION == 'destroy') {
                        sh "terraform destroy -auto-approve ${tfvars}"
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
