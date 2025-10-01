# Diagrama de Arquitetura - Mottu API

## Visão Geral
Este documento descreve a arquitetura da solução Mottu API para gestão de frota de motos.

## Componentes da Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                        USUÁRIO FINAL                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Web App   │  │  Mobile App │  │   API Client│            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    AZURE APP SERVICE                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              MOTTU API (Spring Boot)                    │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │   │
│  │  │ Controllers │  │  Services   │  │ Repositories│     │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │   │
│  │  │   Models    │  │   Security  │  │   Config    │     │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘     │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                AZURE DATABASE FOR POSTGRESQL                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    mottudb                              │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │   │
│  │  │    moto     │  │    vaga     │  │movimentacao │     │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │   │
│  │  │localizacao  │  │   usuario   │  │    papel    │     │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘     │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Fluxo de Dados

1. **Requisição**: Usuário faz requisição via Web/Mobile/API
2. **Processamento**: App Service processa via Spring Boot
3. **Persistência**: Dados salvos no PostgreSQL
4. **Resposta**: Retorno JSON para o cliente

## Tecnologias Utilizadas

- **Backend**: Spring Boot + Java 21
- **Banco de Dados**: PostgreSQL 15
- **Cloud**: Microsoft Azure
- **Deploy**: Azure App Service
- **Monitoramento**: Azure Monitor

## Segurança

- Autenticação via Spring Security
- Conexão SSL com banco de dados
- Validação de entrada de dados
- Logs de auditoria

## Escalabilidade

- App Service auto-scaling
- Banco de dados gerenciado
- Load balancing automático
- Monitoramento de performance
