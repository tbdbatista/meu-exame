@testable import MeuExame

final class PresenterSpy: PresenterProtocol {
    var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    private(set) var viewDidLoadCallCount = 0
    private(set) var viewWillAppearCallCount = 0
    private(set) var viewDidDisappearCallCount = 0

    func viewDidLoad() {
        viewDidLoadCallCount += 1
    }

    func viewWillAppear() {
        viewWillAppearCallCount += 1
    }

    func viewDidDisappear() {
        viewDidDisappearCallCount += 1
    }
}
