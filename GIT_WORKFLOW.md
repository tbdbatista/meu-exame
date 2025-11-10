# Git Workflow - MeuExame

Este documento descreve o fluxo de trabalho Git usado no projeto MeuExame.

## 📋 Estrutura de Branches

### Branches Principais

- **`main`** - Branch de produção
  - Sempre estável e pronta para deploy
  - Apenas código testado e revisado
  - Protegida contra commits diretos

- **`develop`** - Branch de desenvolvimento
  - Base para novas features
  - Integração contínua de features completas
  - Sempre sincronizada com `main` após releases

### Branches Temporárias

- **`feature/*`** - Novas funcionalidades
  - Exemplo: `feature/login-viper`, `feature/firebase-integration`
  - Criadas a partir de `develop`
  - Mergeadas de volta para `develop`

- **`fix/*`** - Correções de bugs
  - Exemplo: `fix/login-validation`, `fix/firebase-timeout`
  - Criadas a partir de `develop`
  - Mergeadas de volta para `develop`

- **`hotfix/*`** - Correções urgentes em produção
  - Exemplo: `hotfix/critical-crash`
  - Criadas a partir de `main`
  - Mergeadas para `main` E `develop`

## 🔄 Workflow de Desenvolvimento

### 1. Iniciar Nova Feature

```bash
# Atualizar develop
git checkout develop
git pull origin develop

# Criar branch da feature
git checkout -b feature/nome-da-feature

# Trabalhar na feature...
git add .
git commit -m "feat: descrição da mudança"
```

### 2. Finalizar Feature

```bash
# Atualizar com develop antes de mergear
git checkout develop
git pull origin develop

git checkout feature/nome-da-feature
git merge develop

# Se houver conflitos, resolva-os

# Fazer push da feature
git push origin feature/nome-da-feature
```

### 3. Merge para Develop

```bash
# Voltar para develop
git checkout develop

# Mergear feature (com --no-ff para manter histórico)
git merge --no-ff feature/nome-da-feature

# Push para o repositório
git push origin develop

# Deletar branch local
git branch -d feature/nome-da-feature

# Deletar branch remota
git push origin --delete feature/nome-da-feature
```

### 4. Release para Main

```bash
# Quando develop estiver estável
git checkout main
git pull origin main

git merge --no-ff develop
git tag -a v1.0.0 -m "Release v1.0.0"

git push origin main
git push origin --tags
```

## 📝 Convenção de Commits (Conventional Commits)

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/) para mensagens de commit:

### Tipos de Commit

- **`feat:`** - Nova funcionalidade
  ```bash
  git commit -m "feat: adiciona tela de login com VIPER"
  git commit -m "feat: implementa autenticação com Firebase"
  ```

- **`fix:`** - Correção de bug
  ```bash
  git commit -m "fix: corrige validação de email no login"
  git commit -m "fix: resolve crash ao fazer logout"
  ```

- **`docs:`** - Apenas documentação
  ```bash
  git commit -m "docs: atualiza README com instruções de setup"
  git commit -m "docs: adiciona comentários no FirebaseManager"
  ```

- **`style:`** - Formatação, espaços em branco
  ```bash
  git commit -m "style: formata código seguindo SwiftLint"
  git commit -m "style: ajusta indentação"
  ```

- **`refactor:`** - Refatoração sem mudança de funcionalidade
  ```bash
  git commit -m "refactor: extrai lógica de validação para Helper"
  git commit -m "refactor: simplifica LoginPresenter"
  ```

- **`test:`** - Adiciona ou modifica testes
  ```bash
  git commit -m "test: adiciona testes unitários para LoginInteractor"
  ```

- **`chore:`** - Tarefas de build, configs, etc
  ```bash
  git commit -m "chore: atualiza dependências do Firebase"
  git commit -m "chore: configura SwiftLint"
  ```

- **`perf:`** - Melhorias de performance
  ```bash
  git commit -m "perf: otimiza carregamento de imagens"
  ```

### Formato Completo

```
<tipo>(<escopo>): <descrição>

[corpo opcional]

[rodapé opcional]
```

**Exemplo:**
```bash
git commit -m "feat(login): implementa validação de email e senha

- Adiciona validação de formato de email
- Verifica tamanho mínimo de senha
- Exibe mensagens de erro apropriadas

Closes #123"
```

## 🏷️ Versionamento Semântico

Seguimos [Semantic Versioning](https://semver.org/):

**MAJOR.MINOR.PATCH** (ex: 1.4.2)

- **MAJOR** - Mudanças incompatíveis na API (1.0.0 → 2.0.0)
- **MINOR** - Nova funcionalidade compatível (1.0.0 → 1.1.0)
- **PATCH** - Correção de bugs compatível (1.0.0 → 1.0.1)

### Criando Tags

```bash
# Tag anotada (recomendado)
git tag -a v1.0.0 -m "Release v1.0.0 - Login e Firebase"

# Listar tags
git tag

# Push de tags
git push origin v1.0.0
# ou todas as tags
git push origin --tags
```

## 🔍 Comandos Úteis

### Visualizar Histórico

```bash
# Log resumido
git log --oneline --graph --all

# Log detalhado de uma branch
git log develop --oneline

# Ver diferenças entre branches
git diff develop..feature/nome-feature
```

### Limpar Branches

```bash
# Listar branches
git branch -a

# Deletar branch local
git branch -d feature/nome-feature

# Deletar branch remota
git push origin --delete feature/nome-feature

# Limpar referências remotas deletadas
git fetch --prune
```

### Desfazer Mudanças

```bash
# Desfazer commit (mantém alterações)
git reset --soft HEAD~1

# Desfazer commit (descarta alterações)
git reset --hard HEAD~1

# Desfazer arquivo específico
git checkout -- arquivo.swift

# Reverter commit (cria novo commit)
git revert <commit-hash>
```

## 🛡️ Proteção de Branches

### Configuração Recomendada no GitHub

Para `main` e `develop`:

1. **Settings → Branches → Add rule**
2. Configurações recomendadas:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Include administrators
   - ✅ Restrict who can push to matching branches

## 📊 Exemplo de Fluxo Completo

```bash
# 1. Criar branch develop (primeira vez)
git checkout -b develop
git push -u origin develop

# 2. Iniciar feature de Login
git checkout develop
git checkout -b feature/login-viper

# 3. Desenvolver a feature
git add MeuExame/Scenes/Login/
git commit -m "feat(login): adiciona estrutura VIPER do módulo Login"

git add MeuExame/Scenes/Login/LoginViewController.swift
git commit -m "feat(login): implementa LoginViewController com UI programática"

git add MeuExame/Scenes/Login/LoginPresenter.swift
git commit -m "feat(login): implementa LoginPresenter com validações"

# 4. Push da feature
git push -u origin feature/login-viper

# 5. Criar Pull Request no GitHub
# (via interface do GitHub)

# 6. Após aprovação, mergear para develop
git checkout develop
git pull origin develop
git merge --no-ff feature/login-viper
git push origin develop

# 7. Deletar branch da feature
git branch -d feature/login-viper
git push origin --delete feature/login-viper

# 8. Quando pronto para release
git checkout main
git merge --no-ff develop
git tag -a v1.0.0 -m "Release v1.0.0 - MVP com Login"
git push origin main --tags
```

## 🎯 Boas Práticas

### Commits

- ✅ Commits pequenos e focados
- ✅ Mensagens descritivas e claras
- ✅ Um commit por mudança lógica
- ✅ Testar antes de commitar
- ❌ Não commitar código comentado
- ❌ Não commitar arquivos de configuração pessoal

### Branches

- ✅ Nomes descritivos e em kebab-case
- ✅ Atualizar regularmente com develop
- ✅ Deletar após merge
- ✅ Manter branches de vida curta
- ❌ Não trabalhar diretamente em main ou develop

### Pull Requests

- ✅ Descrição clara do que foi feito
- ✅ Referenciar issues relacionadas
- ✅ Screenshots para mudanças visuais
- ✅ Checklist de validação
- ✅ Solicitar review de código

## 📚 Recursos

- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

---

**Última atualização:** 09/11/2025

