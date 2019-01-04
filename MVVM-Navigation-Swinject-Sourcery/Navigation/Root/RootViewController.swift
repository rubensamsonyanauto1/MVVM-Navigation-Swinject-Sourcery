import UIKit

// sourcery: inject, storyboard="Main"
final class RootViewController: UIViewController {

    // sourcery: inject
    var viewModel: RootViewModeling!

    @IBAction func showList() {
        viewModel.showList()
    }
}
