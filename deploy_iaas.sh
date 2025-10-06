# Variables IaaS
RG_MV="diego_group"
VM_NAME="diego"
LOCATION="eastus" 
ADMIN_USER="diego02"

# 1. Crear el Grupo de Recursos (Si no existe)
az group create --name $RG_MV --location $LOCATION

# 2. Crear la Máquina Virtual Linux
az vm create \
  --resource-group $RG_MV \
  --name $VM_NAME \
  --image UbuntuLTS \
  --admin-username $ADMIN_USER \
  --ssh-key-value ~/.ssh/id_rsa.pub \
  --size Standard_B1s \
  --public-ip-sku Standard

# 3. Configurar NSG: Abrir el Puerto 80 (HTTP)
az vm open-port \
  --resource-group $RG_MV \
  --name $VM_NAME \
  --port 80 \
  --priority 100 

# 4. Despliegue de Nginx (Comando CLI de automatización intentado)
az vm extension set \
  --resource-group $RG_MV \
  --vm-name $VM_NAME \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --version 2.1 \
  --settings '{"commandToExecute": "sudo apt-get update && sudo apt-get install -y nginx"}'