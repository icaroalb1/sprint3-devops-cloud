Sprint 3 - DevOps & Cloud
Sistema de Gestão de Frota - Mottu API
1. Descrição da Solução

Este projeto implementa uma API REST completa para gestão de frota de motos da Mottu, permitindo controle total sobre veículos e suas movimentações. A aplicação oferece:

Gestão de Motos: Cadastro, consulta, atualização e exclusão de motos

Controle de Status: Acompanhamento de disponibilidade, manutenção e localização

Movimentações: Registro de entrada/saída de veículos

Gestão de Vagas: Controle de ocupação de estacionamentos

Localização: Rastreamento GPS das motos em tempo real

A solução utiliza Spring Boot com Java 21 e PostgreSQL como banco de dados, garantindo alta performance, escalabilidade e confiabilidade para operações críticas da Mottu.

2. Benefícios para o Negócio

A solução oferece os seguintes benefícios estratégicos para a Mottu:

Controle Eficiente de Frota: Visibilidade completa de todos os veículos e seu status

Otimização de Recursos: Gestão inteligente de vagas e movimentações

Redução de Perdas: Rastreamento GPS previne furtos e uso indevido

Automação de Processos: Elimina controles manuais e planilhas

Escalabilidade: Suporta crescimento da frota sem impacto na performance

Disponibilidade 24/7: Sistema sempre disponível na nuvem

Auditoria Completa: Histórico detalhado de todas as operações

Integração: API REST permite integração com outros sistemas da Mottu

3. Arquitetura da Solução
┌─────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Usuário   │───▶│  Mottu API          │───▶│  PostgreSQL         │
│ (Web/Mobile)│    │  (App Service)      │    │  (Azure Database)   │
│             │    │  Spring Boot + Java21│   │  sprintdb           │
└─────────────┘    └─────────────────────┘    └─────────────────────┘


Componentes:

Frontend/Cliente: Interface web ou mobile para operadores

Mottu API: Spring Boot rodando no Azure App Service

Banco de Dados: PostgreSQL hospedado no Azure Database for PostgreSQL

Monitoramento: Logs e métricas via Azure Monitor

4. Deploy no Azure (Scripts CLI)

Os scripts organizados estão na pasta azure-cli/:

01-create-resource-group.sh

02-create-database.sh

03-create-appservice.sh

04-configure-connection.sh

05-deploy-app.sh

5. Passo a Passo do Deploy via Azure CLI

Criar Resource Group

az group create --name sprint3-rg --location brazilsouth


Criar PostgreSQL Flexible Server

az postgres flexible-server create --resource-group sprint3-rg --name sprint3-postgres --admin-user fiap --admin-password SenhaForte123! --location brazilsouth --public-access all


Criar Banco de Dados sprintdb

az postgres flexible-server db create --resource-group sprint3-rg --server-name sprint3-postgres --database-name sprintdb


Criar App Service Plan

az appservice plan create --name sprint3-plan --resource-group sprint3-rg --sku B1 --is-linux


Criar WebApp (Java 21)

az webapp create --resource-group sprint3-rg --plan sprint3-plan --name sprint3-javaapp --runtime "JAVA:21-java21"


Configurar Variáveis de Ambiente

az webapp config appsettings set --resource-group sprint3-rg --name sprint3-javaapp --settings SPRING_DATASOURCE_URL="jdbc:postgresql://sprint3-postgres.postgres.database.azure.com:5432/sprintdb" SPRING_DATASOURCE_USERNAME="fiap" SPRING_DATASOURCE_PASSWORD="SenhaForte123!"


Fazer o Build do Projeto (Java)
No Linux/Mac:

./mvnw clean package -DskipTests


No Windows PowerShell:

mvnw.cmd clean package -DskipTests


👉 Isso gera: target/mottuapi-0.0.1-SNAPSHOT.jar

Deploy do .jar para o App Service

az webapp deploy --resource-group sprint3-rg --name sprint3-javaapp --type jar --src-path target\mottuapi-0.0.1-SNAPSHOT.jar


Testar no navegador/Postman

Swagger: https://sprint3-javaapp.azurewebsites.net/swagger-ui.html

Endpoint CRUD: https://sprint3-javaapp.azurewebsites.net/motos

Verificar Banco de Dados

psql "host=sprint3-postgres.postgres.database.azure.com port=5432 dbname=sprintdb user=fiap password=SenhaForte123!"
\dt;
SELECT * FROM moto;

6. Testes da API
POST - Criar Nova Moto
curl -X POST https://sprint3-javaapp.azurewebsites.net/motos \
  -H "Content-Type: application/json" \
  -d @tests/post-moto.json

GET - Listar Todas as Motos
curl -X GET https://sprint3-javaapp.azurewebsites.net/motos

PUT - Atualizar Moto
curl -X PUT https://sprint3-javaapp.azurewebsites.net/motos/1 \
  -H "Content-Type: application/json" \
  -d @tests/put-moto.json

DELETE - Remover Moto
curl -X DELETE https://sprint3-javaapp.azurewebsites.net/motos/1

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
