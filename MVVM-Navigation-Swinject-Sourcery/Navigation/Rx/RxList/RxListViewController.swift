import UIKit
import RxSwift
import RxCocoa

final class RxListCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var reloadButton: UIButton!
    @IBOutlet private weak var alertButton: UIButton!
    @IBOutlet private weak var trackButton: UIButton!

    func setup(with model: RxListCellModeling) {
        self.titleLabel.text = model.title
        self.subTitleLabel.text = model.subTitle
        self.descriptionLabel.text = model.description

        reloadButton.rx.tap.bind(to: model.reload).disposed(by: disposeBag)
        alertButton.rx.tap.bind(to: model.alert).disposed(by: disposeBag)
        trackButton.rx.tap.bind(to: model.track).disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

final class RxListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: RxListViewModeling!
    var createHandler: RxListViewModeling.CreateHandler!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var reloadButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var alertButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = createHandler(RxList.ViewEvents(back: backButton.rx.tap.asDriver(),
                                                    reload: reloadButton.rx.tap.asDriver(),
                                                    selectedIndex: tableView.rx.itemSelected.asDriver().map { $0.row },
                                                    alert: alertButton.rx.tap.asDriver()))

        viewModel.state.map { $0.dataSource }
                       .drive(tableView.rx.items(cellIdentifier: "RxListCell", cellType: RxListCell.self)) { $2.setup(with: $1) }
                       .disposed(by: disposeBag)
    }
}
