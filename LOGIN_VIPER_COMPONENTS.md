# 🏗️ Login VIPER Components - Arquitetura Completa

## 📋 Visão Geral

Implementação **completa** dos componentes VIPER para o módulo de Login, incluindo Presenter, Interactor, Router e integração com Firebase Authentication.

---

## 🎯 Arquitetura VIPER Implementada

```
┌──────────────────────────────────────────────────────────────┐
│                      VIPER Architecture                       │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────┐      ┌───────────┐      ┌──────────┐          │
│  │  View   │ ───▶ │ Presenter │ ───▶ │  Router  │          │
│  │Controller│ ◀─── │           │      │          │          │
│  └─────────┘      └───────────┘      └──────────┘          │
│       │                  │                                   │
│       │                  │                                   │
│       │                  ▼                                   │
│       │          ┌──────────────┐                           │
│       │          │  Interactor  │                           │
│       │          │              │                           │
│       │          └──────────────┘                           │
│       │                  │                                   │
│       │                  ▼                                   │
│       │          ┌──────────────┐                           │
│       └─────────▶│  AuthService │ (Firebase)               │
│                  └──────────────┘                           │
└──────────────────────────────────────────────────────────────┘
```

---

## 📁 Estrutura de Arquivos

```
MeuExame/Scenes/Login/
├── View/
│   └── LoginView.swift                    # UIView customizada (View Code)
├── ViewController/
│   └── LoginViewController.swift          # UIViewController (gerencia View)
├── Presenter/
│   └── LoginPresenter.swift              ✨ NOVO
├── Interactor/
│   └── LoginInteractor.swift             ✨ NOVO
├── Router/
│   └── LoginRouter.swift                  ✨ NOVO
└── Protocols/
    └── LoginProtocols.swift               ✨ NOVO

MeuExame/Services/Firebase/
└── AuthServiceProtocol.swift              ✨ NOVO
```

---

## 🔧 Componentes Criados

### 1️⃣ AuthServiceProtocol.swift

**Responsabilidade:** Define o contrato para serviços de autenticação.

**Métodos:**
\`\`\`swift
protocol AuthServiceProtocol {
    func signIn(email:password:completion:)
    func signUp(email:password:completion:)
    func signOut() throws
    func sendPasswordReset(email:completion:)
    var currentUserId: String? { get }
    var isSignedIn: Bool { get }
}
\`\`\`

**Benefits:**
- ✅ **Dependency Injection**: Permite mock para testes
- ✅ **Abstração**: Pode trocar Firebase por outro provider
- ✅ **Type-safe**: Erros detectados em compile-time

**Extension FirebaseManager:**
- Implementa `AuthServiceProtocol`
- Converte `AuthDataResult` para `String` (userId)
- Simplifica API para o Interactor

**AuthError Enum:**
\`\`\`swift
enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown
}
\`\`\`

### 2️⃣ LoginProtocols.swift

**Responsabilidade:** Define protocolos específicos do módulo Login.

**Protocolos Definidos:**

| Protocol | Herda de | Responsabilidade |
|----------|----------|------------------|
| `LoginViewProtocol` | `ViewProtocol` | Métodos específicos da View |
| `LoginPresenterProtocol` | `PresenterProtocol` | Ações do usuário (didTapLogin, etc) |
| `LoginInteractorProtocol` | `InteractorProtocol` | Business logic (performLogin) |
| `LoginInteractorOutputProtocol` | `AnyObject` | Callback do Interactor → Presenter |
| `LoginRouterProtocol` | `RouterProtocol` | Navegação (register, forgot, main) |

### 3️⃣ LoginPresenter.swift

**Responsabilidade:** Lógica de apresentação e orquestração.

**Fluxo de Login:**
\`\`\`
User taps "Entrar"
    ↓
ViewController.loginButtonTapped()
    ↓
Presenter.didTapLogin(email, password)
    ↓
┌─────────────────────┐
│ Validação no        │
│ Presenter:          │
│ - Email não vazio   │
│ - Senha não vazia   │
│ - Email válido      │
│ - Senha >= 6 chars  │
└─────────┬───────────┘
          │
    ┌─────┴─────┐
    │           │
Inválido     Válido
    │           │
    ▼           ▼
showError   Interactor.performLogin()
\`\`\`

**Métodos Principais:**
- `didTapLogin(email:password:)`: Valida e delega ao Interactor
- `didTapRegister()`: Navega para cadastro via Router
- `didTapForgotPassword()`: Navega para recuperação via Router
- `loginDidSucceed(userId:)`: Callback de sucesso do Interactor
- `loginDidFail(error:)`: Callback de erro do Interactor

**Validações Implementadas:**
1. ✅ E-mail não vazio
2. ✅ Senha não vazia
3. ✅ E-mail válido (regex)
4. ✅ Senha >= 6 caracteres

### 4️⃣ LoginInteractor.swift

**Responsabilidade:** Business logic e comunicação com serviços.

**Dependências:**
\`\`\`swift
private let authService: AuthServiceProtocol

init(authService: AuthServiceProtocol = FirebaseManager.shared)
\`\`\`

**Fluxo:**
\`\`\`
Presenter chama performLogin()
    ↓
Interactor chama authService.signIn()
    ↓
┌────────────────┐
│ Firebase Auth  │
└────────┬───────┘
         │
    ┌────┴────┐
    │         │
Success    Failure
    │         │
    ▼         ▼
loginDidSucceed()  loginDidFail()
    │         │
    └────┬────┘
         ▼
    Presenter
\`\`\`

**Características:**
- ✅ Dependency Injection via init
- ✅ Weak reference ao Presenter (evita retain cycle)
- ✅ Logging para debug
- ✅ Conversão de Result<String, Error>

### 5️⃣ LoginRouter.swift

**Responsabilidade:** Navegação e criação do módulo.

**Factory Method:**
\`\`\`swift
static func createModule() -> UIViewController {
    let view = LoginViewController()
    let presenter = LoginPresenter()
    let interactor = LoginInteractor()
    let router = LoginRouter()
    
    // Dependency Injection
    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.presenter = presenter
    router.viewController = view
    
    return view
}
\`\`\`

**Navegação Implementada:**
- `navigateToRegister()`: → Register screen (placeholder)
- `navigateToForgotPassword()`: → Forgot Password screen (placeholder)
- `navigateToMainScreen()`: → Exames List (placeholder com logout)

**Placeholder Temporário:**
- Mostra tela de "Exames" com botão de logout
- Logout funcional (chama FirebaseManager.signOut())
- Volta para Login após logout

### 6️⃣ LoginViewController (Atualizado)

**Mudanças:**
- ✅ `var presenter: LoginPresenterProtocol?` (específico)
- ✅ Remove validação duplicada (delegada ao Presenter)
- ✅ Implementa `LoginViewProtocol`
- ✅ Delega ações aos métodos do Presenter

**Antes vs Depois:**
\`\`\`swift
// ANTES (Mock):
@objc private func loginButtonTapped() {
    // validação local...
    loginView.showLoading()
    DispatchQueue.main.asyncAfter(...) {
        // mock
    }
}

// DEPOIS (VIPER):
@objc private func loginButtonTapped() {
    let credentials = loginView.getCredentials()
    presenter?.didTapLogin(email: credentials.email, password: credentials.password)
}
\`\`\`

---

## 🔄 Fluxo Completo de Login

### 1. Usuário Preenche Campos
```
[E-mail] teste@exemplo.com
[Senha]  123456
```

### 2. Usuário Toca "Entrar"
```
LoginViewController.loginButtonTapped()
↓
getCredentials() from LoginView
↓
presenter?.didTapLogin(email, password)
```

### 3. Presenter Valida
```
LoginPresenter.didTapLogin()
↓
✓ Email não vazio?
✓ Senha não vazia?
✓ Email válido (regex)?
✓ Senha >= 6 chars?
↓
view?.showLoading()
↓
interactor?.performLogin(email, password)
```

### 4. Interactor Executa Business Logic
```
LoginInteractor.performLogin()
↓
authService.signIn(email, password) { result in ... }
```

### 5. Firebase Responde
```
Firebase Authentication
↓
Success: AuthDataResult (user.uid)
  OR
Failure: Error (wrongPassword, userNotFound, etc)
```

### 6. Interactor Notifica Presenter
```
// Se sucesso:
presenter?.loginDidSucceed(userId: "abc123")

// Se erro:
presenter?.loginDidFail(error: AuthError.invalidPassword)
```

### 7. Presenter Atualiza View
```
// Se sucesso:
view?.hideLoading()
view?.clearFields()
router?.navigateToMainScreen()

// Se erro:
view?.hideLoading()
view?.showError(title, message)
```

### 8. Router Navega
```
LoginRouter.navigateToMainScreen()
↓
Cria placeholder "Exames List"
↓
navigationController.setViewControllers([mainVC], animated: true)
```

---

## 🧪 Como Testar

### 1. Build e Run
\`\`\`bash
cd /Users/tbdbatista/repositories/projetos-pucpr/meu-exame
tuist generate
open MeuExame.xcworkspace
# ⌘R para rodar
\`\`\`

### 2. Teste de Login Válido
**Pré-requisito:** Usuário criado no Firebase Console
- Email: `teste@exemplo.com`
- Senha: `123456`

**Passos:**
1. Preencher e-mail: `teste@exemplo.com`
2. Preencher senha: `123456`
3. Tocar "Entrar"
4. ✅ Loading aparece
5. ✅ Navega para "Exames" (placeholder)
6. ✅ Console mostra logs de sucesso

**Console Esperado:**
\`\`\`
🏗️ LoginRouter: Creating Login module
✅ LoginRouter: Module created and configured
📱 LoginPresenter: View did load
📱 LoginPresenter: Login button tapped
🔄 LoginInteractor: Performing login for email: teste@exemplo.com
✅ LoginInteractor: Login successful - User ID: sGUb1M0ytsSFpF4P6w8uik9EK8H3
✅ LoginPresenter: Login succeeded - User ID: sGUb1M0ytsSFpF4P6w8uik9EK8H3
🧭 LoginRouter: Navigating to Main Screen (Exames List)
\`\`\`

### 3. Teste de Validação

**Cenário 1: E-mail vazio**
1. Deixar e-mail vazio
2. Tocar "Entrar"
3. ❌ Alert: "Por favor, preencha o e-mail"

**Cenário 2: E-mail inválido**
1. Preencher: `teste`
2. Tocar "Entrar"
3. ❌ Alert: "Por favor, insira um e-mail válido"

**Cenário 3: Senha curta**
1. Preencher e-mail: `teste@exemplo.com`
2. Preencher senha: `123`
3. Tocar "Entrar"
4. ❌ Alert: "A senha deve ter no mínimo 6 caracteres"

### 4. Teste de Erro de Autenticação

**Cenário 1: Usuário não existe**
1. E-mail: `naoexiste@exemplo.com`
2. Senha: `123456`
3. ❌ Alert: "Usuário não encontrado. Verifique o e-mail ou crie uma conta."

**Cenário 2: Senha incorreta**
1. E-mail: `teste@exemplo.com`
2. Senha: `senhaerrada`
3. ❌ Alert: "Senha incorreta. Por favor, tente novamente."

### 5. Teste de Navegação

**Cadastro:**
1. Tocar "Criar conta"
2. ✅ Alert placeholder

**Esqueci senha:**
1. Tocar "Esqueci minha senha"
2. ✅ Alert placeholder

**Logout (após login):**
1. Fazer login
2. Na tela "Exames", tocar "Sair"
3. ✅ Volta para Login

---

## 📊 Dependency Injection

### Grafo de Dependências

\`\`\`
SceneDelegate
    ↓
LoginRouter.createModule()
    ↓
    ├─ LoginViewController ──┐
    ├─ LoginPresenter ───────┼─ view
    ├─ LoginInteractor ──────┼─ presenter
    └─ LoginRouter ──────────┼─ viewController
                             │
                      ┌──────┴──────┐
                      │             │
                  presenter ←─→ interactor
                      │             │
                      └──→ router ←─┘
\`\`\`

### Injeção Manual vs Router

**Antes (Manual):**
\`\`\`swift
let vc = LoginViewController()
// ❌ Sem Presenter, Interactor, Router
\`\`\`

**Agora (Router):**
\`\`\`swift
let loginModule = LoginRouter.createModule()
// ✅ Todos componentes conectados
\`\`\`

---

## 🎯 Benefícios da Implementação

### Separação de Responsabilidades
- ✅ **View**: Apenas UI
- ✅ **ViewController**: Lifecycle e delegação
- ✅ **Presenter**: Validação e lógica de apresentação
- ✅ **Interactor**: Business logic e serviços
- ✅ **Router**: Navegação

### Testabilidade
- ✅ **View**: Pode testar UI isoladamente
- ✅ **Presenter**: Pode mockar View, Interactor, Router
- ✅ **Interactor**: Pode mockar AuthService
- ✅ **Router**: Pode testar navegação

### Manutenibilidade
- ✅ Código organizado e desacoplado
- ✅ Fácil adicionar novos fluxos
- ✅ Fácil trocar implementações

### Type Safety
- ✅ Protocolos definem contratos
- ✅ Erros detectados em compile-time
- ✅ Autocompletion do Xcode

---

## 🚧 Limitações Temporárias

### Implementado
- ✅ Login com Firebase
- ✅ Validações
- ✅ Tratamento de erros
- ✅ Navegação para Main (placeholder)
- ✅ Logout funcional

### Pendente (Próximos PRs)
- ⏳ Tela de Cadastro (Register)
- ⏳ Tela de Recuperação de Senha
- ⏳ Tela principal real (Exames List)
- ⏳ Persistência de sessão
- ⏳ Testes unitários

---

## 📝 Próximos Passos

### PR #6: Register Module
\`\`\`
1. Criar RegisterViewController
2. Criar VIPER completo (Presenter, Interactor, Router)
3. Integrar com AuthServiceProtocol.signUp()
4. Navegar de Login → Register
\`\`\`

### PR #7: Forgot Password Module
\`\`\`
1. Criar ForgotPasswordViewController
2. Usar AuthServiceProtocol.sendPasswordReset()
3. Navegar de Login → ForgotPassword
\`\`\`

### PR #8: Exames List Module
\`\`\`
1. Criar ExamesListViewController
2. VIPER completo com FirestoreService
3. Listar exames do usuário
4. Navegar de Login → ExamesList (após login)
\`\`\`

### PR #9: Unit Tests
\`\`\`
1. Criar mocks para AuthService
2. Testar LoginPresenter
3. Testar LoginInteractor
4. Testar LoginRouter
\`\`\`

---

## 🔗 Referências

### Arquivos Criados
- [AuthServiceProtocol.swift](MeuExame/Services/Firebase/AuthServiceProtocol.swift)
- [LoginProtocols.swift](MeuExame/Scenes/Login/Protocols/LoginProtocols.swift)
- [LoginPresenter.swift](MeuExame/Scenes/Login/Presenter/LoginPresenter.swift)
- [LoginInteractor.swift](MeuExame/Scenes/Login/Interactor/LoginInteractor.swift)
- [LoginRouter.swift](MeuExame/Scenes/Login/Router/LoginRouter.swift)

### Arquivos Modificados
- [LoginViewController.swift](MeuExame/Scenes/Login/ViewController/LoginViewController.swift)
- [SceneDelegate.swift](MeuExame/SceneDelegate.swift)

### Documentação Relacionada
- [LOGIN_IMPLEMENTATION.md](LOGIN_IMPLEMENTATION.md) - View e ViewController
- [Protocols.swift](MeuExame/Common/Protocols/Protocols.swift) - Protocolos base VIPER
- [FirebaseManager.swift](MeuExame/Services/Firebase/FirebaseManager.swift) - Implementação Firebase

---

**Documentação criada em:** 09/11/2025  
**Versão:** 1.0  
**Status:** ✅ VIPER completo implementado e funcional

