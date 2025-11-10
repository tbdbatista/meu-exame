import UIKit

/// LoginView é responsável pelo layout da tela de login usando View Code.
/// Contém campos de e-mail e senha, botões de login e cadastro.
final class LoginView: UIView {
    
    // MARK: - UI Components
    
    /// Logo ou título do app
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        imageView.image = UIImage(systemName: "heart.text.square.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Label de título
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Meu Exame"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Label de subtítulo
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gerencie seus exames médicos"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Container para os campos de input
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// Campo de e-mail
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.leftView = createIconView(systemName: "envelope.fill")
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Campo de senha
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Senha"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.leftView = createIconView(systemName: "lock.fill")
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    /// Botão de esqueci a senha
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Esqueci minha senha", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .trailing
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Botão de login
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Entrar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Separator com "ou"
    private lazy var separatorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var leftSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "ou"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Botão de cadastro
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar conta", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Activity indicator para loading
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubviews()
        setupConstraints()
        setupKeyboardDismiss()
    }
    
    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(inputStackView)
        addSubview(forgotPasswordButton)
        addSubview(loginButton)
        addSubview(separatorStackView)
        addSubview(registerButton)
        addSubview(loadingIndicator)
        
        // Adicionar campos ao stack
        inputStackView.addArrangedSubview(emailTextField)
        inputStackView.addArrangedSubview(passwordTextField)
        
        // Adicionar separator
        separatorStackView.addArrangedSubview(leftSeparatorLine)
        separatorStackView.addArrangedSubview(separatorLabel)
        separatorStackView.addArrangedSubview(rightSeparatorLine)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Input Stack View
            inputStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            inputStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            inputStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Text Fields Height
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Forgot Password Button
            forgotPasswordButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 8),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Separator Stack View
            separatorStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
            separatorStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            separatorStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            // Separator Lines
            leftSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            leftSeparatorLine.widthAnchor.constraint(equalTo: separatorStackView.widthAnchor, multiplier: 0.4),
            rightSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            rightSeparatorLine.widthAnchor.constraint(equalTo: separatorStackView.widthAnchor, multiplier: 0.4),
            
            // Register Button
            registerButton.topAnchor.constraint(equalTo: separatorStackView.bottomAnchor, constant: 32),
            registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            registerButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Loading Indicator
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helper Methods
    
    /// Cria um ícone para o leftView do TextField
    private func createIconView(systemName: String) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.image = UIImage(systemName: systemName)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        return containerView
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    // MARK: - Public Methods
    
    /// Exibe o loading indicator
    func showLoading() {
        loadingIndicator.startAnimating()
        isUserInteractionEnabled = false
        loginButton.alpha = 0.6
        registerButton.alpha = 0.6
    }
    
    /// Esconde o loading indicator
    func hideLoading() {
        loadingIndicator.stopAnimating()
        isUserInteractionEnabled = true
        loginButton.alpha = 1.0
        registerButton.alpha = 1.0
    }
    
    /// Retorna os valores dos campos
    func getCredentials() -> (email: String, password: String) {
        return (
            email: emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? "",
            password: passwordTextField.text ?? ""
        )
    }
    
    /// Limpa os campos
    func clearFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    /// Valida os campos
    func validateFields() -> (isValid: Bool, errorMessage: String?) {
        let credentials = getCredentials()
        
        guard !credentials.email.isEmpty else {
            return (false, "Por favor, preencha o e-mail")
        }
        
        guard credentials.email.contains("@") && credentials.email.contains(".") else {
            return (false, "Por favor, insira um e-mail válido")
        }
        
        guard !credentials.password.isEmpty else {
            return (false, "Por favor, preencha a senha")
        }
        
        guard credentials.password.count >= 6 else {
            return (false, "A senha deve ter no mínimo 6 caracteres")
        }
        
        return (true, nil)
    }
}

