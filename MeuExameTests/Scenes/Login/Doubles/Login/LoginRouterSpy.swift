import UIKit
@testable import MeuExame

final class LoginRouterSpy: LoginRouterProtocol {
    var viewController: UIViewController?
    private(set) var navigateToRegisterCallCount = 0
    private(set) var navigateToForgotPasswordCallCount = 0
    private(set) var navigateToMainScreenCallCount = 0

    static func createModule() -> UIViewController {
        UIViewController()
    }

    func navigateToRegister() {
        navigateToRegisterCallCount += 1
    }

    func navigateToForgotPassword() {
        navigateToForgotPasswordCallCount += 1
    }

    func navigateToMainScreen() {
        navigateToMainScreenCallCount += 1
    }
}
