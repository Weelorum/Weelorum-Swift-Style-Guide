import Foundation

// MARK: - Protocol
protocol HistoryServiceProtocol {
    var sessionService: SessionManagerProtocol { get }
    var feedbackService: FeedbackAPIServiceProtocol { get }
    var localUpdateService: LocalUpdaterServiceProtocol { get }
}

// MARK: - Implementation
final class HistoryService: HistoryServiceProtocol {
    // MARK: - Properties
    let sessionService: SessionManagerProtocol
    let feedbackService: FeedbackAPIServiceProtocol
    let localUpdateService: LocalUpdaterServiceProtocol

    // MARK: - Init
    init(sessionService: SessionManagerProtocol,
         feedbackService: FeedbackAPIServiceProtocol,
         localUpdateService: LocalUpdaterServiceProtocol) {
        self.sessionService = sessionService
        self.feedbackService = feedbackService
        self.localUpdateService = localUpdateService
    }
}
