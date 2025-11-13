import UIKit

/// ProfileView é a view customizada da tela de perfil.
/// Implementa 100% View Code com formulário de edição de perfil.
final class ProfileView: UIView {
    
    // MARK: - Callbacks
    
    var onEditPhotoTapped: (() -> Void)?
    var onSaveTapped: ((String?, String?, Date?) -> Void)?
    var onChangePasswordTapped: (() -> Void)?
    var onLogoutTapped: (() -> Void)?
    var onDeleteAccountTapped: (() -> Void)?
    
    // MARK: - Properties
    
    private var currentUser: UserModel?
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Header with photo
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = 60
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Form fields
    private let formSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Informações Pessoais"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nomeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Nome completo"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let nomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let telefoneTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "(00) 00000-0000"
        field.borderStyle = .roundedRect
        field.keyboardType = .phonePad
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let telefoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Telefone"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.maximumDate = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data de Nascimento"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Actions section
    private let actionsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ações"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changePasswordButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Trocar Senha"
        config.image = UIImage(systemName: "lock.rotation")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logoutButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "Sair"
        config.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Danger zone
    private let dangerZoneSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Zona de Perigo"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteAccountButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Excluir Conta"
        config.image = UIImage(systemName: "trash")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .systemRed
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "⚠️ Esta ação é irreversível e excluirá todos os seus dados permanentemente."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(initialsLabel)
        contentView.addSubview(editPhotoButton)
        contentView.addSubview(emailLabel)
        
        contentView.addSubview(formSectionLabel)
        contentView.addSubview(nomeLabel)
        contentView.addSubview(nomeTextField)
        contentView.addSubview(telefoneLabel)
        contentView.addSubview(telefoneTextField)
        contentView.addSubview(dataLabel)
        contentView.addSubview(datePicker)
        
        contentView.addSubview(actionsSectionLabel)
        contentView.addSubview(changePasswordButton)
        contentView.addSubview(logoutButton)
        
        contentView.addSubview(dangerZoneSectionLabel)
        contentView.addSubview(deleteAccountButton)
        contentView.addSubview(deleteWarningLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            initialsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            // Edit Photo Button
            editPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4),
            editPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            editPhotoButton.widthAnchor.constraint(equalToConstant: 36),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 36),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Form Section
            formSectionLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            formSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nomeLabel.topAnchor.constraint(equalTo: formSectionLabel.bottomAnchor, constant: 16),
            nomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nomeTextField.topAnchor.constraint(equalTo: nomeLabel.bottomAnchor, constant: 6),
            nomeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nomeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            telefoneLabel.topAnchor.constraint(equalTo: nomeTextField.bottomAnchor, constant: 16),
            telefoneLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            telefoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            telefoneTextField.topAnchor.constraint(equalTo: telefoneLabel.bottomAnchor, constant: 6),
            telefoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            telefoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            telefoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            dataLabel.topAnchor.constraint(equalTo: telefoneTextField.bottomAnchor, constant: 16),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            datePicker.centerYAnchor.constraint(equalTo: dataLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Actions Section
            actionsSectionLabel.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 30),
            actionsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionsSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            changePasswordButton.topAnchor.constraint(equalTo: actionsSectionLabel.bottomAnchor, constant: 12),
            changePasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            changePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            logoutButton.topAnchor.constraint(equalTo: changePasswordButton.bottomAnchor, constant: 12),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Danger Zone
            dangerZoneSectionLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 40),
            dangerZoneSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dangerZoneSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            deleteAccountButton.topAnchor.constraint(equalTo: dangerZoneSectionLabel.bottomAnchor, constant: 12),
            deleteAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            deleteWarningLabel.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 8),
            deleteWarningLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteWarningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteWarningLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
    
    private func setupActions() {
        editPhotoButton.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        nomeTextField.delegate = self
        telefoneTextField.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func editPhotoButtonTapped() {
        onEditPhotoTapped?()
    }
    
    @objc private func changePasswordButtonTapped() {
        onChangePasswordTapped?()
    }
    
    @objc private func logoutButtonTapped() {
        onLogoutTapped?()
    }
    
    @objc private func deleteAccountButtonTapped() {
        onDeleteAccountTapped?()
    }
    
    // MARK: - Public Methods
    
    func updateUserInfo(_ user: UserModel) {
        currentUser = user
        
        emailLabel.text = user.email
        nomeTextField.text = user.nome
        telefoneTextField.text = user.telefone
        
        if let dataNascimento = user.dataNascimento {
            datePicker.date = dataNascimento
        }
        
        // Update photo or initials
        if let photoURL = user.photoURL, !photoURL.isEmpty {
            // TODO: Load image from URL (use SDWebImage or similar)
            // For now, show initials
            initialsLabel.text = user.initials
        } else {
            initialsLabel.text = user.initials
        }
    }
    
    func updateProfilePhoto(image: UIImage) {
        profileImageView.image = image
        initialsLabel.isHidden = true
    }
    
    func getUserInputData() -> (nome: String?, telefone: String?, dataNascimento: Date?) {
        return (nomeTextField.text, telefoneTextField.text, datePicker.date)
    }
}

// MARK: - UITextFieldDelegate

extension ProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nomeTextField {
            telefoneTextField.becomeFirstResponder()
        } else if textField == telefoneTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

