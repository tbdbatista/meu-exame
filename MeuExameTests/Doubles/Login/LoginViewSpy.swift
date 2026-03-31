@testable import MeuExame

final class LoginViewSpy: LoginViewProtocol {
    var presenter: PresenterProtocol?
    private(set) var showLoadingCallCount = 0
    private(set) var hideLoadingCallCount = 0
    private(set) var clearFieldsCallCount = 0
    private(set) var showSuccessCallCount = 0
    private(set) var lastErrorTitle: String?
    private(set) var lastErrorMessage: String?
    private(set) var lastSuccessTitle: String?
    private(set) var lastSuccessMessage: String?

    func showLoading() {
        showLoadingCallCount += 1
    }

    func hideLoading() {
        hideLoadingCallCount += 1
    }

    func showError(title: String, message: String) {
        lastErrorTitle = title
        lastErrorMessage = message
    }

    func showSuccess(title: String, message: String) {
        showSuccessCallCount += 1
        lastSuccessTitle = title
        lastSuccessMessage = message
    }

    func getCredentials() -> (email: String, password: String) {
        ("", "")
    }

    func validateFields() -> (isValid: Bool, errorMessage: String?) {
        (true, nil)
    }

    func clearFields() {
        clearFieldsCallCount += 1
    }
}
