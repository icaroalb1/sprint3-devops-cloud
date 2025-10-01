#!/bin/bash

# =====================================================
# Script 02: Criar PostgreSQL Database no Azure
# Sprint 3 - DevOps & Cloud - Mottu API
# =====================================================

echo "🚀 Iniciando criação do banco de dados PostgreSQL..."

# Configurações
RESOURCE_GROUP="rg-mottu"
SERVER_NAME="dbmottu"
ADMIN_USER="mottuadmin"
ADMIN_PASSWORD="SenhaForte123!"
DATABASE_NAME="mottudb"
LOCATION="brazilsouth"

# Verificar se o servidor já existe
if az postgres flexible-server show --resource-group $RESOURCE_GROUP --name $SERVER_NAME &>/dev/null; then
    echo "⚠️  Servidor PostgreSQL '$SERVER_NAME' já existe!"
    echo "📋 Detalhes do servidor existente:"
    az postgres flexible-server show --resource-group $RESOURCE_GROUP --name $SERVER_NAME --output table
else
    echo "📦 Criando servidor PostgreSQL '$SERVER_NAME'..."
    
    # Criar servidor PostgreSQL
    az postgres flexible-server create \
        --resource-group $RESOURCE_GROUP \
        --name $SERVER_NAME \
        --admin-user $ADMIN_USER \
        --admin-password $ADMIN_PASSWORD \
        --location $LOCATION \
        --public-access all \
        --sku-name Standard_B1ms \
        --tier Burstable \
        --version 15 \
        --storage-size 32 \
        --tags "Project=MottuAPI" "Environment=Production"
    
    if [ $? -eq 0 ]; then
        echo "✅ Servidor PostgreSQL criado com sucesso!"
    else
        echo "❌ Erro ao criar servidor PostgreSQL!"
        exit 1
    fi
fi

# Criar banco de dados
echo "📦 Criando banco de dados '$DATABASE_NAME'..."
az postgres flexible-server db create \
    --resource-group $RESOURCE_GROUP \
    --server-name $SERVER_NAME \
    --database-name $DATABASE_NAME

if [ $? -eq 0 ]; then
    echo "✅ Banco de dados '$DATABASE_NAME' criado com sucesso!"
else
    echo "❌ Erro ao criar banco de dados!"
    exit 1
fi

# Exibir informações de conexão
echo "📋 Informações de conexão:"
echo "   Host: $SERVER_NAME.postgres.database.azure.com"
echo "   Port: 5432"
echo "   Database: $DATABASE_NAME"
echo "   Username: $ADMIN_USER"
echo "   Password: $ADMIN_PASSWORD"
echo "   Connection String: jdbc:postgresql://$SERVER_NAME.postgres.database.azure.com:5432/$DATABASE_NAME?user=$ADMIN_USER&password=$ADMIN_PASSWORD&sslmode=require"

echo "🎯 Próximo passo: Execute ./03-create-appservice.sh"
