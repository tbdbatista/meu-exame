# 🚀 Exemplo Prático: Próxima Feature (Login VIPER)

Este documento mostra como trabalharemos com Git nas próximas features.

## 📊 Estrutura Atual de Branches

```
main (produção)
  └── develop (desenvolvimento) ← Você está aqui!
```

## 🎯 Próxima Feature: Login Module (VIPER)

### Passo 1: Criar Branch da Feature

```bash
# Garantir que está em develop e atualizado
git checkout develop
git pull origin develop

# Criar branch da feature
git checkout -b feature/login-viper-module

# Verificar branch atual
git branch
# * feature/login-viper-module
#   develop
#   main
```

### Passo 2: Desenvolver a Feature

Vamos criar o módulo Login com arquitetura VIPER em múltiplos commits organizados:

#### Commit 1: Estrutura do Módulo
```bash
# Criar arquivos VIPER
# - LoginViewController.swift
# - LoginView.swift
# - LoginInteractor.swift
# - LoginPresenter.swift
# - LoginRouter.swift
# - LoginProtocols.swift

git add MeuExame/Scenes/Login/
git commit -m "feat(login): adiciona estrutura VIPER do módulo Login

- Cria LoginViewController, View, Interactor, Presenter, Router
- Define protocolos VIPER
- Prepara arquitetura para implementação"
```

#### Commit 2: UI Components
```bash
# Implementar UI programaticamente
git add MeuExame/Scenes/Login/LoginView.swift
git commit -m "feat(login): implementa UI programática da tela de login

- Adiciona campos de email e senha
- Adiciona botão de login
- Implementa constraints com Auto Layout
- Adiciona logo e elementos visuais"
```

#### Commit 3: Business Logic
```bash
# Implementar Interactor e Presenter
git add MeuExame/Scenes/Login/LoginInteractor.swift
git add MeuExame/Scenes/Login/LoginPresenter.swift
git commit -m "feat(login): implementa lógica de negócio e apresentação

- Interactor com validação de credenciais
- Integração com FirebaseAuthenticationService
- Presenter com formatação de dados
- Tratamento de erros e loading states"
```

#### Commit 4: Navigation
```bash
# Implementar Router
git add MeuExame/Scenes/Login/LoginRouter.swift
git commit -m "feat(login): implementa navegação e routing

- Router para navegação entre telas
- Configuração de transições
- Setup de próxima tela após login"
```

#### Commit 5: Integration
```bash
# Atualizar DependencyContainer
git add MeuExame/Common/Helpers/DependencyContainer.swift
git commit -m "feat(login): integra módulo Login no DependencyContainer

- Factory method para criar módulo Login
- Injeção de dependências configurada
- Wiring completo dos componentes VIPER"
```

### Passo 3: Push e Pull Request

```bash
# Fazer push da feature
git push -u origin feature/login-viper-module

# Output esperado:
# remote: Create a pull request for 'feature/login-viper-module' on GitHub by visiting:
# remote:   https://github.com/tbdbatista/meu-exame/pull/new/feature/login-viper-module
```

### Passo 4: Criar Pull Request no GitHub

1. Acessar o link fornecido ou ir para: https://github.com/tbdbatista/meu-exame
2. Clicar em "Compare & pull request"
3. **Base:** `develop` ← **Compare:** `feature/login-viper-module`
4. Preencher template:

```markdown
## 📋 Descrição

Implementação completa do módulo de Login usando arquitetura VIPER.

## 🎯 Tipo de Mudança

- [x] 🎨 Nova feature

## 🔗 Issue Relacionada

Closes #3 (exemplo)

## 🚀 Mudanças Realizadas

- Estrutura VIPER completa (View, Interactor, Presenter, Entity, Router)
- UI programática com Auto Layout
- Validação de email e senha
- Integração com Firebase Auth
- Tratamento de erros
- Loading states
- Navegação após login bem-sucedido

## 📸 Screenshots

[Adicionar screenshots da tela de login]

## ✅ Checklist

- [x] O código segue o padrão de estilo do projeto
- [x] Realizei self-review do meu código
- [x] Comentei partes complexas do código
- [x] Atualizei a documentação relevante
- [x] Testes unitários adicionados

## 🧪 Como Testar

1. Abrir o projeto no Xcode
2. Buildar e executar
3. Testar login com credenciais válidas
4. Testar validações de email/senha
5. Verificar navegação após login
```

### Passo 5: Review e Merge

Após aprovação do PR:

```bash
# Voltar para develop
git checkout develop

# Atualizar develop
git pull origin develop

# A branch feature/login-viper-module já estará mergeada
# Deletar branch local
git branch -d feature/login-viper-module
```

## 📈 Visualização do Fluxo

```
Before:
main ──────────────────────────────
develop ───────────────────────────

During Development:
main ──────────────────────────────
develop ───────────────────────────
         \
          feature/login-viper ─────

After Merge:
main ──────────────────────────────
develop ─────────┬─────────────────
         (merged feature/login-viper)
```

## 🎨 Boas Práticas Aplicadas

### ✅ Commits Atômicos
- Cada commit tem uma responsabilidade clara
- Mensagens descritivas com escopo
- Fácil de revisar e fazer rollback se necessário

### ✅ Branch de Vida Curta
- Feature desenvolvida em poucos dias
- Merge rápido para evitar conflitos
- Delete após merge

### ✅ Pull Request Descritivo
- Template preenchido completamente
- Screenshots para mudanças visuais
- Checklist de validação

### ✅ Code Review
- Pelo menos 1 aprovação antes do merge
- Discussões em comentários do PR
- Melhorias sugeridas e aplicadas

## 🔄 Próximas Features Seguirão o Mesmo Padrão

```bash
# Feature de Registro
git checkout -b feature/register-viper-module

# Feature de Home
git checkout -b feature/home-screen

# Feature de Profile
git checkout -b feature/profile-screen

# Bug fix
git checkout -b fix/login-validation-error

# Hotfix crítico
git checkout main
git checkout -b hotfix/critical-crash-on-launch
```

## 📚 Comandos de Referência Rápida

```bash
# Ver status e branch atual
git status
git branch

# Criar nova feature
git checkout develop
git pull origin develop
git checkout -b feature/nome-da-feature

# Commitar mudanças
git add .
git commit -m "feat(escopo): descrição"

# Push e criar PR
git push -u origin feature/nome-da-feature

# Atualizar branch com develop
git checkout feature/nome-da-feature
git merge develop

# Ver histórico
git log --oneline --graph --all

# Deletar branch após merge
git branch -d feature/nome-da-feature
git push origin --delete feature/nome-da-feature
```

## 💡 Dicas

1. **Commite frequentemente**: Commits pequenos são mais fáceis de revisar
2. **Mensagens descritivas**: Use conventional commits
3. **Pull antes de push**: Sempre atualize antes de enviar
4. **Teste localmente**: Garanta que está funcionando antes do PR
5. **Documente mudanças**: Atualize README se necessário

---

**Próxima feature:** Login Module (VIPER) 🚀
**Branch a ser criada:** `feature/login-viper-module`
**Base:** `develop`

