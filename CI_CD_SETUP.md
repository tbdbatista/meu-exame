# 🤖 CI/CD Setup - GitHub Actions

## 📋 Visão Geral

Este projeto utiliza **GitHub Actions** para validação automática de builds em Pull Requests.

**Custo:** ✅ **100% GRATUITO** (usa o plano gratuito do GitHub Actions)

---

## 🚀 O que foi Configurado

### Workflow: `ios-pr-validation.yml`

**Localização:** `.github/workflows/ios-pr-validation.yml`

**Gatilhos:**
- ✅ Automaticamente em **todos os PRs** para `develop` ou `main`
- ✅ Execução manual via GitHub UI (workflow_dispatch)

**Runner:**
- 🖥️ **macOS 14** (Sonoma)
- 📱 **Xcode 15.4**
- 🎯 **Simulador:** iPhone 16 Pro (iOS 18.0)

---

## 🔄 Fluxo de CI/CD

```
1. 📥 Checkout do código
   └─> Usa actions/checkout@v4

2. 🔧 Setup Xcode
   └─> Seleciona Xcode 15.4

3. 💾 Cache do Tuist
   └─> Acelera builds subsequentes

4. 📦 Instala Tuist
   └─> curl -Ls https://install.tuist.io | bash

5. 💾 Cache do Swift Package Manager
   └─> Acelera resolução de dependências

6. 🏗️ Gera projeto com Tuist
   └─> tuist generate

7. 📦 Resolve dependências (Firebase, etc)
   └─> xcodebuild -resolvePackageDependencies

8. 🔨 Build do projeto
   └─> xcodebuild build
   └─> Usa xcpretty para output colorido

9. 🧪 Executa testes (se existirem)
   └─> xcodebuild test
   └─> continue-on-error (não falha se não houver testes)

10. 📤 Upload de logs (se falhar)
    └─> actions/upload-artifact@v4

11. 💬 Comenta resultado no PR
    └─> ✅ Sucesso ou ❌ Falha

12. 📊 Gera resumo do job
    └─> Visível na aba Actions
```

---

## 💰 Custos e Limites (GitHub Actions)

### Repositório Público:
```
✅ Minutos ILIMITADOS e GRATUITOS
✅ Runners macOS inclusos
✅ Zero custos
```

### Repositório Privado:
```
✅ 2.000 minutos/mês GRÁTIS
⚠️ macOS usa multiplicador 10x
   (1 minuto real = 10 minutos consumidos)
📊 ~200 minutos reais de macOS/mês
💡 Suficiente para ~40-50 builds
```

### Tempo Estimado por Build:
```
Primeira execução: ~8-12 minutos
  └─> Instala Tuist, resolve SPM, build from scratch

Execuções seguintes: ~3-5 minutos
  └─> Cache ativo (Tuist + SPM)
```

---

## 📊 Monitoramento

### Ver Status dos Workflows

1. **No Pull Request:**
   - Status badge aparece automaticamente
   - Comentário com resultado do build
   - ✅ ou ❌ visível no PR

2. **Na aba Actions:**
   - https://github.com/tbdbatista/meu-exame/actions
   - Ver logs detalhados
   - Download de artifacts (se houver falha)

3. **No Commit:**
   - ✅ ou ❌ ao lado de cada commit
   - Clique para ver detalhes

---

## 🎯 Quando o CI Roda

### ✅ Roda Automaticamente:
```
✅ Ao abrir um PR
✅ Ao fazer push em um PR existente
✅ Ao atualizar a branch do PR
✅ Ao fazer merge de outra branch no PR
```

### ❌ NÃO Roda:
```
❌ Em commits diretos na develop (sem PR)
❌ Em branches que não têm PR aberto
❌ Em branches de feature sem PR
```

**Motivo:** Economiza minutos do plano gratuito! 💰

---

## 🛠️ Como Funciona na Prática

### Exemplo de Fluxo:

```bash
# 1. Você cria uma feature branch
git checkout -b feature/nova-funcionalidade

# 2. Faz commits
git add .
git commit -m "feat: adiciona nova funcionalidade"
git push origin feature/nova-funcionalidade

# 3. Abre um PR no GitHub
gh pr create --base develop

# 4. 🤖 GitHub Actions detecta o PR
#    └─> Inicia workflow automaticamente

# 5. 📊 Resultado aparece no PR
#    ✅ Build passou → Pode fazer merge
#    ❌ Build falhou → Precisa corrigir
```

---

## 🔍 Detalhes Técnicos

### Configurações do Build

```yaml
Workspace: MeuExame.xcworkspace
Scheme: MeuExame
SDK: iphonesimulator
Destination: iPhone 16 Pro (iOS 18.0)
Configuration: Debug
Code Signing: Desabilitado (simulador não precisa)
```

### Cache Configurado

**Tuist Cache:**
```
Path: ~/.tuist, ~/Library/Caches/tuist
Key: ${{ runner.os }}-tuist-${{ hashFiles('**/Project.swift') }}
Invalida quando: Project.swift muda
```

**SPM Cache:**
```
Path: .build, ~/Library/Caches/org.swift.swiftpm
Key: ${{ runner.os }}-spm-${{ hashFiles('**/Project.swift') }}
Invalida quando: Dependências mudam
```

### Output Beautification

Usa `xcpretty` para output limpo:
```bash
xcodebuild ... | xcpretty --color --simple
```

**Resultado:**
- ✅ Build limpo e legível
- 🎨 Cores para erros/warnings
- 📊 Resumo ao final

---

## 🚨 Troubleshooting

### Build Falhou no CI mas Passa Local

**Possíveis causas:**
1. **Xcode version diferente**
   - CI: Xcode 15.4
   - Local: Verificar sua versão

2. **Cache desatualizado**
   - Limpar cache: tuist clean
   - Ou: Invalidar cache no Actions

3. **Dependência não commitada**
   - Verificar se todos os arquivos estão no git

### Como Ver Logs Detalhados

1. Acesse o PR no GitHub
2. Clique no status check (❌ ou ✅)
3. Clique em "Details"
4. Ver logs completos do build

### Como Re-executar o CI

**Opção 1: Push Vazio**
```bash
git commit --allow-empty -m "chore: trigger CI"
git push
```

**Opção 2: GitHub UI**
1. Vá para Actions
2. Selecione o workflow
3. Clique "Re-run jobs"

---

## 🎨 Customizações Possíveis

### Adicionar SwiftLint

```yaml
- name: 🧹 Run SwiftLint
  run: |
    if ! command -v swiftlint &> /dev/null; then
      brew install swiftlint
    fi
    swiftlint lint --strict
```

### Adicionar Danger

```yaml
- name: 🚨 Run Danger
  run: |
    gem install danger
    danger
```

### Adicionar Code Coverage

```yaml
- name: 📊 Generate Code Coverage
  run: |
    xcodebuild test \
      -workspace MeuExame.xcworkspace \
      -scheme MeuExame \
      -enableCodeCoverage YES \
      ...
```

### Notificações no Slack

```yaml
- name: 💬 Notify Slack
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## 📈 Métricas e Monitoramento

### Ver Uso de Minutos

1. Acesse: https://github.com/settings/billing
2. "Actions & Packages"
3. Ver consumo do mês atual

### Estimativa de Uso (Por Mês)

**Cenário Conservador:**
```
10 PRs/mês
× 3 pushes por PR
× 5 minutos por build
= 150 minutos reais
× 10 (multiplicador macOS)
= 1.500 minutos consumidos

Restante: 500 minutos (25% do plano)
```

**Cenário Intenso:**
```
20 PRs/mês
× 5 pushes por PR
× 5 minutos por build
= 500 minutos reais
× 10 (multiplicador macOS)
= 5.000 minutos consumidos

⚠️ Excede o plano gratuito!
```

**Solução para uso intenso:**
- Usar cache agressivamente (já configurado)
- Limitar CI apenas para PRs (já configurado)
- Considerar self-hosted runner (seu Mac)

---

## 🏠 Self-Hosted Runner (Avançado)

Se você quiser usar **seu próprio Mac** para rodar o CI:

**Vantagens:**
- ✅ Minutos ilimitados e gratuitos
- ✅ Mais rápido (sem cold start)
- ✅ Usa seu Xcode exato

**Desvantagens:**
- ❌ Mac precisa estar ligado
- ❌ Consome recursos locais
- ❌ Você gerencia o runner

**Como configurar:**
1. Repo Settings → Actions → Runners
2. "New self-hosted runner"
3. Siga instruções para macOS
4. Modificar workflow: `runs-on: self-hosted`

---

## 📝 Boas Práticas

### ✅ Do's

1. **Sempre fazer PR para develop**
   - CI valida antes do merge
   
2. **Não comitar em develop diretamente**
   - Usa feature branches
   
3. **Aguardar CI passar antes de merge**
   - Evita quebrar a develop
   
4. **Ler logs quando falhar**
   - Entender o erro

### ❌ Don'ts

1. **Não fazer merge com CI falhando**
   - Quebra o código para todos
   
2. **Não fazer push excessivo**
   - Gasta minutos desnecessariamente
   
3. **Não ignorar warnings**
   - Podem virar erros futuros

---

## 🎉 Benefícios do CI/CD

### Para Você:
- ✅ Detecta erros **antes** do merge
- ✅ Valida que o código compila
- ✅ Feedback rápido (3-5 minutos)
- ✅ Histórico de builds
- ✅ Confiança ao fazer merge

### Para o Time:
- ✅ Develop sempre funcional
- ✅ Menos bugs em produção
- ✅ Code review mais fácil
- ✅ Padrão de qualidade

### Para o Projeto:
- ✅ Profissionalismo
- ✅ Documentação automática
- ✅ Escalável
- ✅ Melhores práticas

---

## 🔗 Links Úteis

- **GitHub Actions Docs:** https://docs.github.com/actions
- **Pricing:** https://github.com/pricing
- **Billing:** https://github.com/settings/billing
- **Workflows deste repo:** https://github.com/tbdbatista/meu-exame/actions

---

## 📊 Status Atual

```
✅ Workflow configurado
✅ Cache otimizado
✅ Build automático em PRs
✅ Comentários automáticos
✅ 100% Gratuito (no limite)
✅ Pronto para usar
```

---

**Criado em:** 10/11/2025  
**Última atualização:** 10/11/2025  
**Versão:** 1.0

