import UIKit

/// AddExamView é a view customizada da tela de cadastro de exames.
/// Implementa 100% View Code com formulário completo.
final class AddExamView: UIView {
    
    // MARK: - Callbacks
    
    var onSaveTapped: ((String?, String?, String?, String?, Date, Data?, String?) -> Void)?
    var onCancelTapped: (() -> Void)?
    var onAttachFileTapped: (() -> Void)?
    var onRemoveFileTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var attachedFileData: Data?
    private var attachedFileName: String?
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .interactive
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cadastrar Exame"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Preencha as informações do exame"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Form Fields
    
    let nomeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Nome do exame"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let nomeErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let localTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Local realizado"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let localErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let medicoTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Médico solicitante"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.returnKeyType = .next
        field.clearButtonMode = .whileEditing
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let medicoErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.isHidden = true
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
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let motivoPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Motivo/Queixa"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let motivoErrorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.text = "Data do Exame"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
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
    
    // MARK: - File Attachment
    
    private let attachmentSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Anexo (Opcional)"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attachFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📎 Anexar Arquivo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let filePreviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGreen.cgColor
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fileNameLabel: UILabel = {
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
    
    // MARK: - Action Buttons
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar Exame", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
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
        setupActions()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(nomeTextField)
        contentView.addSubview(nomeErrorLabel)
        contentView.addSubview(localTextField)
        contentView.addSubview(localErrorLabel)
        contentView.addSubview(medicoTextField)
        contentView.addSubview(medicoErrorLabel)
        contentView.addSubview(motivoTextView)
        contentView.addSubview(motivoPlaceholderLabel)
        contentView.addSubview(motivoErrorLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(datePicker)
        contentView.addSubview(attachmentSectionLabel)
        contentView.addSubview(attachFileButton)
        contentView.addSubview(filePreviewContainer)
        contentView.addSubview(saveButton)
        
        filePreviewContainer.addSubview(fileNameLabel)
        filePreviewContainer.addSubview(removeFileButton)
        
        motivoTextView.delegate = self
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
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Nome
            nomeTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            nomeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nomeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nomeErrorLabel.topAnchor.constraint(equalTo: nomeTextField.bottomAnchor, constant: 4),
            nomeErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nomeErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Local
            localTextField.topAnchor.constraint(equalTo: nomeErrorLabel.bottomAnchor, constant: 16),
            localTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            localTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            localTextField.heightAnchor.constraint(equalToConstant: 44),
            
            localErrorLabel.topAnchor.constraint(equalTo: localTextField.bottomAnchor, constant: 4),
            localErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            localErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Médico
            medicoTextField.topAnchor.constraint(equalTo: localErrorLabel.bottomAnchor, constant: 16),
            medicoTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medicoTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            medicoTextField.heightAnchor.constraint(equalToConstant: 44),
            
            medicoErrorLabel.topAnchor.constraint(equalTo: medicoTextField.bottomAnchor, constant: 4),
            medicoErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medicoErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Motivo
            motivoTextView.topAnchor.constraint(equalTo: medicoErrorLabel.bottomAnchor, constant: 16),
            motivoTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motivoTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            motivoTextView.heightAnchor.constraint(equalToConstant: 100),
            
            motivoPlaceholderLabel.topAnchor.constraint(equalTo: motivoTextView.topAnchor, constant: 12),
            motivoPlaceholderLabel.leadingAnchor.constraint(equalTo: motivoTextView.leadingAnchor, constant: 8),
            
            motivoErrorLabel.topAnchor.constraint(equalTo: motivoTextView.bottomAnchor, constant: 4),
            motivoErrorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motivoErrorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Data
            dataLabel.topAnchor.constraint(equalTo: motivoErrorLabel.bottomAnchor, constant: 20),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            datePicker.centerYAnchor.constraint(equalTo: dataLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Attachment Section
            attachmentSectionLabel.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 30),
            attachmentSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            attachmentSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            attachFileButton.topAnchor.constraint(equalTo: attachmentSectionLabel.bottomAnchor, constant: 12),
            attachFileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            attachFileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            attachFileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // File Preview
            filePreviewContainer.topAnchor.constraint(equalTo: attachFileButton.bottomAnchor, constant: 12),
            filePreviewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            filePreviewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            filePreviewContainer.heightAnchor.constraint(equalToConstant: 50),
            
            fileNameLabel.leadingAnchor.constraint(equalTo: filePreviewContainer.leadingAnchor, constant: 12),
            fileNameLabel.centerYAnchor.constraint(equalTo: filePreviewContainer.centerYAnchor),
            fileNameLabel.trailingAnchor.constraint(equalTo: removeFileButton.leadingAnchor, constant: -8),
            
            removeFileButton.trailingAnchor.constraint(equalTo: filePreviewContainer.trailingAnchor, constant: -12),
            removeFileButton.centerYAnchor.constraint(equalTo: filePreviewContainer.centerYAnchor),
            removeFileButton.widthAnchor.constraint(equalToConstant: 24),
            removeFileButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Save Button
            saveButton.topAnchor.constraint(equalTo: filePreviewContainer.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        attachFileButton.addTarget(self, action: #selector(attachFileButtonTapped), for: .touchUpInside)
        removeFileButton.addTarget(self, action: #selector(removeFileButtonTapped), for: .touchUpInside)
        
        nomeTextField.delegate = self
        localTextField.delegate = self
        medicoTextField.delegate = self
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
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
            attachedFileName
        )
    }
    
    @objc private func attachFileButtonTapped() {
        onAttachFileTapped?()
    }
    
    @objc private func removeFileButtonTapped() {
        attachedFileData = nil
        attachedFileName = nil
        updateFileAttachment(fileName: nil, hasFile: false)
        onRemoveFileTapped?()
    }
    
    // MARK: - Keyboard Handling
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Public Methods
    
    func clearForm() {
        nomeTextField.text = ""
        localTextField.text = ""
        medicoTextField.text = ""
        motivoTextView.text = ""
        datePicker.date = Date()
        attachedFileData = nil
        attachedFileName = nil
        updateFileAttachment(fileName: nil, hasFile: false)
        hideAllErrors()
    }
    
    func showFieldError(field: String, message: String) {
        switch field {
        case "nome":
            nomeErrorLabel.text = message
            nomeErrorLabel.isHidden = false
        case "local":
            localErrorLabel.text = message
            localErrorLabel.isHidden = false
        case "medico":
            medicoErrorLabel.text = message
            medicoErrorLabel.isHidden = false
        case "motivo":
            motivoErrorLabel.text = message
            motivoErrorLabel.isHidden = false
        default:
            break
        }
    }
    
    func hideFieldError(field: String) {
        switch field {
        case "nome":
            nomeErrorLabel.isHidden = true
        case "local":
            localErrorLabel.isHidden = true
        case "medico":
            medicoErrorLabel.isHidden = true
        case "motivo":
            motivoErrorLabel.isHidden = true
        default:
            break
        }
    }
    
    func updateFileAttachment(fileName: String?, hasFile: Bool) {
        if hasFile, let name = fileName {
            fileNameLabel.text = "📄 \(name)"
            filePreviewContainer.isHidden = false
            attachFileButton.setTitle("📎 Alterar Arquivo", for: .normal)
        } else {
            filePreviewContainer.isHidden = true
            attachFileButton.setTitle("📎 Anexar Arquivo", for: .normal)
        }
    }
    
    func setAttachedFile(data: Data, fileName: String) {
        attachedFileData = data
        attachedFileName = fileName
        updateFileAttachment(fileName: fileName, hasFile: true)
    }
    
    private func hideAllErrors() {
        nomeErrorLabel.isHidden = true
        localErrorLabel.isHidden = true
        medicoErrorLabel.isHidden = true
        motivoErrorLabel.isHidden = true
    }
}

// MARK: - UITextFieldDelegate

extension AddExamView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nomeTextField:
            localTextField.becomeFirstResponder()
        case localTextField:
            medicoTextField.becomeFirstResponder()
        case medicoTextField:
            motivoTextView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - UITextViewDelegate

extension AddExamView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        motivoPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}

