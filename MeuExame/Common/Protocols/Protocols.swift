import Foundation
import UIKit

// MARK: - VIPER Base Protocols

/// Protocol defining the View layer responsibilities in VIPER architecture.
/// The View is responsible for displaying data and capturing user interactions.
protocol ViewProtocol: AnyObject {
    /// Reference to the presenter to handle user actions
    var presenter: PresenterProtocol? { get set }
    
    /// Shows a loading indicator to the user
    func showLoading()
    
    /// Hides the loading indicator
    func hideLoading()
    
    /// Shows an error message to the user
    /// - Parameters:
    ///   - title: The error title
    ///   - message: The error description
    func showError(title: String, message: String)
    
    /// Shows a success message to the user
    /// - Parameters:
    ///   - title: The success title
    ///   - message: The success description
    func showSuccess(title: String, message: String)
}

/// Protocol defining the Presenter layer responsibilities in VIPER architecture.
/// The Presenter acts as a middleman between View and Interactor.
protocol PresenterProtocol: AnyObject {
    /// Reference to the view to update UI
    var view: ViewProtocol? { get set }
    
    /// Reference to the interactor to perform business logic
    var interactor: InteractorProtocol? { get set }
    
    /// Reference to the router to handle navigation
    var router: RouterProtocol? { get set }
    
    /// Called when the view has finished loading
    func viewDidLoad()
    
    /// Called when the view is about to appear
    func viewWillAppear()
    
    /// Called when the view has disappeared
    func viewDidDisappear()
}

/// Protocol defining the Interactor layer responsibilities in VIPER architecture.
/// The Interactor contains the business logic and data manipulation.
protocol InteractorProtocol: AnyObject {
    /// Reference to the presenter to communicate results
    var presenter: PresenterProtocol? { get set }
}

/// Protocol defining the Router layer responsibilities in VIPER architecture.
/// The Router handles navigation and module creation.
protocol RouterProtocol: AnyObject {
    /// Reference to the view controller for navigation purposes
    var viewController: UIViewController? { get set }
    
    /// Creates and returns the module's entry point
    /// - Returns: The configured view controller
    static func createModule() -> UIViewController
}

// MARK: - Extended Protocols for Common Use Cases

/// Protocol for presenters that handle list operations
protocol ListPresenterProtocol: PresenterProtocol {
    /// Called when the user wants to refresh the list
    func refreshData()
    
    /// Called when the user scrolls to the bottom (pagination)
    func loadMore()
}

/// Protocol for interactors that fetch data
protocol DataInteractorProtocol: InteractorProtocol {
    /// Fetches data from a data source (API, database, etc.)
    func fetchData()
}

/// Protocol for routers that handle detail navigation
protocol DetailRouterProtocol: RouterProtocol {
    /// Navigates to a detail screen
    /// - Parameter id: The identifier of the item to show details
    func navigateToDetail(with id: String)
}

// MARK: - Default Implementations (Extensions)

extension ViewProtocol where Self: UIViewController {
    /// Default implementation for showing loading using a standard activity indicator
    func showLoading() {
        // Remove existing loading view if any
        view.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
    }
    
    /// Default implementation for hiding loading
    func hideLoading() {
        view.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
    }
    
    /// Default implementation for showing error using UIAlertController
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    /// Default implementation for showing success using UIAlertController
    func showSuccess(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension PresenterProtocol {
    /// Default implementation for viewWillAppear (can be overridden if needed)
    func viewWillAppear() {
        // Override in concrete implementation if needed
    }
    
    /// Default implementation for viewDidDisappear (can be overridden if needed)
    func viewDidDisappear() {
        // Override in concrete implementation if needed
    }
}

