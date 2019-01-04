import Foundation
import UIKit

// sourcery: inject, storyboard="Main"
final class ListViewController: UIViewController {

    // sourcery: inject
    var viewModel: ListViewModeling!

    @IBOutlet weak var tableView: UITableView!

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        cell.textLabel?.text = viewModel.dataSource[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetail(for: indexPath)
    }
}
