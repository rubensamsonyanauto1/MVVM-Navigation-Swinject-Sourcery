import UIKit

protocol AlertNavigation {
    func alert(with viewModel: AlertViewModel)
}

extension AlertNavigation where Self: Navigation {
    func alert(with viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)

        viewModel.actions.map { actionViewModel in
                             UIAlertAction(title: actionViewModel.title,
                                           style: actionViewModel.style,
                                           handler: { _ in actionViewModel.handler?() })
                         }
                         .forEach(alert.addAction)

        viewController.present(alert, animated: true)
    }
}
