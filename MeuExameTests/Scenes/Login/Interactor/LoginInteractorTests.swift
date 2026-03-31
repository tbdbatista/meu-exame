import XCTest
@testable import MeuExame

final class LoginInteractorTests: XCTestCase {
    private var sut: LoginInteractor!
    private var authServiceMock: AuthServiceMock!
    private var outputSpy: LoginInteractorOutputSpy!
    private var presenterSpy: PresenterSpy!

    override func setUp() {
        super.setUp()
        authServiceMock = AuthServiceMock()
        outputSpy = LoginInteractorOutputSpy()
        presenterSpy = PresenterSpy()
        sut = LoginInteractor(
            authService: authServiceMock,
            presenter: presenterSpy,
            output: outputSpy
        )
    }

    override func tearDown() {
        sut = nil
        authServiceMock = nil
        outputSpy = nil
        presenterSpy = nil
        super.tearDown()
    }

    func test_init_withDependencies_setsPresenterAndOutput() {
        XCTAssertTrue(sut.presenter === presenterSpy)
        XCTAssertTrue(sut.output === outputSpy)
    }

    func test_performLogin_callsAuthServiceWithReceivedCredentials() {
        sut.performLogin(email: "user@email.com", password: "123456")

        XCTAssertEqual(authServiceMock.signInCallCount, 1)
        XCTAssertEqual(authServiceMock.capturedSignInEmail, "user@email.com")
        XCTAssertEqual(authServiceMock.capturedSignInPassword, "123456")
    }

    func test_performLogin_whenAuthSucceeds_notifiesOutputSuccess() {
        authServiceMock.signInResult = .success("user-123")

        sut.performLogin(email: "user@email.com", password: "123456")

        XCTAssertEqual(outputSpy.loginDidSucceedCallCount, 1)
        XCTAssertEqual(outputSpy.lastUserId, "user-123")
        XCTAssertEqual(outputSpy.loginDidFailCallCount, 0)
    }

    func test_performLogin_whenAuthFails_notifiesOutputFailure() {
        let expectedError = NSError(domain: "test", code: 99)
        authServiceMock.signInResult = .failure(expectedError)

        sut.performLogin(email: "user@email.com", password: "123456")

        XCTAssertEqual(outputSpy.loginDidFailCallCount, 1)
        XCTAssertEqual((outputSpy.lastError as NSError?)?.code, expectedError.code)
        XCTAssertEqual((outputSpy.lastError as NSError?)?.domain, expectedError.domain)
        XCTAssertEqual(outputSpy.loginDidSucceedCallCount, 0)
    }
}
