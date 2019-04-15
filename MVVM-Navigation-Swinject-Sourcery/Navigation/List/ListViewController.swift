import Foundation
import UIKit

final class ActionedCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func setup(with model: ListCellModeling) {
        self.titleLabel.text = model.title
        self.subTitleLabel.text = model.subTitle
        self.descriptionLabel.text = model.description
    }
}

// sourcery: inject, storyboard="Main"
final class ListViewController: UIViewController {

    // sourcery: inject
    var viewModel: ListViewModeling!

    @IBOutlet private weak var tableView: UITableView!

    @IBAction func goBack() {
        viewModel.goBack()
    }

    @IBAction func showAlert() {
        viewModel.showAlert()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionedCell", for: indexPath) as! ActionedCell
        let model = viewModel.dataSource[indexPath.row]
        cell.setup(with: model)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
