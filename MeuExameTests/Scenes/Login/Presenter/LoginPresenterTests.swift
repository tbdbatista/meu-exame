import XCTest
@testable import MeuExame

final class LoginPresenterTests: XCTestCase {
    private var sut: LoginPresenter!
    private var viewSpy: LoginViewSpy!
    private var interactorSpy: LoginInteractorSpy!
    private var routerSpy: LoginRouterSpy!

    override func setUp() {
        super.setUp()
        viewSpy = LoginViewSpy()
        interactorSpy = LoginInteractorSpy()
        routerSpy = LoginRouterSpy()
        sut = LoginPresenter(
            view: viewSpy,
            interactor: interactorSpy,
            router: routerSpy
        )
    }

    override func tearDown() {
        sut = nil
        viewSpy = nil
        interactorSpy = nil
        routerSpy = nil
        super.tearDown()
    }

    func test_didTapLogin_whenEmailIsEmpty_showsErrorAndDoesNotCallInteractor() {
        sut.didTapLogin(email: "", password: "123456")

        XCTAssertEqual(viewSpy.lastErrorTitle, "Erro")
        XCTAssertEqual(viewSpy.lastErrorMessage, "Por favor, preencha o e-mail")
        XCTAssertEqual(interactorSpy.performLoginCallCount, 0)
    }

    func test_didTapLogin_whenPasswordIsEmpty_showsErrorAndDoesNotCallInteractor() {
        sut.didTapLogin(email: "user@email.com", password: "")

        XCTAssertEqual(viewSpy.lastErrorTitle, "Erro")
        XCTAssertEqual(viewSpy.lastErrorMessage, "Por favor, preencha a senha")
        XCTAssertEqual(interactorSpy.performLoginCallCount, 0)
    }

    func test_didTapLogin_whenEmailIsInvalid_showsErrorAndDoesNotCallInteractor() {
        sut.didTapLogin(email: "email-invalido", password: "123456")

        XCTAssertEqual(viewSpy.lastErrorTitle, "Erro")
        XCTAssertEqual(viewSpy.lastErrorMessage, "Por favor, insira um e-mail válido")
        XCTAssertEqual(interactorSpy.performLoginCallCount, 0)
    }

    func test_didTapLogin_whenPasswordIsTooShort_showsErrorAndDoesNotCallInteractor() {
        sut.didTapLogin(email: "user@email.com", password: "123")

        XCTAssertEqual(viewSpy.lastErrorTitle, "Erro")
        XCTAssertEqual(viewSpy.lastErrorMessage, "A senha deve ter no mínimo 6 caracteres")
        XCTAssertEqual(interactorSpy.performLoginCallCount, 0)
    }

    func test_didTapLogin_whenCredentialsAreValid_showsLoadingAndCallsInteractor() {
        sut.didTapLogin(email: "user@email.com", password: "123456")

        XCTAssertEqual(viewSpy.showLoadingCallCount, 1)
        XCTAssertEqual(interactorSpy.performLoginCallCount, 1)
        XCTAssertEqual(interactorSpy.capturedEmail, "user@email.com")
        XCTAssertEqual(interactorSpy.capturedPassword, "123456")
    }

    func test_didTapRegister_navigatesToRegister() {
        sut.didTapRegister()

        XCTAssertEqual(routerSpy.navigateToRegisterCallCount, 1)
    }

    func test_didTapForgotPassword_navigatesToForgotPassword() {
        sut.didTapForgotPassword()

        XCTAssertEqual(routerSpy.navigateToForgotPasswordCallCount, 1)
    }

    func test_loginDidSucceed_hidesLoadingClearsFieldsAndNavigatesToMain() {
        sut.loginDidSucceed(userId: "user-id")

        XCTAssertEqual(viewSpy.hideLoadingCallCount, 1)
        XCTAssertEqual(viewSpy.clearFieldsCallCount, 1)
        XCTAssertEqual(routerSpy.navigateToMainScreenCallCount, 1)
    }

    func test_loginDidFail_hidesLoadingAndShowsAuthErrorMessage() {
        sut.loginDidFail(error: AuthError.invalidPassword)

        XCTAssertEqual(viewSpy.hideLoadingCallCount, 1)
        XCTAssertEqual(viewSpy.lastErrorTitle, "Erro no Login")
        XCTAssertEqual(viewSpy.lastErrorMessage, AuthError.invalidPassword.localizedDescription)
    }
}
