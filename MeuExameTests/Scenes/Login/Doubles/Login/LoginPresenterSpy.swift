@testable import MeuExame

final class LoginPresenterSpy: LoginPresenterProtocol {
    var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?

    private(set) var viewDidLoadCallCount = 0
    private(set) var viewWillAppearCallCount = 0
    private(set) var viewDidDisappearCallCount = 0
    private(set) var didTapLoginCallCount = 0
    private(set) var didTapRegisterCallCount = 0
    private(set) var didTapForgotPasswordCallCount = 0
    private(set) var capturedLoginEmail: String?
    private(set) var capturedLoginPassword: String?

    func viewDidLoad() {
        viewDidLoadCallCount += 1
    }

    func viewWillAppear() {
        viewWillAppearCallCount += 1
    }

    func viewDidDisappear() {
        viewDidDisappearCallCount += 1
    }

    func didTapLogin(email: String, password: String) {
        didTapLoginCallCount += 1
        capturedLoginEmail = email
        capturedLoginPassword = password
    }

    func didTapRegister() {
        didTapRegisterCallCount += 1
    }

    func didTapForgotPassword() {
        didTapForgotPasswordCallCount += 1
    }
}
