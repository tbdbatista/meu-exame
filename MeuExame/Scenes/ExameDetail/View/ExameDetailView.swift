import UIKit

/// ExameDetailView é a view customizada da tela de detalhes do exame.
/// Implementa 100% View Code com modo visualização e edição.
final class ExameDetailView: UIView {
    
    // MARK: - Properties
    
    private var isEditMode = false
    private var currentExame: ExameModel?
    private var attachedFileData: Data?
    private var attachedFileName: String?
    private var hasFileChanged = false
    
    // MARK: - Callbacks
    
    var onSaveTapped: ((String?, String?, String?, String?, Date, Data?, String?, Bool) -> Void)?
    var onCancelTapped: (() -> Void)?
    var onViewFileTapped: (() -> Void)?
    var onAttachFileTapped: (() -> Void)?
    var onRemoveFileTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Header Section
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Form Fields (Read/Write)
    
    let nomeTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        field.isEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let nomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome do Exame"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let localTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        field.isEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let localLabel: UILabel = {
        let label = UILabel()
        label.text = "Local Realizado"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let medicoTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)
        field.isEnabled = false
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let medicoLabel: UILabel = {
        let label = UILabel()
        label.text = "Médico Solicitante"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let motivoTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let motivoLabel: UILabel = {
        let label = UILabel()
        label.text = "Motivo/Queixa"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.isEnabled = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data do Exame"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - File Section
    
    private let fileSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "📎 Anexo"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // View mode: Shows file to view
    private let fileContainerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noFileLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum arquivo anexado"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Edit mode: Attach/Change file button and preview
    private let attachFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📎 Anexar Arquivo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let filePreviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let previewFileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let removeFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Action Buttons (Edit Mode)
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar Alterações", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancelar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        contentView.addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(headerTitleLabel)
        
        contentView.addSubview(nomeLabel)
        contentView.addSubview(nomeTextField)
        contentView.addSubview(localLabel)
        contentView.addSubview(localTextField)
        contentView.addSubview(medicoLabel)
        contentView.addSubview(medicoTextField)
        contentView.addSubview(motivoLabel)
        contentView.addSubview(motivoTextView)
        contentView.addSubview(dataLabel)
        contentView.addSubview(datePicker)
        
        contentView.addSubview(fileSectionLabel)
        contentView.addSubview(fileContainerButton)
        fileContainerButton.addSubview(fileNameLabel)
        fileContainerButton.addSubview(noFileLabel)
        
        // Edit mode file components
        contentView.addSubview(attachFileButton)
        contentView.addSubview(filePreviewContainer)
        filePreviewContainer.addSubview(previewFileNameLabel)
        filePreviewContainer.addSubview(removeFileButton)
        
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(saveButton)
        buttonStackView.addArrangedSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
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
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            iconImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            headerTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerTitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
            
            // Nome
            nomeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            nomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nomeTextField.topAnchor.constraint(equalTo: nomeLabel.bottomAnchor, constant: 8),
            nomeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nomeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Local
            localLabel.topAnchor.constraint(equalTo: nomeTextField.bottomAnchor, constant: 20),
            localLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            localLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            localTextField.topAnchor.constraint(equalTo: localLabel.bottomAnchor, constant: 8),
            localTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            localTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            localTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Médico
            medicoLabel.topAnchor.constraint(equalTo: localTextField.bottomAnchor, constant: 20),
            medicoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medicoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            medicoTextField.topAnchor.constraint(equalTo: medicoLabel.bottomAnchor, constant: 8),
            medicoTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medicoTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            medicoTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Motivo
            motivoLabel.topAnchor.constraint(equalTo: medicoTextField.bottomAnchor, constant: 20),
            motivoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motivoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            motivoTextView.topAnchor.constraint(equalTo: motivoLabel.bottomAnchor, constant: 8),
            motivoTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motivoTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            motivoTextView.heightAnchor.constraint(equalToConstant: 100),
            
            // Data
            dataLabel.topAnchor.constraint(equalTo: motivoTextView.bottomAnchor, constant: 20),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            datePicker.centerYAnchor.constraint(equalTo: dataLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // File Section
            fileSectionLabel.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 30),
            fileSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fileSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            fileContainerButton.topAnchor.constraint(equalTo: fileSectionLabel.bottomAnchor, constant: 12),
            fileContainerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            fileContainerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fileContainerButton.heightAnchor.constraint(equalToConstant: 60),
            
            fileNameLabel.leadingAnchor.constraint(equalTo: fileContainerButton.leadingAnchor, constant: 20),
            fileNameLabel.trailingAnchor.constraint(equalTo: fileContainerButton.trailingAnchor, constant: -20),
            fileNameLabel.centerYAnchor.constraint(equalTo: fileContainerButton.centerYAnchor),
            
            noFileLabel.centerXAnchor.constraint(equalTo: fileContainerButton.centerXAnchor),
            noFileLabel.centerYAnchor.constraint(equalTo: fileContainerButton.centerYAnchor),
            
            // Edit Mode: Attach File Button
            attachFileButton.topAnchor.constraint(equalTo: fileSectionLabel.bottomAnchor, constant: 12),
            attachFileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            attachFileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            attachFileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Edit Mode: File Preview Container
            filePreviewContainer.topAnchor.constraint(equalTo: attachFileButton.bottomAnchor, constant: 12),
            filePreviewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filePreviewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            filePreviewContainer.heightAnchor.constraint(equalToConstant: 50),
            
            previewFileNameLabel.leadingAnchor.constraint(equalTo: filePreviewContainer.leadingAnchor, constant: 12),
            previewFileNameLabel.centerYAnchor.constraint(equalTo: filePreviewContainer.centerYAnchor),
            previewFileNameLabel.trailingAnchor.constraint(equalTo: removeFileButton.leadingAnchor, constant: -8),
            
            removeFileButton.trailingAnchor.constraint(equalTo: filePreviewContainer.trailingAnchor, constant: -12),
            removeFileButton.centerYAnchor.constraint(equalTo: filePreviewContainer.centerYAnchor),
            removeFileButton.widthAnchor.constraint(equalToConstant: 24),
            removeFileButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Button Stack (Edit Mode)
            buttonStackView.topAnchor.constraint(equalTo: fileContainerButton.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        fileContainerButton.addTarget(self, action: #selector(fileButtonTapped), for: .touchUpInside)
        attachFileButton.addTarget(self, action: #selector(attachFileButtonTapped), for: .touchUpInside)
        removeFileButton.addTarget(self, action: #selector(removeFileButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        onSaveTapped?(
            nomeTextField.text,
            localTextField.text,
            medicoTextField.text,
            motivoTextView.text,
            datePicker.date,
            attachedFileData,
            attachedFileName,
            hasFileChanged
        )
    }
    
    @objc private func cancelButtonTapped() {
        onCancelTapped?()
    }
    
    @objc private func fileButtonTapped() {
        onViewFileTapped?()
    }
    
    @objc private func attachFileButtonTapped() {
        onAttachFileTapped?()
    }
    
    @objc private func removeFileButtonTapped() {
        attachedFileData = nil
        attachedFileName = nil
        hasFileChanged = true
        updateEditModeFileUI()
        onRemoveFileTapped?()
    }
    
    // MARK: - Public Methods
    
    func updateExamInfo(_ exame: ExameModel) {
        currentExame = exame
        
        headerTitleLabel.text = exame.nome
        nomeTextField.text = exame.nome
        localTextField.text = exame.localRealizado
        medicoTextField.text = exame.medicoSolicitante
        motivoTextView.text = exame.motivoQueixa
        datePicker.date = exame.dataCadastro
        
        updateFileAttachment(hasFile: exame.temArquivo, fileName: exame.nomeArquivoExibicao)
    }
    
    func showEditMode() {
        isEditMode = true
        
        nomeTextField.isEnabled = true
        localTextField.isEnabled = true
        medicoTextField.isEnabled = true
        motivoTextView.isEditable = true
        datePicker.isEnabled = true
        
        buttonStackView.isHidden = false
        
        nomeTextField.backgroundColor = .systemBackground
        localTextField.backgroundColor = .systemBackground
        medicoTextField.backgroundColor = .systemBackground
        motivoTextView.backgroundColor = .systemBackground
        
        // Show edit mode file UI
        fileContainerButton.isHidden = true
        attachFileButton.isHidden = false
        
        // Reset file change tracking and preserve current file
        hasFileChanged = false
        if let exame = currentExame, exame.temArquivo {
            // Keep reference to current file (will download if needed)
            attachedFileName = exame.nomeArquivoExibicao
        }
        
        updateEditModeFileUI()
    }
    
    func showViewMode() {
        isEditMode = false
        
        nomeTextField.isEnabled = false
        localTextField.isEnabled = false
        medicoTextField.isEnabled = false
        motivoTextView.isEditable = false
        datePicker.isEnabled = false
        
        buttonStackView.isHidden = true
        
        nomeTextField.backgroundColor = .systemGray6
        localTextField.backgroundColor = .systemGray6
        medicoTextField.backgroundColor = .systemGray6
        motivoTextView.backgroundColor = .systemGray6
        
        // Show view mode file UI
        fileContainerButton.isHidden = false
        attachFileButton.isHidden = true
        filePreviewContainer.isHidden = true
        
        // Reset file state
        attachedFileData = nil
        attachedFileName = nil
        hasFileChanged = false
        
        // Restore original data
        if let exame = currentExame {
            updateExamInfo(exame)
        }
    }
    
    func updateFileAttachment(hasFile: Bool, fileName: String?) {
        if hasFile {
            fileNameLabel.isHidden = false
            noFileLabel.isHidden = true
            fileContainerButton.isEnabled = true
            
            if let fileName = fileName, !fileName.isEmpty {
                fileNameLabel.text = fileName
            } else {
                fileNameLabel.text = "Arquivo.pdf"
            }
        } else {
            fileNameLabel.isHidden = true
            noFileLabel.isHidden = false
            fileContainerButton.isEnabled = false
        }
    }
    
    func setAttachedFile(data: Data, fileName: String) {
        attachedFileData = data
        attachedFileName = fileName
        hasFileChanged = true
        updateEditModeFileUI()
    }
    
    private func updateEditModeFileUI() {
        let hasFile = attachedFileData != nil || (currentExame?.temArquivo == true && !hasFileChanged)
        
        if hasFile, let name = attachedFileName {
            previewFileNameLabel.text = "📄 \(name)"
            filePreviewContainer.isHidden = false
            attachFileButton.setTitle("📎 Alterar Arquivo", for: .normal)
        } else {
            filePreviewContainer.isHidden = true
            attachFileButton.setTitle("📎 Anexar Arquivo", for: .normal)
        }
    }
}

