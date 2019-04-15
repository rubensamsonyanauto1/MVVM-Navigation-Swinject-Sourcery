import Foundation
import UIKit
import Swinject

// sourcery: inject
protocol ListNavigation: DefaultNavigation, AlertNavigation {
    // sourcery: destination="DetailViewController", present
    func showDetail(with detail: Detail)
}

extension ListNavigation where Self: Navigation {
    func showDetail(with detail: Detail) {
        let controller = resolver.resolveDetailViewController(detail: detail)
        viewController.present(controller, animated: true)
    }
}
