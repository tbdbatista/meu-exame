import UIKit

/// HomeView é a view customizada da tela principal (Home).
/// Implementa 100% View Code com AutoLayout programático.
final class HomeView: UIView {
    
    // MARK: - Callbacks
    
    var onProfileTapped: (() -> Void)?
    var onAddExamTapped: (() -> Void)?
    var onAboutTapped: (() -> Void)?
    
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
        stack.alignment = .fill // Garante que todas as views tenham a mesma altura
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let totalExamsCard = StatCardView(
        title: "Total de Exames",
        value: "0",
        color: .systemBlue
    )
    
    private let scheduledExamsCard = StatCardView(
        title: "Agendados",
        value: "0",
        color: .systemGreen
    )
    
    private let pendingExamsCard = StatCardView(
        title: "Aguardando resultado",
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
    
    // MARK: - Scheduled Exams Section
    
    private let scheduledExamsLabel: UILabel = {
        let label = UILabel()
        label.text = "📅 Próximos Exames Agendados"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scheduledExamsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let noScheduledExamsLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum exame agendado"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
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
    
    // MARK: - Empty State View
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum Exame Cadastrado"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Comece cadastrando seu primeiro exame médico.\nToque no botão abaixo para começar!"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateCTAButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📋 Cadastrar Primeiro Exame", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        summaryStackView.addArrangedSubview(scheduledExamsCard)
        summaryStackView.addArrangedSubview(pendingExamsCard)
        
        // Add actions
        contentView.addSubview(actionsLabel)
        contentView.addSubview(addExamButton)
        contentView.addSubview(aboutButton)
        
        // Add scheduled exams section
        contentView.addSubview(scheduledExamsLabel)
        contentView.addSubview(scheduledExamsStackView)
        contentView.addSubview(noScheduledExamsLabel)
        
        // Add last exam info
        contentView.addSubview(lastExamLabel)
        contentView.addSubview(lastExamDateLabel)
        
        // Add empty state view
        contentView.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateIconImageView)
        emptyStateView.addSubview(emptyStateTitleLabel)
        emptyStateView.addSubview(emptyStateMessageLabel)
        emptyStateView.addSubview(emptyStateCTAButton)
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
            
            // Scheduled Exams Label
            scheduledExamsLabel.topAnchor.constraint(equalTo: aboutButton.bottomAnchor, constant: 32),
            scheduledExamsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scheduledExamsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Scheduled Exams Stack
            scheduledExamsStackView.topAnchor.constraint(equalTo: scheduledExamsLabel.bottomAnchor, constant: 12),
            scheduledExamsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scheduledExamsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // No Scheduled Exams Label
            noScheduledExamsLabel.topAnchor.constraint(equalTo: scheduledExamsLabel.bottomAnchor, constant: 12),
            noScheduledExamsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noScheduledExamsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noScheduledExamsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Last Exam Label
            lastExamLabel.topAnchor.constraint(equalTo: scheduledExamsStackView.bottomAnchor, constant: 32),
            lastExamLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Last Exam Date
            lastExamDateLabel.topAnchor.constraint(equalTo: lastExamLabel.bottomAnchor, constant: 4),
            lastExamDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lastExamDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: 40),
            emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyStateView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            
            // Empty State Icon
            emptyStateIconImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: 40),
            emptyStateIconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateIconImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateIconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Empty State Title
            emptyStateTitleLabel.topAnchor.constraint(equalTo: emptyStateIconImageView.bottomAnchor, constant: 20),
            emptyStateTitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyStateTitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            
            // Empty State Message
            emptyStateMessageLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: 12),
            emptyStateMessageLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            emptyStateMessageLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20),
            
            // Empty State CTA Button
            emptyStateCTAButton.topAnchor.constraint(equalTo: emptyStateMessageLabel.bottomAnchor, constant: 24),
            emptyStateCTAButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateCTAButton.widthAnchor.constraint(equalToConstant: 260),
            emptyStateCTAButton.heightAnchor.constraint(equalToConstant: 50),
            emptyStateCTAButton.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: -40),
        ])
    }
    
    private func setupGestures() {
        // Profile image tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        // Empty state CTA button action
        emptyStateCTAButton.addTarget(self, action: #selector(emptyStateCTATapped), for: .touchUpInside)
    }
    
    @objc private func profileImageTapped() {
        // Will be handled by ViewController
    }
    
    @objc private func emptyStateCTATapped() {
        onAddExamTapped?()
    }
    
    // MARK: - Public Methods
    
    /// Updates the exam summary display
    func updateSummary(_ summary: ExamSummary) {
        totalExamsCard.setValue("\(summary.totalExams)")
        scheduledExamsCard.setValue("\(summary.scheduledExamsCount)")
        pendingExamsCard.setValue("\(summary.pendingExamsCount)")
        lastExamDateLabel.text = summary.formattedLastExamDate
        
        // Show/hide empty state based on exam count
        let hasExams = summary.totalExams > 0
        emptyStateView.isHidden = hasExams
        
        // Hide action buttons and last exam section if no exams
        actionsLabel.isHidden = !hasExams
        addExamButton.isHidden = !hasExams
        aboutButton.isHidden = !hasExams
        lastExamLabel.isHidden = !hasExams
        lastExamDateLabel.isHidden = !hasExams
        
        print("📊 HomeView: Empty state \(hasExams ? "hidden" : "visible") - Total exams: \(summary.totalExams)")
    }
    
    /// Updates the user profile display
    func updateProfile(_ profile: UserProfile) {
        userNameLabel.text = "Olá, \(profile.displayName)!"
        userEmailLabel.text = profile.email
        
        // Load profile image if URL exists and is not empty
        if let photoURL = profile.photoURL, !photoURL.isEmpty {
            print("📸 HomeView: updateProfile - photoURL: \(photoURL)")
            loadProfileImage(from: photoURL)
        } else {
            print("⚠️ HomeView: updateProfile - No photoURL, resetting to placeholder")
            // Reset to default placeholder if no photo URL
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .systemGray3
        }
    }
    
    /// Updates the scheduled exams display
    func updateScheduledExams(_ exams: [ExameModel]) {
        // Clear existing views
        scheduledExamsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if exams.isEmpty {
            noScheduledExamsLabel.isHidden = false
            scheduledExamsStackView.isHidden = true
        } else {
            noScheduledExamsLabel.isHidden = true
            scheduledExamsStackView.isHidden = false
            
            // Add up to 3 scheduled exams
            for exam in exams.prefix(3) {
                let cardView = ScheduledExamCardView(exame: exam)
                scheduledExamsStackView.addArrangedSubview(cardView)
            }
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        print("📸 HomeView: Loading profile image from: \(urlString)")
        
        // Use placeholder icon while loading
        let placeholder = UIImage(systemName: "person.circle.fill")
        
        ImageLoader.loadImage(
            from: urlString,
            into: profileImageView,
            placeholder: placeholder
        ) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let image = image {
                    print("✅ HomeView: Profile image loaded successfully")
                    // Clear tint color and background when real image loads
                    self.profileImageView.tintColor = nil
                    self.profileImageView.backgroundColor = .clear
                    self.profileImageView.image = image
                } else {
                    print("⚠️ HomeView: Failed to load profile image, keeping placeholder")
                    // Keep placeholder if load fails
                    self.profileImageView.image = placeholder
                    self.profileImageView.tintColor = .systemGray3
                    self.profileImageView.backgroundColor = .systemGray5
                }
            }
        }
    }
}

// MARK: - ScheduledExamCardView

private class ScheduledExamCardView: UIView {
    init(exame: ExameModel) {
        super.init(frame: .zero)
        setupUI(exame: exame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(exame: ExameModel) {
        backgroundColor = .systemOrange.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemOrange.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "calendar.badge.clock")
        iconImageView.tintColor = .systemOrange
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = exame.nome
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        dateLabel.text = formatter.string(from: exame.dataCadastro)
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .secondaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let daysLabel = UILabel()
        if let dias = exame.diasAteExame {
            if dias == 0 {
                daysLabel.text = "Hoje"
                daysLabel.textColor = .systemRed
            } else if dias == 1 {
                daysLabel.text = "Amanhã"
                daysLabel.textColor = .systemOrange
            } else {
                daysLabel.text = "Em \(dias) dias"
                daysLabel.textColor = .systemOrange
            }
        } else {
            daysLabel.text = ""
        }
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(daysLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            
            daysLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            daysLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            daysLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
        ])
    }
}

// MARK: - StatCardView

/// Stat card component for displaying statistics
private class StatCardView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0 // Permite múltiplas linhas
        label.lineBreakMode = .byWordWrapping // Quebra por palavra
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = false // Mantém o tamanho da fonte
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
    
    init(title: String, value: String, color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        valueLabel.text = value
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            // Título no topo
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            // Valor no centro (abaixo do título)
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

