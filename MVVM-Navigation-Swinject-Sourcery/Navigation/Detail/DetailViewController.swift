import Foundation
import UIKit

// sourcery: inject, storyboard="Main"
final class DetailViewController: UIViewController {

    // sourcery: inject
    var viewModel: DetailViewModeling!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        descriptionLabel.text = viewModel.description
    }

    @IBAction func close() {
        viewModel.close()
    }

    @IBAction func showAlert() {
        viewModel.showAlert()
    }
}
