import RxSwift
import Core
import Foundation
import RxRelay

protocol HistoryViewModelProtocol {
    var input: HistoryViewModel.Input { get }
    var output: HistoryViewModel.Output { get }
}

final class HistoryViewModel: BaseViewModel, HistoryViewModelProtocol {
    // MARK: - Properties
    private let coordinatorEvents: Publisher<HistoryCoordinatorEvent>
    private let historyServices: HistoryServiceProtocol
    private var isMore: Bool = true
    private var loadedFeedbacks: Int = 0
    private var ascending: Bool = false

    let input: Input = .init()
    let output: Output = .init()

    // MARK: - Init
    init(coordinatorEvent: Publisher<HistoryCoordinatorEvent>,
         historyServices: HistoryServiceProtocol) {
        self.coordinatorEvents = coordinatorEvent
        self.historyServices = historyServices
        super.init()
        observeInput()
        observeOutput()
        loadMoreFeedbacks()
    }
}

private extension HistoryViewModel {
    func observeInput() {
        disposeBag.insert([
            setupMoreButtonObserving(input.moreButtonTapped.asObservable()),
            setupCustomerTapObserving(input.customerTapped.asObservable()),
            input.loadMore.asObservable().subscribe(onNext: { [weak self] _ in
                self?.loadMoreFeedbacks()
            }),
            input.selectChangeSortingType.asObservable()
                .map { self.ascending }
                .bind(to: output.showSortingType),
            setupChangeSortingTypeObserver(input.sortingTypeChoosen.asObservable()),
            setupLeaveFeedbackProcessing(input.leaveFirstReview.asObservable())
        ])
    }

    func observeOutput() {
        disposeBag.insert([
            setupFeedbackUpdaterObserving(historyServices.localUpdateService.feedbackEvent.asObservable())
        ])
    }

    func setupFeedbackUpdaterObserving(_ signal: Observable<FeedbackUpdatedEvent>) -> Disposable {
        signal
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] event in
                guard let self else { return }
                self.handleFeedbackEvent(event)
            })
    }

    func handleFeedbackEvent(_ event: FeedbackUpdatedEvent) {
        switch event {
        case .updated(let feedback):
            let newFeedbacks = output.feedbacks.value.map {
                $0.objectId == feedback.objectId ? feedback : $0
            }
            output.feedbacks.accept(newFeedbacks)
        case .created(let feedback):
            var newFeedbacks = output.feedbacks.value.reduce([feedback]) {
                var next = $0
                next.append($1)
                return next
            }
            loadedFeedbacks += 1
            newFeedbacks.sort { ascending ? $0.createdAt ?? Date() < $1.createdAt ?? Date() : $0.createdAt ?? Date() > $1.createdAt ?? Date() }
            output.feedbacks.accept(newFeedbacks)
        case .deleted(let feedback):
            let newFeedbacks = output.feedbacks.value.filter {
                $0.objectId != feedback.objectId
            }
            loadedFeedbacks -= 1
            output.feedbacks.accept(newFeedbacks)
        }
    }

    func setupMoreButtonObserving(_ signal: Observable<Feedback>) -> Disposable {
        signal
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] feedback in
                self?.coordinatorEvents.publish(.moreFeedback(feedback))
            }, onError: { error in
                print("___> error tapping more customer detail: \(error)")
            })
    }

    func setupCustomerTapObserving(_ signal: Observable<Feedback>) -> Disposable {
        signal
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] feedback in
                if let customer = feedback.customer {
                    self?.coordinatorEvents.publish(.customerDetails(customer))
                }
            }, onError: { error in
                print("___> error tapping more customer detail: \(error)")
            })
    }

    func setupChangeSortingTypeObserver(_ signal: Observable<Bool>) -> Disposable {
        signal.subscribe { [weak self] ascending in
            guard let self else { return }
            if self.ascending != ascending {
                self.changeSortingType()
            }
        }
    }

    func setupLeaveFeedbackProcessing(_ signal: Observable<Void>) -> Disposable {
        signal
            .map { HistoryCoordinatorEvent.leaveFeedback }
            .bind(to: coordinatorEvents)
    }

    func changeSortingType() {
        ascending.toggle()
        loadedFeedbacks = 0
        isMore = true
        output.feedbacks.accept([])
        loadMoreFeedbacks()
    }

    func loadMoreFeedbacks() {
        guard isMore, let user = historyServices.sessionService.currentUser.value else { return }
        output.isLoading.accept(true)
        historyServices.feedbackService
            .fetchUserFeedbacks(creator: user, ascending: ascending, skip: loadedFeedbacks, limit: 15)
            .subscribe(onNext: { [weak self] feedbacks in
                guard let self else { return }
                self.output.isLoading.accept(false)
                var savedFeedbacks = self.output.feedbacks.value
                savedFeedbacks.append(contentsOf: feedbacks)
                self.isMore = feedbacks.count == 15
                self.loadedFeedbacks = savedFeedbacks.count
                self.output.feedbacks.accept(savedFeedbacks)
            }, onError: { [weak self] _ in
                self?.output.isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
}

extension HistoryViewModel {
    struct Input {
        let moreButtonTapped: Publisher<Feedback> = .init()
        let customerTapped: Publisher<Feedback> = .init()
        let loadMore: Publisher<Void> = .init()
        let leaveFirstReview: Publisher<Void> = .init()
        let selectChangeSortingType: Publisher<Void> = .init()
        let sortingTypeChoosen: Publisher<Bool> = .init()
    }

    struct Output {
        let feedbacks: BehaviorRelay<[Feedback]> = .init(value: [])
        let showSortingType: BehaviorRelay<Bool> = .init(value: true)
        let isLoading: BehaviorRelay<Bool> = .init(value: false)
    }
}
