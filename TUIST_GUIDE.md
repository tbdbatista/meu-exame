# 📦 Guia do Tuist - MeuExame

Este guia explica como usar o Tuist no projeto MeuExame.

## 🎯 O Que é Tuist?

Tuist é um gerador de projetos Xcode que permite:
- ✅ Definir projeto como código (Swift)
- ✅ Zero conflitos de merge no `.xcodeproj`
- ✅ Gerar módulos VIPER automaticamente
- ✅ Gerenciar dependências SPM
- ✅ Cache de builds

## 📋 Instalação

O Tuist já está instalado via Homebrew:

```bash
tuist version
# 4.68.0
```

Se precisar instalar:
```bash
brew install tuist/tuist/tuist
```

## 🚀 Comandos Básicos

### Gerar Projeto

```bash
# Gera o .xcworkspace e .xcodeproj
tuist generate

# Abre automaticamente após gerar
tuist generate --open
```

**⚠️ Importante:** Execute `tuist generate` sempre que:
- Adicionar novos arquivos
- Modificar `Project.swift`
- Adicionar dependências
- Trocar de branch

### Limpar Cache

```bash
# Limpa cache do Tuist
tuist clean

# Limpa tudo (cache + derivados)
tuist clean --dependencies
```

### Instalar Dependências

```bash
# Resolve dependências SPM
tuist install

# Atualiza para versões mais recentes
tuist install --update
```

## 🎨 Scaffold VIPER (Feature Killer!)

### Criar Novo Módulo VIPER

```bash
# Sintaxe
tuist scaffold viper --name NomeDoModulo

# Exemplo: Criar módulo de Login
tuist scaffold viper --name Login
```

**Isso cria automaticamente:**
```
MeuExame/Scenes/Login/
├── LoginViewController.swift   # View Controller
├── LoginView.swift              # UI View (programática)
├── LoginInteractor.swift        # Business Logic
├── LoginPresenter.swift         # Presentation Logic
├── LoginEntity.swift            # Data Model
├── LoginRouter.swift            # Navigation
└── LoginProtocols.swift         # VIPER Protocols
```

**⏱️ Tempo economizado:** ~15 minutos por módulo!

### Listar Templates Disponíveis

```bash
tuist scaffold list
```

## 📁 Estrutura de Arquivos

```
meu-exame/
├── Tuist.swift                    # Configuração global do Tuist
├── Project.swift                  # Definição do projeto
├── Tuist/
│   └── Templates/
│       └── viper/                 # Template VIPER customizado
│           ├── viper.swift        # Definição do template
│           ├── ViewController.stencil
│           ├── View.stencil
│           ├── Interactor.stencil
│           ├── Presenter.stencil
│           ├── Entity.stencil
│           ├── Router.stencil
│           └── Protocols.stencil
│
├── MeuExame.xcworkspace           # ⚠️ Gerado (não commitar)
├── MeuExame.xcodeproj             # ⚠️ Gerado (não commitar)
└── .tuist/                        # ⚠️ Cache (não commitar)
```

## 🔧 Modificando o Projeto

### Adicionar Novo Arquivo

1. Crie o arquivo normalmente no Xcode ou terminal
2. Execute `tuist generate` para atualizar o projeto

**Não é necessário** adicionar manualmente ao Xcode!

### Adicionar Dependência SPM

Edite `Project.swift`:

```swift
packages: [
    .remote(
        url: "https://github.com/Alamofire/Alamofire",
        requirement: .upToNextMajor(from: "5.0.0")
    )
],
// ...
dependencies: [
    .package(product: "Alamofire", type: .runtime)
]
```

Execute:
```bash
tuist install
tuist generate
```

### Modificar Configurações do Target

Edite `Project.swift`:

```swift
settings: .settings(
    base: [
        "SWIFT_VERSION": "5.9",
        "NOVA_CONFIGURACAO": "valor"
    ]
)
```

Execute:
```bash
tuist generate
```

## 🎯 Workflow Diário

### 1. Início do Dia

```bash
cd /Users/tbdbatista/repositories/projetos-pucpr/meu-exame
git pull origin develop
tuist generate --open
```

### 2. Criar Nova Feature

```bash
# 1. Criar branch
git checkout -b feature/nome-da-feature

# 2. Criar módulo VIPER
tuist scaffold viper --name MinhaFeature

# 3. Gerar projeto
tuist generate

# 4. Abrir e desenvolver
open MeuExame.xcworkspace
```

### 3. Adicionar Arquivos

```bash
# Simplesmente crie o arquivo
touch MeuExame/Common/Helpers/NovoHelper.swift

# Regenere o projeto
tuist generate
```

### 4. Fim do Dia

```bash
# Não commitar arquivos gerados!
git add Project.swift Tuist/ MeuExame/
git commit -m "feat: adiciona módulo MinhaFeature"
git push origin feature/nome-da-feature
```

## 📝 Exemplo: Criar Módulo Home

```bash
# 1. Gerar módulo
tuist scaffold viper --name Home

# Output:
# ✔ Created MeuExame/Scenes/Home/HomeViewController.swift
# ✔ Created MeuExame/Scenes/Home/HomeView.swift
# ✔ Created MeuExame/Scenes/Home/HomeInteractor.swift
# ✔ Created MeuExame/Scenes/Home/HomePresenter.swift
# ✔ Created MeuExame/Scenes/Home/HomeEntity.swift
# ✔ Created MeuExame/Scenes/Home/HomeRouter.swift
# ✔ Created MeuExame/Scenes/Home/HomeProtocols.swift

# 2. Regenerar projeto
tuist generate

# 3. Abrir e desenvolver
open MeuExame.xcworkspace
```

## 🔍 Troubleshooting

### Erro: "Unable to find project"

```bash
# Certifique-se de estar no diretório correto
cd /Users/tbdbatista/repositories/projetos-pucpr/meu-exame

# Regenere o projeto
tuist generate
```

### Erro: "Package not found"

```bash
# Reinstale dependências
tuist clean --dependencies
tuist install
tuist generate
```

### Projeto não abre no Xcode

```bash
# Use o .xcworkspace, não o .xcodeproj
open MeuExame.xcworkspace
```

### Arquivos não aparecem no Xcode

```bash
# Regenere o projeto
tuist generate
```

### Conflitos após merge

```bash
# O .xcodeproj está no .gitignore, apenas regenere
git merge develop
tuist generate
```

## ⚡ Dicas e Boas Práticas

### ✅ DO (Faça)

- ✅ Execute `tuist generate` sempre que trocar de branch
- ✅ Execute `tuist generate` após pull/merge
- ✅ Use `tuist scaffold` para criar módulos VIPER
- ✅ Commit `Project.swift` e `Tuist/`
- ✅ Abra `.xcworkspace`, não `.xcodeproj`

### ❌ DON'T (Não Faça)

- ❌ Não commite `.xcodeproj` ou `.xcworkspace`
- ❌ Não adicione arquivos manualmente no Xcode
- ❌ Não modifique configurações diretamente no Xcode
- ❌ Não use `File → Add Files to "MeuExame"`
- ❌ Não abra `.xcodeproj` diretamente

## 🎨 Personalizando Templates

### Modificar Template VIPER

Edite os arquivos em `Tuist/Templates/viper/*.stencil`:

```bash
# Exemplo: Adicionar logging no Interactor
vim Tuist/Templates/viper/Interactor.stencil
```

Variáveis disponíveis:
- `{{ name }}` - Nome do módulo
- `{% now "short" %}` - Data atual

## 📊 Comparação: Antes vs Depois

### Antes (Manual)

```bash
# Criar 7 arquivos VIPER manualmente
touch LoginViewController.swift
touch LoginView.swift
touch LoginInteractor.swift
touch LoginPresenter.swift
touch LoginEntity.swift
touch LoginRouter.swift
touch LoginProtocols.swift

# Adicionar cada arquivo ao projeto
# (clique, clique, clique no Xcode)

# Escrever boilerplate code
# (copiar, colar, renomear...)

⏱️ Tempo: ~15-20 minutos
😫 Tedioso e propenso a erros
```

### Depois (Com Tuist)

```bash
tuist scaffold viper --name Login
tuist generate

⏱️ Tempo: ~30 segundos
😎 Automático e sem erros
```

## 🚀 Próximos Passos

### Criar Seu Primeiro Módulo

```bash
# 1. Scaffold Login
tuist scaffold viper --name Login

# 2. Gerar projeto
tuist generate

# 3. Abrir
open MeuExame.xcworkspace

# 4. Implementar a lógica
# (Todos os arquivos já estão prontos!)
```

### Integrar com DependencyContainer

Após criar módulo, atualize `DependencyContainer.swift`:

```swift
func makeLoginModule() -> UIViewController {
    return LoginRouter.createModule()
}
```

## 📚 Recursos

- **Documentação Oficial:** https://docs.tuist.io
- **Templates:** https://docs.tuist.io/guides/templates/
- **Best Practices:** https://docs.tuist.io/guides/best-practices/
- **Community:** https://community.tuist.dev

## ❓ FAQ

**Q: Preciso instalar algo além do Tuist?**  
A: Não, apenas Xcode e Tuist.

**Q: O que acontece se eu esquecer de rodar `tuist generate`?**  
A: Novos arquivos não aparecerão no Xcode.

**Q: Posso usar CocoaPods com Tuist?**  
A: Sim, mas SPM é recomendado. Já está configurado.

**Q: Como adiciono um teste unitário?**  
A: Crie o arquivo e rode `tuist generate`. O arquivo aparecerá automaticamente.

**Q: Tuist funciona com CI/CD?**  
A: Sim! Basta adicionar `tuist generate` no script de build.

**Q: Posso abrir o projeto sem Tuist?**  
A: Não, sempre use Tuist para gerar o projeto.

---

**Última atualização:** 09/11/2025  
**Versão do Tuist:** 4.68.0  
**Status:** ✅ Configurado e funcional

