#!/bin/bash

# =====================================================
# Script 04: Configurar Connection String do App Service
# Sprint 3 - DevOps & Cloud - Mottu API
# =====================================================

echo "🚀 Configurando connection string do App Service..."

# Configurações
RESOURCE_GROUP="rg-mottu"
APP_NAME="mottuapi-app"
SERVER_NAME="dbmottu"
DATABASE_NAME="mottudb"
ADMIN_USER="mottuadmin"
ADMIN_PASSWORD="SenhaForte123!"

# Construir connection string
CONNECTION_STRING="jdbc:postgresql://$SERVER_NAME.postgres.database.azure.com:5432/$DATABASE_NAME?user=$ADMIN_USER&password=$ADMIN_PASSWORD&sslmode=require"

echo "📦 Configurando variáveis de ambiente..."

# Configurar variáveis de ambiente
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --settings \
    SPRING_DATASOURCE_URL="jdbc:postgresql://$SERVER_NAME.postgres.database.azure.com:5432/$DATABASE_NAME" \
    SPRING_DATASOURCE_USERNAME="$ADMIN_USER" \
    SPRING_DATASOURCE_PASSWORD="$ADMIN_PASSWORD" \
    SPRING_JPA_HIBERNATE_DDL_AUTO="validate" \
    SPRING_JPA_SHOW_SQL="true" \
    SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT="org.hibernate.dialect.PostgreSQLDialect" \
    SERVER_PORT="8080"

if [ $? -eq 0 ]; then
    echo "✅ Variáveis de ambiente configuradas com sucesso!"
else
    echo "❌ Erro ao configurar variáveis de ambiente!"
    exit 1
fi

# Exibir configurações
echo "📋 Configurações aplicadas:"
az webapp config appsettings list --resource-group $RESOURCE_GROUP --name $APP_NAME --output table

echo "🔗 Connection String configurada:"
echo "   $CONNECTION_STRING"

echo "🎯 Próximo passo: Execute ./05-deploy-app.sh"
