#!/bin/bash

# =====================================================
# Script 05: Deploy da Aplicação Mottu API
# Sprint 3 - DevOps & Cloud - Mottu API
# =====================================================

echo "🚀 Iniciando deploy da aplicação Mottu API..."

# Configurações
RESOURCE_GROUP="rg-mottu"
APP_NAME="mottuapi-app"
JAR_FILE="target/mottuapi-0.0.1-SNAPSHOT.jar"

# Verificar se o arquivo JAR existe
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ Arquivo JAR não encontrado: $JAR_FILE"
    echo "📋 Certifique-se de que o projeto foi compilado com: mvn clean package"
    echo "📋 Ou ajuste a variável JAR_FILE no script"
    exit 1
fi

echo "📦 Arquivo JAR encontrado: $JAR_FILE"
echo "📏 Tamanho do arquivo: $(du -h $JAR_FILE | cut -f1)"

# Fazer deploy do JAR
echo "🚀 Fazendo deploy do JAR para o App Service..."
az webapp deploy \
    --resource-group $RESOURCE_GROUP \
    --name $APP_NAME \
    --type jar \
    --src-path $JAR_FILE

if [ $? -eq 0 ]; then
    echo "✅ Deploy realizado com sucesso!"
else
    echo "❌ Erro durante o deploy!"
    exit 1
fi

# Aguardar aplicação inicializar
echo "⏳ Aguardando aplicação inicializar..."
sleep 30

# Verificar status da aplicação
echo "📋 Verificando status da aplicação..."
az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME --query "state" --output tsv

# Testar endpoint
echo "🧪 Testando endpoint da aplicação..."
APP_URL="https://$APP_NAME.azurewebsites.net"
echo "🌐 URL da aplicação: $APP_URL"

# Testar endpoint de saúde (se existir)
echo "🔍 Testando conectividade..."
if curl -s --max-time 30 "$APP_URL/motos" > /dev/null; then
    echo "✅ Aplicação respondendo corretamente!"
    echo "📋 Endpoint testado: $APP_URL/motos"
else
    echo "⚠️  Aplicação pode estar inicializando ainda..."
    echo "📋 Verifique os logs: az webapp log tail --resource-group $RESOURCE_GROUP --name $APP_NAME"
fi

echo "🎉 Deploy concluído!"
echo "🌐 Acesse sua aplicação em: $APP_URL"
echo "📋 Para ver logs: az webapp log tail --resource-group $RESOURCE_GROUP --name $APP_NAME"
echo "🎯 Próximo passo: Execute os testes em tests/"
