#!/bin/bash

# Navega a la carpeta de Terraform
cd infra || exit 1

# Ejecuta terraform output para obtener la IP pública
EC2_IP=$(terraform output -raw ec2_public_ip)

# Verifica que se obtuvo una IP válida
if [[ -z "$EC2_IP" ]]; then
  echo "No se pudo obtener la IP pública del EC2"
  exit 1
fi

# Regresa a la raíz del proyecto
cd ..

# Genera el archivo inventory.ini para Ansible
cat <<EOF > ansible/inventory.ini
[infraCar]
ec2-flask ansible_host=$EC2_IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/demoCar-jenkins_key.pem
EOF

echo "Archivo inventory.ini generado con IP: $EC2_IP"