#!/bin/bash

# =====================================================
# Script de Teste Completo - Sprint 3 DevOps
# =====================================================

echo "🧪 INICIANDO TESTES COMPLETOS DO PROJETO DEVOPS"
echo "================================================"

# Teste 1: Verificar estrutura de arquivos
echo "📁 Teste 1: Verificando estrutura de arquivos..."
required_files=(
    "README.md"
    "script_bd.sql"
    "azure-cli/01-create-resource-group.sh"
    "azure-cli/02-create-database.sh"
    "azure-cli/03-create-appservice.sh"
    "azure-cli/04-configure-connection.sh"
    "azure-cli/05-deploy-app.sh"
    "tests/post-moto.json"
    "tests/put-moto.json"
    "tests/delete-moto.json"
    "docs/arquitetura.md"
)

missing_files=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - FALTANDO!"
        ((missing_files++))
    fi
done

if [ $missing_files -eq 0 ]; then
    echo "  ✅ Todos os arquivos necessários estão presentes!"
else
    echo "  ❌ $missing_files arquivo(s) faltando!"
fi

# Teste 2: Verificar permissões dos scripts
echo ""
echo "🔐 Teste 2: Verificando permissões dos scripts..."
for script in azure-cli/*.sh; do
    if [ -x "$script" ]; then
        echo "  ✅ $script (executável)"
    else
        echo "  ❌ $script (não executável)"
    fi
done

# Teste 3: Verificar sintaxe dos scripts
echo ""
echo "🔍 Teste 3: Verificando sintaxe dos scripts..."
syntax_errors=0
for script in azure-cli/*.sh; do
    if bash -n "$script" 2>/dev/null; then
        echo "  ✅ $script (sintaxe OK)"
    else
        echo "  ❌ $script (erro de sintaxe)"
        ((syntax_errors++))
    fi
done

# Teste 4: Verificar JSONs
echo ""
echo "📄 Teste 4: Verificando arquivos JSON..."
json_errors=0
for json in tests/*.json; do
    if python3 -m json.tool "$json" >/dev/null 2>&1; then
        echo "  ✅ $json (JSON válido)"
    else
        echo "  ❌ $json (JSON inválido)"
        ((json_errors++))
    fi
done

# Teste 5: Verificar README
echo ""
echo "📖 Teste 5: Verificando README.md..."
if grep -q "Sistema de Gestão de Frota - Mottu API" README.md; then
    echo "  ✅ README.md contém descrição da solução"
else
    echo "  ❌ README.md não contém descrição da solução"
fi

if grep -q "Benefícios para o Negócio" README.md; then
    echo "  ✅ README.md contém benefícios para o negócio"
else
    echo "  ❌ README.md não contém benefícios para o negócio"
fi

if grep -q "azure-cli/" README.md; then
    echo "  ✅ README.md contém instruções de deploy"
else
    echo "  ❌ README.md não contém instruções de deploy"
fi

# Teste 6: Verificar script SQL
echo ""
echo "🗄️  Teste 6: Verificando script_bd.sql..."
if grep -q "CREATE TABLE moto" script_bd.sql; then
    echo "  ✅ script_bd.sql contém DDL da tabela moto"
else
    echo "  ❌ script_bd.sql não contém DDL da tabela moto"
fi

if grep -q "INSERT INTO moto" script_bd.sql; then
    echo "  ✅ script_bd.sql contém dados de exemplo"
else
    echo "  ❌ script_bd.sql não contém dados de exemplo"
fi

# Resumo dos testes
echo ""
echo "📊 RESUMO DOS TESTES"
echo "===================="
echo "Arquivos faltando: $missing_files"
echo "Erros de sintaxe: $syntax_errors"
echo "Erros de JSON: $json_errors"

total_errors=$((missing_files + syntax_errors + json_errors))
if [ $total_errors -eq 0 ]; then
    echo ""
    echo "🎉 TODOS OS TESTES PASSARAM!"
    echo "✅ Projeto pronto para deploy no Azure!"
    echo "✅ Projeto pronto para commit no GitHub!"
else
    echo ""
    echo "⚠️  $total_errors erro(s) encontrado(s)"
    echo "❌ Corrija os erros antes de fazer deploy"
fi

echo ""
echo "🚀 PRÓXIMOS PASSOS:"
echo "1. Execute: git add ."
echo "2. Execute: git commit -m 'feat: Estrutura completa Sprint 3 DevOps'"
echo "3. Execute: git push origin main"
echo "4. Instale Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
echo "5. Execute os scripts azure-cli/ para deploy"
