@testable import MeuExame

final class LoginInteractorSpy: LoginInteractorProtocol {
    var presenter: PresenterProtocol?
    private(set) var performLoginCallCount = 0
    private(set) var capturedEmail: String?
    private(set) var capturedPassword: String?

    func performLogin(email: String, password: String) {
        performLoginCallCount += 1
        capturedEmail = email
        capturedPassword = password
    }
}
