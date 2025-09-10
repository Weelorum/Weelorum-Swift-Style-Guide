import Foundation
import RxSwift
import Core
import SnapKit
import UIKit
import RxRelay
import RxGesture
import RxCocoa

final class HistoryView: View {
    // MARK: - UI Components
    private let navigationContainerView: UIView = .init()
    private let navigationTitle: UILabel = .init()
    private let topReviewsView: UIView = .init()
    private let allReviewsLabel: UILabel = .init()
    private let emptyView: UIView = .init()
    private let emptyViewLabel: UILabel = .init()
    private let loaderView: LoaderView = .init()
    
    fileprivate let sortButton: UIButton = .init()
    fileprivate let myReviewsTableView: UITableView = .init()
    fileprivate let leaveFirstReviewButton: UIButton = .init()

    // MARK: - Properties
    private let disposeBag: DisposeBag = .init()
    
    fileprivate let feedbacks: BehaviorRelay<[Feedback]> = .init(value: [])
    fileprivate let moreTap: Publisher<Feedback> = .init()
    fileprivate let customerTap: Publisher<Feedback> = .init()
    fileprivate let loadMore: Publisher<Void> = .init()
    fileprivate let isLoading: BehaviorRelay<Bool> = .init(value: false)

    private var defaultTabBarHeight: CGFloat {
        UITabBarController().defaultTabBarHeight
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInputObserving()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    override func setupView() {
        super.setupView()

        apply {
            $0.backgroundColor = .white
        }

        navigationContainerView.apply {
            $0.backgroundColor = .white
            $0.clipsToBounds = false
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.05
            $0.layer.shadowRadius = 4
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        }

        navigationTitle.apply {
            $0.text = R.string.localizable.historyMyReviews()
            $0.font = R.font.poppinsMedium(size: 18)
            $0.textColor = R.color.mainBlack()
        }

        topReviewsView.apply {
            $0.backgroundColor = .white
        }

        allReviewsLabel.apply {
            $0.backgroundColor = .white
            $0.text = R.string.localizable.historyAllReviews()
            $0.font = R.font.poppinsSemiBold(size: 16)
            $0.textColor = R.color.mainBlack()
        }

        sortButton.apply {
            $0.backgroundColor = .white
            $0.setImage(R.image.ic_sort_by_icon(), for: .normal)
            $0.contentHorizontalAlignment = .left
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .trailing
            config.imagePadding = 8.0
            config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            let font = R.font.poppinsMedium(size: 14)
            let titleAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font!,
                NSAttributedString.Key.foregroundColor: R.color.mainBlack() ?? UIColor.black
            ]
            config.attributedTitle = AttributedString(R.string.localizable.historySortBy(), attributes: AttributeContainer(titleAttributes))
            $0.configuration = config
        }

        myReviewsTableView.apply {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.registerCellClass(FeedbackCell.self)
        }

        emptyView.apply {
            $0.backgroundColor = .white
            $0.isHidden = true
        }

        emptyViewLabel.apply {
            $0.backgroundColor = .white
            $0.text = R.string.localizable.historyNoReviewsLabel()
            $0.font = R.font.poppinsRegular(size: 14)
            $0.textColor = R.color.grey_400()
        }

        leaveFirstReviewButton.apply {
            $0.backgroundColor = .white
            $0.setTitle(R.string.localizable.historyLeaveFirstReviewButton(), for: .normal)
            $0.tintColor = R.color.mainOrange()
            $0.setImage(R.image.ic_add_feedback_icon(), for: .normal)
            $0.setTitleColor(R.color.mainOrange(), for: .normal)
            $0.contentHorizontalAlignment = .left
            var configuration = UIButton.Configuration.plain()
            configuration.imagePlacement = .leading
            configuration.imagePadding = 8.0

            $0.configuration = configuration
        }

        loaderView.apply {
            $0.isHidden = true
        }
    }

    override func setupConstraints() {
        super.setupConstraints()

        addSubviews([
            topReviewsView,
            navigationContainerView,
            myReviewsTableView,
            emptyView,
            loaderView
        ])

        navigationContainerView.addSubview(navigationTitle)

        topReviewsView.addSubviews([
            allReviewsLabel,
            sortButton
        ])

        emptyView.addSubviews([
            emptyViewLabel,
            leaveFirstReviewButton
        ])

        navigationContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        navigationTitle.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.top.equalTo(self.safeAreaLayoutGuide)
        }

        topReviewsView.snp.makeConstraints {
            $0.top.equalTo(navigationContainerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }

        allReviewsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }

        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }

        myReviewsTableView.snp.makeConstraints {
            $0.top.equalTo(topReviewsView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(defaultTabBarHeight + 34)
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(myReviewsTableView)
        }

        loaderView.snp.makeConstraints {
            $0.edges.equalTo(myReviewsTableView)
        }

        emptyViewLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }

        leaveFirstReviewButton.snp.makeConstraints {
            $0.top.equalTo(emptyViewLabel.snp.bottom).offset(13)
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Private Methods
private extension HistoryView {
    func setupInputObserving() {
        disposeBag.insert([
            setupTableViewDataSource(),
            setupEmptyViewObserving(),
            setupLoadingObserving()
        ])
    }
    
    func setupTableViewDataSource() -> Disposable {
        feedbacks
            .asDriver()
            .drive(myReviewsTableView.rx.items) { [weak self] tableView, row, model in
                guard let self else { return UITableViewCell() }

                if row == self.feedbacks.value.count - 5 {
                    self.loadMore.publish(())
                }
                
                let cell: FeedbackCell = tableView.dequeueReusableCell(ofType: FeedbackCell.self, at: IndexPath(row: row, section: 0))
                cell.setupWithModel(model, isCurrentUser: true)
                
                self.setupCellBindings(cell, model: model)
                
                return cell
            }
    }
    
    func setupCellBindings(_ cell: FeedbackCell, model: Feedback) {
        cell.moreButton
            .rx.tap
            .map { model }
            .bind(to: moreTap)
            .disposed(by: cell.disposeBag)
        
        cell.toProfileImage
            .rx.tapGesture()
            .when(.recognized)
            .map { _ in model }
            .subscribe(onNext: { [weak self] model in
                self?.customerTap.publish(model)
            })
            .disposed(by: cell.disposeBag)
        
        cell.fromProfileImage
            .rx.tapGesture()
            .when(.recognized)
            .map { _ in model }
            .subscribe(onNext: { [weak self] model in
                self?.customerTap.publish(model)
            })
            .disposed(by: cell.disposeBag)
        
        cell.reviewAddressingLabel
            .rx.tapGesture()
            .when(.recognized)
            .map { _ in model }
            .subscribe(onNext: { [weak self] model in
                self?.customerTap.publish(model)
            })
            .disposed(by: cell.disposeBag)
    }
    
    func setupEmptyViewObserving() -> Disposable {
        feedbacks.asObservable()
            .subscribe(onNext: { [weak self] feedbacks in
                self?.emptyView.isHidden = feedbacks.count > 0
            })
    }
    
    func setupLoadingObserving() -> Disposable {
        isLoading.asDriver()
            .drive(onNext: { [weak self] isLoading in
                self?.loaderView.isHidden = !isLoading
                self?.loaderView.setLoading(isLoading)
            })
    }
}

// MARK: - Reactive Extensions
extension Reactive where Base: HistoryView {
    var feedbacks: BehaviorRelay<[Feedback]> {
        base.feedbacks
    }

    var moreTap: Observable<Feedback> {
        base.moreTap.asObservable()
    }

    var customerTap: Observable<Feedback> {
        base.customerTap.asObservable()
    }

    var loadMore: Observable<Void> {
        base.loadMore.asObservable()
    }

    var leaveFirstFeedback: Observable<Void> {
        base.leaveFirstReviewButton.rx.tap.asObservable()
    }

    var changeSorting: Observable<Void> {
        base.sortButton.rx.tap.asObservable()
    }

    var isLoading: Binder<Bool> {
        Binder(base) { base, isLoading in
            base.isLoading.accept(isLoading)
        }
    }

}
