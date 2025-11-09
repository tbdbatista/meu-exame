import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "VIPER Module Template for MeuExame",
    attributes: [
        nameAttribute
    ],
    items: [
        // MARK: - View Controller
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)ViewController.swift",
            templatePath: "ViewController.stencil"
        ),
        // MARK: - View
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)View.swift",
            templatePath: "View.stencil"
        ),
        // MARK: - Interactor
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)Interactor.swift",
            templatePath: "Interactor.stencil"
        ),
        // MARK: - Presenter
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)Presenter.swift",
            templatePath: "Presenter.stencil"
        ),
        // MARK: - Entity
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)Entity.swift",
            templatePath: "Entity.stencil"
        ),
        // MARK: - Router
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)Router.swift",
            templatePath: "Router.stencil"
        ),
        // MARK: - Protocols
        .file(
            path: "MeuExame/Scenes/\(nameAttribute)/\(nameAttribute)Protocols.swift",
            templatePath: "Protocols.stencil"
        )
    ]
)

