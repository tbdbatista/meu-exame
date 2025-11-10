import UIKit

/// ExamesListView é a view customizada da tela de listagem de exames.
/// Implementa 100% View Code com UITableView e UISearchBar.
final class ExamesListView: UIView {
    
    // MARK: - Properties
    
    private var exames: [ExameModel] = []
    var onExamSelected: ((ExameModel) -> Void)?
    var onDeleteExam: ((ExameModel) -> Void)?
    
    // MARK: - UI Components
    
    /// Search bar para buscar exames
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar exames..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    /// Table view para listar exames
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .systemBackground
        table.separatorStyle = .singleLine
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ExameTableViewCell.self, forCellReuseIdentifier: ExameTableViewCell.identifier)
        return table
    }()
    
    /// Empty state view
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text.magnifyingglass")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Nenhum exame encontrado"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyStateSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cadastre seu primeiro exame\npara começar"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Refresh control for pull-to-refresh
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitleLabel)
        
        tableView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Empty State Image
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -60),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Empty State Label
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -40),
            
            // Empty State Subtitle
            emptyStateSubtitleLabel.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 8),
            emptyStateSubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 40),
            emptyStateSubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -40),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Public Methods
    
    func updateExames(_ exames: [ExameModel]) {
        self.exames = exames
        tableView.reloadData()
        
        if exames.isEmpty {
            showEmptyState("Nenhum exame cadastrado")
        } else {
            hideEmptyState()
        }
    }
    
    func showEmptyState(_ message: String) {
        emptyStateLabel.text = message
        emptyStateView.isHidden = false
        tableView.isHidden = true
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDataSource

extension ExamesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExameTableViewCell.identifier,
            for: indexPath
        ) as? ExameTableViewCell else {
            return UITableViewCell()
        }
        
        let exame = exames[indexPath.row]
        cell.configure(with: exame)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ExamesListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exame = exames[indexPath.row]
        onExamSelected?(exame)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let exame = self.exames[indexPath.row]
            self.onDeleteExam?(exame)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - ExameTableViewCell

class ExameTableViewCell: UITableViewCell {
    static let identifier = "ExameTableViewCell"
    
    // MARK: - UI Components
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc.text.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nomeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let localLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nomeLabel)
        contentView.addSubview(localLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Nome
            nomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nomeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            nomeLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Local
            localLabel.topAnchor.constraint(equalTo: nomeLabel.bottomAnchor, constant: 4),
            localLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            localLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            // Data
            dataLabel.topAnchor.constraint(equalTo: localLabel.bottomAnchor, constant: 4),
            dataLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            dataLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // Chevron
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with exame: ExameModel) {
        nomeLabel.text = exame.nome
        localLabel.text = exame.localRealizado
        dataLabel.text = exame.dataFormatada
        
        // Mudar ícone se tem arquivo anexado
        if exame.temArquivo {
            iconImageView.image = UIImage(systemName: "doc.text.fill.badge.plus")
            iconImageView.tintColor = .systemGreen
        } else {
            iconImageView.image = UIImage(systemName: "doc.text.fill")
            iconImageView.tintColor = .systemBlue
        }
    }
}

