import Foundation
@testable import MeuExame

final class AuthServiceMock: AuthServiceProtocol {
    private(set) var signInCallCount = 0
    private(set) var capturedSignInEmail: String?
    private(set) var capturedSignInPassword: String?

    var signInResult: Result<String, Error>?

    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        signInCallCount += 1
        capturedSignInEmail = email
        capturedSignInPassword = password

        if let signInResult {
            completion(signInResult)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.failure(AuthError.unknown))
    }

    func signOut() throws {}

    var currentUserId: String? { nil }

    var isSignedIn: Bool { false }

    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(AuthError.unknown))
    }
}
