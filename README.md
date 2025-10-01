# Sprint 3 - DevOps & Cloud
## Sistema de Gestão de Motos

### 1. Descrição da Solução

Este projeto implementa um sistema completo para cadastro e gestão de motos, permitindo realizar operações CRUD (Create, Read, Update, Delete) através de uma API REST. A aplicação permite:

- **Criar** novos registros de motos com modelo e placa
- **Listar** todas as motos cadastradas
- **Atualizar** informações de motos existentes
- **Excluir** registros de motos do sistema

A solução utiliza Spring Boot com Java 21 e PostgreSQL como banco de dados, garantindo alta performance e confiabilidade.

### 2. Benefícios para o Negócio

A solução oferece os seguintes benefícios estratégicos:

- **Digitalização completa**: Elimina planilhas manuais e processos baseados em papel
- **Confiabilidade dos dados**: Sistema de banco de dados garante integridade e consistência
- **Acessibilidade**: API REST permite integração com diferentes sistemas e aplicações
- **Escalabilidade**: Arquitetura em nuvem permite crescimento conforme demanda
- **Auditoria**: Controle completo de alterações e histórico de operações
- **Disponibilidade**: Deploy em nuvem garante acesso 24/7

### 3. Arquitetura da Solução

```
┌─────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Usuário   │───▶│  Aplicação Java     │───▶│  Banco PostgreSQL   │
│             │    │  (App Service)      │    │  (PaaS Azure)       │
│             │    │  Spring Boot        │    │  sprintdb           │
└─────────────┘    └─────────────────────┘    └─────────────────────┘
```

**Componentes:**
- **Frontend/Cliente**: Interface para interação com a API
- **Aplicação Java**: Spring Boot rodando no Azure App Service
- **Banco de Dados**: PostgreSQL hospedado no Azure Database for PostgreSQL

### 4. Deploy no Azure (App Service + PostgreSQL via CLI)

Execute os seguintes comandos Azure CLI para fazer o deploy completo da solução:

```bash
# 1. Criar grupo de recursos
az group create --name sprint3-rg --location brazilsouth

# 2. Criar servidor PostgreSQL
az postgres flexible-server create \
  --resource-group sprint3-rg \
  --name sprint3-postgres \
  --admin-user fiap \
  --admin-password SenhaForte123! \
  --location brazilsouth \
  --public-access all

# 3. Criar banco dentro do servidor
az postgres flexible-server db create \
  --resource-group sprint3-rg \
  --server-name sprint3-postgres \
  --database-name sprintdb

# 4. Criar plano do App Service
az appservice plan create \
  --name sprint3-plan \
  --resource-group sprint3-rg \
  --sku B1 \
  --is-linux

# 5. Criar WebApp Java 21
az webapp create \
  --resource-group sprint3-rg \
  --plan sprint3-plan \
  --name sprint3-javaapp \
  --runtime "JAVA:21-java21"

# 6. Configurar variáveis de ambiente
az webapp config appsettings set \
  --resource-group sprint3-rg \
  --name sprint3-javaapp \
  --settings \
  DB_URL="jdbc:postgresql://sprint3-postgres.postgres.database.azure.com:5432/sprintdb" \
  DB_USER="fiap" \
  DB_PASS="SenhaForte123!"

# 7. Deploy do .jar
az webapp deploy \
  --resource-group sprint3-rg \
  --name sprint3-javaapp \
  --type jar \
  --src-path target/*.jar
```

### 5. Testes CRUD

Após o deploy, utilize os seguintes exemplos para testar todas as operações:

#### **POST - Inserir Nova Moto**
```bash
curl -X POST https://sprint3-javaapp.azurewebsites.net/motos \
  -H "Content-Type: application/json" \
  -d '{
    "modelo": "Honda Biz 125",
    "placa": "DEF-9876"
  }'
```

#### **GET - Listar Todas as Motos**
```bash
curl -X GET https://sprint3-javaapp.azurewebsites.net/motos
```

#### **PUT - Atualizar Moto**
```bash
curl -X PUT https://sprint3-javaapp.azurewebsites.net/motos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "modelo": "Honda Pop 110i - Atualizada",
    "placa": "ABC-1234"
  }'
```

#### **DELETE - Remover Moto**
```bash
curl -X DELETE https://sprint3-javaapp.azurewebsites.net/motos/1
```

### 6. Link para o Código-Fonte

👉 **Repositório do código Java**: https://github.com/icaroalb1/mottuapi

### 7. Passos para o Vídeo

**Checklist para demonstração:**

- [ ] Clone do repositório `sprint3-devops-cloud`
- [ ] Execução dos comandos Azure CLI para deploy
- [ ] Configuração do App Service + Banco PostgreSQL
- [ ] Verificação da aplicação rodando no Azure
- [ ] Demonstração de todas as operações CRUD funcionando
- [ ] Teste de inserção de nova moto via POST
- [ ] Teste de listagem via GET
- [ ] Teste de atualização via PUT
- [ ] Teste de exclusão via DELETE
- [ ] Mostrar registros no banco via `psql` ou Azure Data Studio
- [ ] Validação de logs da aplicação no Azure Portal

**Comandos para verificar o banco:**
```bash
# Conectar ao PostgreSQL
psql "host=sprint3-postgres.postgres.database.azure.com port=5432 dbname=sprintdb user=fiap password=SenhaForte123! sslmode=require"

# Executar consultas
SELECT * FROM moto;
```

---

**Desenvolvido para Sprint 3 - DevOps & Cloud**  
**FIAP - Faculdade de Informática e Administração Paulista**
