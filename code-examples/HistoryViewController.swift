import UIKit
import Core
import SnapKit
import RxSwift

final class HistoryViewController: ViewController, NonReusableViewProtocol {
    // MARK: - Properties
    private let historyView: HistoryView = .init()
    private let chosenSortingType: Publisher<Bool> = .init()

    // MARK: - Lifecycle
    func didSetViewModel(_ viewModel: HistoryViewModelProtocol) {
        setupInput(viewModel.input)
        setupOutput(viewModel.output)
    }

    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
    }

    override func setupConstraints() {
        super.setupConstraints()

        view.addSubview(historyView)

        historyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Private Methods
private extension HistoryViewController {
    func setupInput(_ viewModelInput: HistoryViewModel.Input) {
        disposeBag.insert([
            historyView.rx.moreTap.bind(to: viewModelInput.moreButtonTapped),
            historyView.rx.customerTap.bind(to: viewModelInput.customerTapped),
            historyView.rx.loadMore.bind(to: viewModelInput.loadMore),
            historyView.rx.changeSorting.bind(to: viewModelInput.selectChangeSortingType),
            historyView.rx.leaveFirstFeedback.bind(to: viewModelInput.leaveFirstReview),
            chosenSortingType.asObservable().bind(to: viewModelInput.sortingTypeChoosen)
        ])
    }

    func setupOutput(_ viewModelOutput: HistoryViewModel.Output) {
        disposeBag.insert([
            viewModelOutput.feedbacks.bind(to: historyView.rx.feedbacks),
            viewModelOutput.showSortingType.asObservable()
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] currentSortingType in
                    self?.showSortingTypeSelection(currentSortingType)
                }),
            viewModelOutput.isLoading.bind(to: historyView.rx.isLoading)
        ])
    }

    func showSortingTypeSelection(_ sortingType: Bool) {
        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Додавання варіантів
        let oldReviewsAction = UIAlertAction(title: R.string.localizable.historyOldReviewsFirst(), style: .default) { [weak self] _ in
            self?.chosenSortingType.publish(true)
        }

        let newReviewsAction = UIAlertAction(title: R.string.localizable.historyNewReviewsFirst(), style: .default) { [weak self] _ in
            self?.chosenSortingType.publish(false)
        }

        vc.addAction(oldReviewsAction)
        vc.addAction(newReviewsAction)

        let cancelAction = UIAlertAction(title: R.string.localizable.historyCancel(), style: .cancel, handler: nil)
        vc.addAction(cancelAction)

        oldReviewsAction.setValue(R.color.mainBlack(), forKey: "titleTextColor")
        newReviewsAction.setValue(R.color.mainBlack(), forKey: "titleTextColor")
        cancelAction.setValue(R.color.mainBlack(), forKey: "titleTextColor")

        let checkImage = R.image.ic_checkmark_icon() ?? UIImage(systemName: "checkmark")
        if !sortingType {
            newReviewsAction.setValue(checkImage?.withRenderingMode(.alwaysOriginal), forKey: "image")
        } else {
            oldReviewsAction.setValue(checkImage?.withRenderingMode(.alwaysOriginal), forKey: "image")
        }

        self.present(vc, animated: true, completion: nil)
    }
}
