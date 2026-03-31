import XCTest
@testable import MeuExame

final class LoginViewControllerTests: XCTestCase {
    private var sut: LoginViewController!
    private var presenterSpy: LoginPresenterSpy!

    override func setUp() {
        super.setUp()
        presenterSpy = LoginPresenterSpy()
        sut = LoginViewController(presenter: presenterSpy)
    }

    override func tearDown() {
        sut = nil
        presenterSpy = nil
        super.tearDown()
    }

    func test_viewDidLoad_callsPresenterViewDidLoad() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(presenterSpy.viewDidLoadCallCount, 1)
    }

    func test_viewDidLoad_doesNotPreFillCredentials() {
        sut.loadViewIfNeeded()
        let loginView = extractLoginView()

        XCTAssertEqual(loginView.emailTextField.text, "")
        XCTAssertEqual(loginView.passwordTextField.text, "")
    }

    func test_viewWillAppear_callsPresenterViewWillAppear() {
        sut.loadViewIfNeeded()

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        XCTAssertEqual(presenterSpy.viewWillAppearCallCount, 1)
    }

    func test_viewDidDisappear_callsPresenterViewDidDisappear() {
        sut.loadViewIfNeeded()

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.beginAppearanceTransition(false, animated: false)
        sut.endAppearanceTransition()

        XCTAssertEqual(presenterSpy.viewDidDisappearCallCount, 1)
    }

    func test_loginButtonTap_callsPresenterWithCredentials() {
        sut.loadViewIfNeeded()
        let loginView = extractLoginView()
        loginView.emailTextField.text = "user@email.com"
        loginView.passwordTextField.text = "abcdef"

        loginView.loginButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presenterSpy.didTapLoginCallCount, 1)
        XCTAssertEqual(presenterSpy.capturedLoginEmail, "user@email.com")
        XCTAssertEqual(presenterSpy.capturedLoginPassword, "abcdef")
    }

    func test_registerButtonTap_callsPresenterDidTapRegister() {
        sut.loadViewIfNeeded()
        let loginView = extractLoginView()

        loginView.registerButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presenterSpy.didTapRegisterCallCount, 1)
    }

    func test_forgotPasswordButtonTap_callsPresenterDidTapForgotPassword() {
        sut.loadViewIfNeeded()
        let loginView = extractLoginView()

        loginView.forgotPasswordButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(presenterSpy.didTapForgotPasswordCallCount, 1)
    }

    func test_showLoadingAndHideLoading_updatesInteractionState() {
        sut.loadViewIfNeeded()
        let loginView = extractLoginView()

        sut.showLoading()
        XCTAssertFalse(loginView.isUserInteractionEnabled)
        XCTAssertEqual(loginView.loginButton.alpha, 0.6, accuracy: 0.001)
        XCTAssertEqual(loginView.registerButton.alpha, 0.6, accuracy: 0.001)

        sut.hideLoading()
        XCTAssertTrue(loginView.isUserInteractionEnabled)
        XCTAssertEqual(loginView.loginButton.alpha, 1.0)
        XCTAssertEqual(loginView.registerButton.alpha, 1.0)
    }

    private func extractLoginView() -> LoginView {
        guard let loginView = sut.view as? LoginView else {
            XCTFail("Expected LoginView as root view")
            return LoginView()
        }
        return loginView
    }
}
