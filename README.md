# MeuExame

Aplicativo iOS para gerenciamento de exames médicos, desenvolvido com Swift e UIKit seguindo a arquitetura VIPER.

# Vídeos de demonstração
video 1 - https://youtu.be/jN7wIQcKJDY

video 2 - https://youtu.be/S9ot6mltZSk

## 📱 Sobre o Projeto

MeuExame é uma aplicação completa que permite aos usuários cadastrar, visualizar e gerenciar seus exames médicos de forma organizada e segura. O app oferece funcionalidades como agendamento de exames, notificações, anexo de arquivos e visualização de resultados.

## 📋 Informações do Projeto

- **Bundle ID**: com.meuexame.app
- **iOS Deployment Target**: iOS 15.0+
- **Linguagem**: Swift 5.0
- **UI Framework**: UIKit (View Code - 100% Programático)
- **Arquitetura**: VIPER
- **Gerenciador de Dependências**: Swift Package Manager (SPM)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Gerenciador de Projeto**: Tuist

## 🏗️ Estrutura do Projeto

```
MeuExame/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Scenes/                          # Módulos VIPER
│   ├── Login/                       # Autenticação
│   ├── Register/                    # Cadastro de usuário
│   ├── ForgotPassword/              # Recuperação de senha
│   ├── Home/                        # Tela inicial com resumo
│   ├── ExamesList/                  # Lista de exames
│   ├── ExameDetail/                 # Detalhes do exame
│   │   └── FileViewer/              # Visualizador de arquivos
│   ├── AddExam/                     # Cadastro de exame
│   ├── Profile/                     # Perfil do usuário
│   ├── ScheduledExamsList/          # Lista de exames agendados
│   └── Exames/
│       └── Entity/
│           └── ExameModel.swift     # Modelo de dados
├── Common/
│   ├── Adapters/                    # Adaptadores (Firestore)
│   ├── Entities/                    # Entidades compartilhadas
│   ├── Helpers/                     # Classes auxiliares
│   │   ├── DependencyContainer.swift
│   │   ├── ImageLoader.swift
│   │   └── MainTabBarController.swift
│   └── Protocols/                   # Protocolos base VIPER
├── Services/
│   ├── Firebase/                    # Serviços Firebase
│   │   ├── FirebaseManager.swift
│   │   └── AuthServiceProtocol.swift
│   └── Firestore/                   # Serviços Firestore
│       ├── FirestoreExamesService.swift
│       └── FirestoreUserService.swift
│   ├── LocalNotificationService.swift
│   ├── ExamesServiceProtocol.swift
│   ├── UserServiceProtocol.swift
│   ├── NotificationServiceProtocol.swift
│   └── StorageServiceProtocol.swift
└── Resources/
    ├── Assets.xcassets              # Assets do app
    └── LaunchScreen.storyboard
```

## ✨ Funcionalidades Implementadas

### 🔐 Autenticação
- ✅ Login com email e senha
- ✅ Cadastro de novos usuários
- ✅ Recuperação de senha
- ✅ Logout
- ✅ Persistência de sessão

### 🏠 Tela Inicial (Home)
- ✅ Resumo de exames (total, agendados, realizados, aguardando resultado)
- ✅ Cards informativos com estatísticas
- ✅ Navegação rápida para principais funcionalidades
- ✅ Visualização de foto de perfil

### 📋 Gerenciamento de Exames
- ✅ Lista completa de exames com filtros
- ✅ Filtros por status (agendados, realizados, aguardando resultado)
- ✅ Ordenação por nome ou data
- ✅ Busca por nome do exame
- ✅ Cadastro de novos exames
- ✅ Edição de exames existentes
- ✅ Exclusão de exames
- ✅ Visualização detalhada de exames
- ✅ Anexo de múltiplos arquivos (PDFs, imagens)
- ✅ Visualização de arquivos anexados (in-app)
- ✅ Compartilhamento de exames

### 📅 Agendamento
- ✅ Agendamento de exames futuros
- ✅ Notificações locais para exames agendados
- ✅ Lista dedicada de exames agendados
- ✅ Cancelamento de notificações

### 👤 Perfil do Usuário
- ✅ Visualização e edição de dados pessoais
- ✅ Upload e atualização de foto de perfil
- ✅ Alteração de senha
- ✅ Exclusão de conta

### 🎨 Interface
- ✅ 100% View Code (sem Storyboards)
- ✅ Suporte a Dark Mode
- ✅ Design moderno e responsivo
- ✅ Feedback visual em todas as ações
- ✅ Loading states
- ✅ Tratamento de erros com mensagens claras

## 🚀 Como Começar

### Pré-requisitos

- Xcode 15.0+
- iOS 15.0+
- Swift 5.0+
- Tuist instalado ([Instalação do Tuist](https://docs.tuist.io/installation))

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/tbdbatista/meu-exame.git
cd meu-exame
```

2. **Instale o Tuist (se ainda não tiver)**
```bash
curl -Ls https://install.tuist.io | bash
```

3. **Configure o Firebase**
   - Siga o guia detalhado em [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Adicione o arquivo `GoogleService-Info.plist` na pasta `MeuExame/`
   - Configure os serviços Firebase (Auth, Firestore, Storage)

4. **Gere o projeto com Tuist**
```bash
tuist generate
```

5. **Abra o workspace**
```bash
open MeuExame.xcworkspace
```

6. **Execute o projeto**
   - Selecione um simulador ou dispositivo
   - Pressione ⌘R para build e run

## 🏛️ Arquitetura - VIPER

O projeto segue a arquitetura VIPER (View, Interactor, Presenter, Entity, Router):

- **View**: Exibe a UI e repassa ações do usuário para o Presenter
- **Interactor**: Contém a lógica de negócio
- **Presenter**: Contém a lógica de apresentação e formatação de dados
- **Entity**: Modelos de dados
- **Router**: Gerencia navegação entre módulos

### Estrutura de um Módulo VIPER

```
SceneName/
├── View/
│   └── SceneNameView.swift          # UI programática
├── ViewController/
│   └── SceneNameViewController.swift # View Controller
├── Presenter/
│   └── SceneNamePresenter.swift     # Lógica de apresentação
├── Interactor/
│   └── SceneNameInteractor.swift    # Lógica de negócio
├── Router/
│   └── SceneNameRouter.swift        # Navegação
└── Protocols/
    └── SceneNameProtocols.swift     # Protocolos VIPER
```

## 🔧 Dependências

O projeto utiliza Swift Package Manager para gerenciamento de dependências:

- **Firebase iOS SDK** (11.0.0+)
  - FirebaseAuth - Autenticação de usuários
  - FirebaseFirestore - Banco de dados NoSQL
  - FirebaseStorage - Armazenamento de arquivos

## 🎯 Injeção de Dependências

O projeto utiliza `DependencyContainer` para gerenciar dependências:

```swift
let container = DependencyContainer.shared
let examesService = container.makeExamesService()
let userService = container.makeUserService()
let notificationService = container.makeNotificationService()
```

### Serviços Disponíveis

- `makeExamesService()` - Serviço de gerenciamento de exames
- `makeUserService()` - Serviço de gerenciamento de usuários
- `makeNotificationService()` - Serviço de notificações locais

## 🔥 Serviços Firebase

Todos os serviços Firebase são abstraídos através de protocolos:

- `FirebaseConfigurable` - Configuração do Firebase
- `AuthServiceProtocol` - Operações de autenticação
- `ExamesServiceProtocol` - Operações de exames
- `UserServiceProtocol` - Operações de usuário
- `StorageServiceProtocol` - Operações de armazenamento
- `NotificationServiceProtocol` - Operações de notificações

Isso permite:
- Testes fáceis com implementações mock
- Baixo acoplamento entre componentes
- Flexibilidade para trocar implementações

## 📱 Módulos Implementados

### Autenticação
- **Login**: Autenticação com email e senha
- **Register**: Cadastro de novos usuários
- **ForgotPassword**: Recuperação de senha via email

### Principal
- **Home**: Tela inicial com resumo e estatísticas
- **ExamesList**: Lista completa de exames com filtros e busca
- **ExameDetail**: Visualização e edição de exames
- **AddExam**: Cadastro de novos exames
- **ScheduledExamsList**: Lista de exames agendados
- **Profile**: Gerenciamento de perfil do usuário

### Utilitários
- **FileViewer**: Visualizador de arquivos (PDFs, imagens) dentro do app

## 🧪 Testabilidade

O projeto foi desenvolvido com testabilidade em mente usando injeção de dependências:

```swift
// Exemplo: Mock Firebase para testes
class MockFirebaseManager: FirebaseConfigurable {
    func configure() { }
    func isConfigured() -> Bool { return true }
}

// Injetar em testes
let container = DependencyContainer(firebaseManager: MockFirebaseManager())
```

## 📚 Documentação Adicional

- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Guia de configuração do Firebase
- [GIT_WORKFLOW.md](GIT_WORKFLOW.md) - Workflow Git do projeto
- [TUIST_GUIDE.md](TUIST_GUIDE.md) - Guia de uso do Tuist

## 🔄 Git Workflow

Este projeto segue um workflow Git estruturado com branches. Consulte [GIT_WORKFLOW.md](GIT_WORKFLOW.md) para detalhes completos.

### Branches Principais

- **`main`** - Código em produção (estável)
- **`develop`** - Base para desenvolvimento

### Trabalhando com Features

```bash
# 1. Criar branch da feature a partir de develop
git checkout develop
git pull origin develop
git checkout -b feature/minha-feature

# 2. Desenvolver e commitar
git add .
git commit -m "feat: descrição da mudança"

# 3. Push e criar Pull Request
git push origin feature/minha-feature
```

### Convenção de Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Documentação
- `style:` - Formatação
- `refactor:` - Refatoração
- `test:` - Testes
- `chore:` - Configurações

**Exemplo:** `git commit -m "feat(login): implementa validação de email"`

## 🤝 Contribuindo

1. Fork o repositório
2. Clone seu fork
3. Crie uma branch de feature a partir de `develop`
4. Faça suas mudanças seguindo as convenções
5. Commit com mensagens descritivas
6. Push para seu fork
7. Abra um Pull Request para `develop`

Consulte [GIT_WORKFLOW.md](GIT_WORKFLOW.md) para guia completo!

## 📄 Licença

Este projeto foi desenvolvido como parte de um trabalho acadêmico.

---

**Criado em:** Novembro 2025  
**Versão:** 1.0.0  
**Status:** ✅ Projeto Finalizado
