import Foundation
@testable import MeuExame

final class LoginInteractorOutputSpy: LoginInteractorOutputProtocol {
    private(set) var loginDidSucceedCallCount = 0
    private(set) var loginDidFailCallCount = 0
    private(set) var lastUserId: String?
    private(set) var lastError: Error?

    func loginDidSucceed(userId: String) {
        loginDidSucceedCallCount += 1
        lastUserId = userId
    }

    func loginDidFail(error: Error) {
        loginDidFailCallCount += 1
        lastError = error
    }
}
