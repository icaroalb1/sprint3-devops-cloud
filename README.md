# Sprint 3 - DevOps & Cloud ## Sistema de Gestão de Frota - Mottu API ### 

1. Descrição da Solução
Este projeto implementa uma **API REST completa** para gestão de frota de motos da Mottu, permitindo controle total sobre veículos e suas movimentações.
A aplicação oferece:
 **Gestão de Motos**: Cadastro, consulta, atualização e exclusão de motos
 **Controle de Status**: Acompanhamento de disponibilidade, manutenção e localização 
 **Movimentações**: Registro de entrada/saída de veículos
 **Gestão de Vagas**: Controle de ocupação de estacionamentos
 **Localização**: Rastreamento GPS das motos em tempo real 
 A solução utiliza **Spring Boot com Java 21** e **PostgreSQL** como banco de dados, garantindo alta performance, escalabilidade e confiabilidade para operações críticas da Mottu. ### 

2. Benefícios para o Negócio A solução oferece os seguintes benefícios estratégicos para a Mottu: - 
**Controle Eficiente de Frota**: Visibilidade completa de todos os veículos e seu status - 
**Otimização de Recursos**: Gestão inteligente de vagas e movimentações -
**Redução de Perdas**: Rastreamento GPS previne furtos e uso indevido - 
**Automação de Processos**: Elimina controles manuais e planilhas -
**Escalabilidade**: Suporta crescimento da frota sem impacto na performance - 
**Disponibilidade 24/7**: Sistema sempre disponível na nuvem - 
**Auditoria Completa**: Histórico detalhado de todas as operações - 
**Integração**: API REST permite integração com outros sistemas da Mottu ### 

3. Arquitetura da Solução
┌─────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Usuário   │───▶│  Mottu API          │───▶│  PostgreSQL         │
│   (Web/Mobile)│    │  (App Service)      │    │  (Azure Database)   │
│             │    │  Spring Boot + Java21│    │  mottudb            │
└─────────────┘    └─────────────────────┘    └─────────────────────┘
**Componentes:** - **Frontend/Cliente**: Interface web ou mobile para operadores - **Mottu API**: Spring Boot rodando no Azure App Service - **Banco de Dados**: PostgreSQL hospedado no Azure Database for PostgreSQL - **Monitoramento**: Logs e métricas via Azure Monitor ### 4. Deploy no Azure (App Service + PostgreSQL via CLI) Execute os scripts na ordem para fazer o deploy completo da solução:
bash
# 1. Criar grupo de recursos
./azure-cli/01-create-resource-group.sh

# 2. Criar servidor PostgreSQL
./azure-cli/02-create-database.sh

# 3. Criar App Service Plan e App Service
./azure-cli/03-create-appservice.sh

# 4. Configurar connection string
./azure-cli/04-configure-connection.sh

#5 Deploy via CLI
1. Criar Resource Group az group create --name sprint3-rg --location brazilsouth
2. Criar PostgreSQL Flexible Server az postgres flexible-server create --resource-group sprint3-rg --name sprint3-postgres --admin-user fiap --admin-password SenhaForte123! --location brazilsouth --public-access all 
3. Criar Banco de Dados sprintdb az postgres flexible-server db create --resource-group sprint3-rg --server-name sprint3-postgres --database-name sprintdb 
4. Criar App Service Plan az appservice plan create --name sprint3-plan --resource-group sprint3-rg --sku B1 --is-linux 
5. Criar WebApp (Java 21) az webapp create --resource-group sprint3-rg --plan sprint3-plan --name sprint3-javaapp --runtime "JAVA:21-java21" 
6. Configurar Variáveis de Ambiente (para conexão ao Postgres) az webapp config appsettings set --resource-group sprint3-rg --name sprint3-javaapp --settings SPRING_DATASOURCE_URL="jdbc:postgresql://sprint3-postgres.postgres.database.azure.com:5432/sprintdb" SPRING_DATASOURCE_USERNAME="fiap" SPRING_DATASOURCE_PASSWORD="SenhaForte123!"
7. Fazer o Build do Projeto (no seu PC, na pasta do Java) ./mvnw clean package -DskipTests Isso vai gerar target/mottuapi-0.0.1-SNAPSHOT.jar. No PowerShell, se der erro com ./mvnw, rode: mvnw.cmd clean package -DskipTests 
8. Deploy do .jar para o App Service az webapp deploy --resource-group sprint3-rg --name sprint3-javaapp --type jar --src-path target\mottuapi-0.0.1-SNAPSHOT.jar 
9. Testar no navegador/Postman Swagger: https://sprint3-javaapp.azurewebsites.net/swagger-ui.html Endpoint CRUD (exemplo): https://sprint3-javaapp.azurewebsites.net/motos 
10. Verificar Banco de Dados 
psql "host=sprint3-postgres.postgres.database.azure.com port=5432 dbname=sprintdb user=fiap password=SenhaForte123!"
\dt;
SELECT * FROM moto;

# 5. Deploy da aplicação
./azure-cli/05-deploy-app.sh
### 5. Testes da API Após o deploy, utilize os exemplos JSON para testar todas as operações: #### **POST - Criar Nova Moto**
bash
curl -X POST https://mottuapi-app.azurewebsites.net/motos \
  -H "Content-Type: application/json" \
  -d @tests/post-moto.json
#### **GET - Listar Todas as Motos**
bash
curl -X GET https://mottuapi-app.azurewebsites.net/motos
#### **PUT - Atualizar Moto**
bash
curl -X PUT https://mottuapi-app.azurewebsites.net/motos/1 \
  -H "Content-Type: application/json" \
  -d @tests/put-moto.json
#### **DELETE - Remover Moto**
bash
curl -X DELETE https://mottuapi-app.azurewebsites.net/motos/1
### 6. Estrutura do Projeto
sprint3-devops-cloud/
├── README.md                    # Documentação principal
├── script_bd.sql               # DDL da tabela moto
├── azure-cli/                  # Scripts de deploy Azure
│   ├── 01-create-resource-group.sh
│   ├── 02-create-database.sh
│   ├── 03-create-appservice.sh
│   ├── 04-configure-connection.sh
│   └── 05-deploy-app.sh
├── tests/                      # Exemplos de teste JSON
│   ├── post-moto.json
│   ├── put-moto.json
│   └── delete-moto.json
└── docs/                       # Documentação adicional
    └── arquitetura.png
### 7. Links Importantes - **Repositório Java**: https://github.com/icaroalb1/mottuapi - **Repositório DevOps**: https://github.com/icaroalb1/sprint3-devops-cloud - **Vídeo Demonstrativo**: https://youtube.com/watch\?v\=SEU_VIDEO_ID_AQUI ### 8. Diagrama de Arquitetura Consulte o arquivo docs/arquitetura.png para visualizar o diagrama completo da solução. ### 9. Validação do Deploy **Checklist para demonstração:** - [ ] Clone do repositório sprint3-devops-cloud - [ ] Execução dos scripts Azure CLI para deploy - [ ] Configuração do App Service + Banco PostgreSQL - [ ] Verificação da aplicação rodando no Azure - [ ] Demonstração de todas as operações CRUD funcionando - [ ] Teste de inserção de nova moto via POST - [ ] Teste de listagem via GET - [ ] Teste de atualização via PUT - [ ] Teste de exclusão via DELETE - [ ] Validação de logs da aplicação no Azure Portal **Comandos para verificar o banco:**
bash
# Conectar ao PostgreSQL
psql "host=dbmottu.postgres.database.azure.com port=5432 dbname=mottudb user=mottuadmin password=SenhaForte123! sslmode=require"

# Executar consultas
SELECT * FROM moto;
--- **Desenvolvido para Sprint 3 - DevOps & Cloud** **FIAP - Faculdade de Informática e Administração Paulista**
