import UIKit

/// HomeView é a view customizada da tela principal (Home).
/// Implementa 100% View Code com AutoLayout programático.
final class HomeView: UIView {
    
    // MARK: - UI Components
    
    /// Scroll view para conteúdo
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
    
    // MARK: - Header (Profile Section)
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Imagem de perfil do usuário (tappable)
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray3
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Olá, Usuário!"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "usuario@exemplo.com"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Summary Cards
    
    private let summaryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let totalExamsCard = StatCardView(
        icon: "doc.text.fill",
        title: "Total de Exames",
        value: "0",
        color: .systemBlue
    )
    
    private let recentExamsCard = StatCardView(
        icon: "clock.fill",
        title: "Recentes",
        value: "0",
        color: .systemGreen
    )
    
    private let pendingExamsCard = StatCardView(
        icon: "exclamationmark.circle.fill",
        title: "Pendentes",
        value: "0",
        color: .systemOrange
    )
    
    // MARK: - Action Buttons
    
    private let actionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ações Rápidas"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addExamButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Cadastrar Novo Exame"
        config.image = UIImage(systemName: "plus.circle.fill")
        config.imagePadding = 8
        config.cornerStyle = .medium
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let aboutButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Sobre o Aplicativo"
        config.image = UIImage(systemName: "info.circle.fill")
        config.imagePadding = 8
        config.cornerStyle = .medium
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Last Exam Info
    
    private let lastExamLabel: UILabel = {
        let label = UILabel()
        label.text = "Último Exame"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastExamDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum exame cadastrado"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // Add scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add header
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(userNameLabel)
        headerView.addSubview(userEmailLabel)
        
        // Add summary cards
        contentView.addSubview(summaryStackView)
        summaryStackView.addArrangedSubview(totalExamsCard)
        summaryStackView.addArrangedSubview(recentExamsCard)
        summaryStackView.addArrangedSubview(pendingExamsCard)
        
        // Add actions
        contentView.addSubview(actionsLabel)
        contentView.addSubview(addExamButton)
        contentView.addSubview(aboutButton)
        
        // Add last exam info
        contentView.addSubview(lastExamLabel)
        contentView.addSubview(lastExamDateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header View
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            // Profile Image
            profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // User Name
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // User Email
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userEmailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            userEmailLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // Summary Stack
            summaryStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            summaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            summaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            summaryStackView.heightAnchor.constraint(equalToConstant: 100),
            
            // Actions Label
            actionsLabel.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: 32),
            actionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Add Exam Button
            addExamButton.topAnchor.constraint(equalTo: actionsLabel.bottomAnchor, constant: 16),
            addExamButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addExamButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // About Button
            aboutButton.topAnchor.constraint(equalTo: addExamButton.bottomAnchor, constant: 12),
            aboutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Last Exam Label
            lastExamLabel.topAnchor.constraint(equalTo: aboutButton.bottomAnchor, constant: 32),
            lastExamLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Last Exam Date
            lastExamDateLabel.topAnchor.constraint(equalTo: lastExamLabel.bottomAnchor, constant: 4),
            lastExamDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastExamDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }
    
    private func setupGestures() {
        // Profile image tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func profileImageTapped() {
        // Will be handled by ViewController
    }
    
    // MARK: - Public Methods
    
    /// Updates the exam summary display
    func updateSummary(_ summary: ExamSummary) {
        totalExamsCard.setValue("\(summary.totalExams)")
        recentExamsCard.setValue("\(summary.recentExamsCount)")
        pendingExamsCard.setValue("\(summary.pendingExamsCount)")
        lastExamDateLabel.text = summary.formattedLastExamDate
    }
    
    /// Updates the user profile display
    func updateProfile(_ profile: UserProfile) {
        userNameLabel.text = "Olá, \(profile.displayName)!"
        userEmailLabel.text = profile.email
        
        // Load profile image if URL exists
        if let photoURL = profile.photoURL {
            loadProfileImage(from: photoURL)
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        // TODO: Implement image loading from URL
        // For now, keep the default icon
        print("📸 Loading profile image from: \(urlString)")
    }
}

// MARK: - StatCardView

/// Stat card component for displaying statistics
private class StatCardView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(icon: String, title: String, value: String, color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = UIImage(systemName: icon)
        titleLabel.text = title
        valueLabel.text = value
        
        addSubview(iconImageView)
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

