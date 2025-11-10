import UIKit

/// RegisterView é a view customizada da tela de cadastro.
/// Implementa 100% View Code com AutoLayout programático.
final class RegisterView: UIView {
    
    // MARK: - UI Components
    
    /// Logo do app
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "heart.text.square.fill")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Título principal
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Criar Conta"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Subtítulo
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preencha os dados para criar sua conta"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Campo de e-mail
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar padding interno
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    /// Campo de senha
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Senha (mínimo 6 caracteres)"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar padding interno
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    /// Campo de confirmação de senha
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirmar Senha"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurar padding interno
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    /// Indicador de força da senha
    private let passwordStrengthView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passwordStrengthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Botão de cadastrar
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Adicionar sombra
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        
        return button
    }()
    
    /// Loading indicator
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// Separador "ou"
    private let orSeparatorLabel: UILabel = {
        let label = UILabel()
        label.text = "ou"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Botão "Já tenho conta"
    let backToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let normalText = "Já tem uma conta? "
        let boldText = "Entrar"
        let attributedString = NSMutableAttributedString(string: normalText + boldText)
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: normalText.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: normalText.count, length: boldText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: normalText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: normalText.count, length: boldText.count))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Terms of Service label (opcional)
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ao criar uma conta, você concorda com nossos Termos de Serviço e Política de Privacidade"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupPasswordStrengthObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(passwordStrengthView)
        passwordStrengthView.addSubview(passwordStrengthLabel)
        addSubview(confirmPasswordTextField)
        addSubview(registerButton)
        addSubview(loadingIndicator)
        addSubview(orSeparatorLabel)
        addSubview(backToLoginButton)
        addSubview(termsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Título
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Subtítulo
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Campo de e-mail
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Campo de senha
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password strength indicator
            passwordStrengthView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordStrengthView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            passwordStrengthView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            passwordStrengthView.heightAnchor.constraint(equalToConstant: 20),
            
            passwordStrengthLabel.centerYAnchor.constraint(equalTo: passwordStrengthView.centerYAnchor),
            passwordStrengthLabel.leadingAnchor.constraint(equalTo: passwordStrengthView.leadingAnchor),
            
            // Campo de confirmação de senha
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordStrengthView.bottomAnchor, constant: 8),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Botão de cadastrar
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            registerButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Loading indicator (sobreposto ao botão)
            loadingIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            
            // Separador "ou"
            orSeparatorLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 24),
            orSeparatorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Botão "Já tenho conta"
            backToLoginButton.topAnchor.constraint(equalTo: orSeparatorLabel.bottomAnchor, constant: 16),
            backToLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Terms label
            termsLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            termsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            termsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
    }
    
    // MARK: - Password Strength Observer
    
    private func setupPasswordStrengthObserver() {
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
    }
    
    @objc private func passwordDidChange() {
        let password = passwordTextField.text ?? ""
        updatePasswordStrength(for: password)
    }
    
    private func updatePasswordStrength(for password: String) {
        if password.isEmpty {
            passwordStrengthLabel.text = ""
            return
        }
        
        let strength = calculatePasswordStrength(password)
        
        switch strength {
        case 0...2:
            passwordStrengthLabel.text = "Senha fraca"
            passwordStrengthLabel.textColor = .systemRed
        case 3...4:
            passwordStrengthLabel.text = "Senha média"
            passwordStrengthLabel.textColor = .systemOrange
        default:
            passwordStrengthLabel.text = "Senha forte"
            passwordStrengthLabel.textColor = .systemGreen
        }
    }
    
    private func calculatePasswordStrength(_ password: String) -> Int {
        var strength = 0
        
        if password.count >= 6 { strength += 1 }
        if password.count >= 8 { strength += 1 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .lowercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil { strength += 1 }
        if password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")) != nil { strength += 1 }
        
        return strength
    }
    
    // MARK: - Public Methods
    
    /// Mostra o loading indicator
    func showLoading() {
        loadingIndicator.startAnimating()
        registerButton.setTitle("", for: .normal)
        registerButton.isEnabled = false
        isUserInteractionEnabled = false
    }
    
    /// Esconde o loading indicator
    func hideLoading() {
        loadingIndicator.stopAnimating()
        registerButton.setTitle("Cadastrar", for: .normal)
        registerButton.isEnabled = true
        isUserInteractionEnabled = true
    }
    
    /// Retorna as credenciais inseridas
    func getCredentials() -> (email: String, password: String, confirmPassword: String) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        return (email, password, confirmPassword)
    }
    
    /// Valida os campos
    func validateFields() -> (isValid: Bool, errorMessage: String?) {
        let credentials = getCredentials()
        
        // Validar e-mail não vazio
        guard !credentials.email.isEmpty else {
            return (false, "Por favor, preencha o e-mail")
        }
        
        // Validar formato de e-mail
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: credentials.email) else {
            return (false, "Por favor, insira um e-mail válido")
        }
        
        // Validar senha não vazia
        guard !credentials.password.isEmpty else {
            return (false, "Por favor, preencha a senha")
        }
        
        // Validar tamanho mínimo da senha
        guard credentials.password.count >= 6 else {
            return (false, "A senha deve ter no mínimo 6 caracteres")
        }
        
        // Validar confirmação de senha não vazia
        guard !credentials.confirmPassword.isEmpty else {
            return (false, "Por favor, confirme a senha")
        }
        
        // Validar senhas iguais
        guard credentials.password == credentials.confirmPassword else {
            return (false, "As senhas não coincidem")
        }
        
        return (true, nil)
    }
    
    /// Limpa todos os campos
    func clearFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        passwordStrengthLabel.text = ""
    }
}

