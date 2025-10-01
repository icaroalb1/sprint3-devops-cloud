#!/bin/bash

# =====================================================
# Script 01: Criar Grupo de Recursos no Azure
# Sprint 3 - DevOps & Cloud - Mottu API
# =====================================================

echo "🚀 Iniciando criação do grupo de recursos..."

# Configurações
RESOURCE_GROUP="rg-mottu"
LOCATION="brazilsouth"

# Verificar se já existe
if az group show --name $RESOURCE_GROUP &>/dev/null; then
    echo "⚠️  Grupo de recursos '$RESOURCE_GROUP' já existe!"
    echo "📋 Detalhes do grupo existente:"
    az group show --name $RESOURCE_GROUP --output table
else
    echo "�� Criando grupo de recursos '$RESOURCE_GROUP' na região '$LOCATION'..."
    
    # Criar grupo de recursos
    az group create \
        --name $RESOURCE_GROUP \
        --location $LOCATION \
        --tags "Project=MottuAPI" "Environment=Production" "Sprint=3"
    
    if [ $? -eq 0 ]; then
        echo "✅ Grupo de recursos criado com sucesso!"
        echo "📋 Detalhes:"
        az group show --name $RESOURCE_GROUP --output table
    else
        echo "❌ Erro ao criar grupo de recursos!"
        exit 1
    fi
fi

echo "🎯 Próximo passo: Execute ./02-create-database.sh"
