Sprint 3 - DevOps & Cloud
Sistema de Gestão de Frota - Mottu API
1. Descrição da Solução

Este projeto implementa uma API REST para gestão de frota de motos da Mottu, permitindo:

Cadastro, consulta, atualização e exclusão de motos

Acompanhamento de status (disponível, manutenção, etc.)

Registro de movimentações de entrada/saída

Controle de vagas e ocupação

Integração com rastreamento em tempo real

Tecnologias: Spring Boot (Java 21) + PostgreSQL (Azure Database).

2. Benefícios para o Negócio

Controle Eficiente de Frota

Redução de Perdas com rastreamento

Automação (sem planilhas manuais)

Escalabilidade e Alta Disponibilidade na nuvem

Integração via API REST

3. Arquitetura da Solução
┌─────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Usuário   │───▶│  Mottu API (AppSvc) │───▶│ PostgreSQL (Azure)  │
│ Web/Mobile  │    │ Spring Boot + Java21 │   │ sprintdb             │
└─────────────┘    └─────────────────────┘    └─────────────────────┘


Frontend: Web/Mobile

Mottu API: App Service (Java 21)

Banco: PostgreSQL na Azure

Monitoramento: Azure Monitor

4. Deploy via Azure CLI
Passo a Passo

Criar Resource Group

az group create --name sprint3-rg --location brazilsouth


Criar PostgreSQL Flexible Server

az postgres flexible-server create --resource-group sprint3-rg --name sprint3-postgres --admin-user fiap --admin-password SenhaForte123! --location brazilsouth --public-access all


Criar Banco de Dados

az postgres flexible-server db create --resource-group sprint3-rg --server-name sprint3-postgres --database-name sprintdb


Criar App Service Plan

az appservice plan create --name sprint3-plan --resource-group sprint3-rg --sku B1 --is-linux


Criar WebApp (Java 21)

az webapp create --resource-group sprint3-rg --plan sprint3-plan --name sprint3-javaapp --runtime "JAVA:21-java21"


Configurar Variáveis de Ambiente

az webapp config appsettings set --resource-group sprint3-rg --name sprint3-javaapp --settings SPRING_DATASOURCE_URL="jdbc:postgresql://sprint3-postgres.postgres.database.azure.com:5432/sprintdb" SPRING_DATASOURCE_USERNAME="fiap" SPRING_DATASOURCE_PASSWORD="SenhaForte123!"


Build do Projeto Java
No Linux/Mac:

./mvnw clean package -DskipTests


No Windows:

mvnw.cmd clean package -DskipTests


👉 Gera target/mottuapi-0.0.1-SNAPSHOT.jar

Deploy do .jar no App Service

az webapp deploy --resource-group sprint3-rg --name sprint3-javaapp --type jar --src-path target\mottuapi-0.0.1-SNAPSHOT.jar

5. Testes da API

Swagger: https://sprint3-javaapp.azurewebsites.net/swagger-ui.html

Endpoint CRUD: https://sprint3-javaapp.azurewebsites.net/motos

Exemplos

POST - Criar Moto

{
  "placa": "ABC1D23",
  "modelo": "Honda CG 160",
  "status": "DISPONIVEL",
  "ligada": false
}


GET - Listar Motos

curl -X GET https://sprint3-javaapp.azurewebsites.net/motos


PUT - Atualizar Moto

{
  "placa": "ABC1D23",
  "modelo": "Honda CG 160 Start",
  "status": "EM_MANUTENCAO",
  "ligada": true
}


DELETE - Remover Moto

curl -X DELETE https://sprint3-javaapp.azurewebsites.net/motos/1

6. Banco de Dados

Conectar:

psql "host=sprint3-postgres.postgres.database.azure.com port=5432 dbname=sprintdb user=fiap password=SenhaForte123!"


Listar tabelas:

\dt;


Ver registros:

SELECT * FROM moto;

7. Estrutura do Projeto
sprint3-devops-cloud/
├── README.md
├── script_bd.sql
├── azure-cli/
│   ├── 01-create-resource-group.sh
│   ├── 02-create-database.sh
│   ├── 03-create-appservice.sh
│   ├── 04-configure-connection.sh
│   └── 05-deploy-app.sh
├── tests/
│   ├── post-moto.json
│   ├── put-moto.json
│   └── delete-moto.json
└── docs/
    └── arquitetura.png

8. Links Importantes

Repositório Java: https://github.com/icaroalb1/mottuapi

Repositório DevOps: https://github.com/icaroalb1/sprint3-devops-cloud

Vídeo Demonstrativo: https://youtube.com/watch?v=SEU_VIDEO_ID_AQUI
