#!/bin/bash

# =====================================================
# Script 03: Criar App Service Plan e App Service
# Sprint 3 - DevOps & Cloud - Mottu API
# =====================================================

echo "🚀 Iniciando criação do App Service..."

# Configurações
RESOURCE_GROUP="rg-mottu"
APP_PLAN_NAME="mottu-plan"
APP_NAME="mottuapi-app"
LOCATION="brazilsouth"
SKU="B1"

# Verificar se o App Service Plan já existe
if az appservice plan show --resource-group $RESOURCE_GROUP --name $APP_PLAN_NAME &>/dev/null; then
    echo "⚠️  App Service Plan '$APP_PLAN_NAME' já existe!"
else
    echo "📦 Criando App Service Plan '$APP_PLAN_NAME'..."
    
    # Criar App Service Plan
    az appservice plan create \
        --resource-group $RESOURCE_GROUP \
        --name $APP_PLAN_NAME \
        --location $LOCATION \
        --sku $SKU \
        --is-linux \
        --tags "Project=MottuAPI" "Environment=Production"
    
    if [ $? -eq 0 ]; then
        echo "✅ App Service Plan criado com sucesso!"
    else
        echo "❌ Erro ao criar App Service Plan!"
        exit 1
    fi
fi

# Verificar se o App Service já existe
if az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME &>/dev/null; then
    echo "⚠️  App Service '$APP_NAME' já existe!"
    echo "📋 Detalhes do App Service existente:"
    az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME --output table
else
    echo "📦 Criando App Service '$APP_NAME'..."
    
    # Criar App Service
    az webapp create \
        --resource-group $RESOURCE_GROUP \
        --plan $APP_PLAN_NAME \
        --name $APP_NAME \
        --runtime "JAVA:21-java21" \
        --tags "Project=MottuAPI" "Environment=Production"
    
    if [ $? -eq 0 ]; then
        echo "✅ App Service criado com sucesso!"
        echo "🌐 URL da aplicação: https://$APP_NAME.azurewebsites.net"
    else
        echo "❌ Erro ao criar App Service!"
        exit 1
    fi
fi

# Exibir informações do App Service
echo "📋 Informações do App Service:"
az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME --output table

echo "🎯 Próximo passo: Execute ./04-configure-connection.sh"
