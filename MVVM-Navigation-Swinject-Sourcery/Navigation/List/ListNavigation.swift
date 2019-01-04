import Foundation
import UIKit

// sourcery: inject
protocol ListNavigation: AlertNavigation, DefaultNavigation {
    // sourcery: destination="DetailViewController", present
    func showDetail(with detail: Detail)
}
