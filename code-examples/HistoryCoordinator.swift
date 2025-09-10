import UIKit
import Core
import RxSwift

enum HistoryCoordinatorEvent: Equatable {
    case back
    case customerDetails(Customer)
    case moreFeedback(Feedback)
    case leaveFeedback
}

final class HistoryCoordinator: BaseCoordinator<Void> {
    // MARK: - Dependencies
    struct Dependencies {
        let navigationController: UINavigationController
        let tab: TabType
        let tabBarController: TabBarViewController
    }

    // MARK: - Properties
    private let dependencies: Dependencies
    private let coordinatorEvents: Publisher<HistoryCoordinatorEvent> = .init()

    // MARK: - Init
    init(dependencies: HistoryCoordinator.Dependencies) {
        self.dependencies = dependencies
        super.init()
    }

    // MARK: - Lifecycle
    override func start() -> Observable<Void> {
        let vc: HistoryViewController = buildObject(coordinatorEvents)
        dependencies.tabBarController.addViewController(vc, tabType: dependencies.tab)
        
        coordinatorEvents.asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] event in
                guard let self else { return }
                self.setupEvent(event)
            })
            .disposed(by: disposeBag)

        return .never()
    }
}

// MARK: - Private Methods
private extension HistoryCoordinator {
    func setupEvent(_ event: HistoryCoordinatorEvent) {
        switch event {
        case .moreFeedback(let feedback):
            goMoreFeedback(feedback)
        case .customerDetails(let customer):
            goToCustomerDetails(customer)
        case .leaveFeedback:
            goToLeaveFeedback()
        default:
            break
        }
    }

    func goToCustomerDetails(_ customer: Customer) {
        let nc = dependencies.navigationController
        let customerDetailsCoordinator: CustomerDetailsCoordinator = buildObject(nc, customer)
        coordinate(to: customerDetailsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func goMoreFeedback(_ feedback: Feedback) {
        let nc = dependencies.navigationController
        let customerDetailsCoordinator: FeedbackFullDetailsCoordinator = buildObject(nc, feedback)
        coordinate(to: customerDetailsCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }

    func goToLeaveFeedback() {
        let nc = dependencies.navigationController
        let searchCustomerCoordinator: SearchCustomerCoordinator = buildObject(nc)
        coordinate(to: searchCustomerCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
