import UIKit
import Swinject

protocol Navigation {
    var resolver: Resolver { get }
    var viewController: UIViewController! { get }
}

class BaseNavigation: Navigation {
    let resolver: Resolver
    private(set) weak var viewController: UIViewController!

    init(resolver: Resolver, viewController: UIViewController) {
        self.resolver = resolver
        self.viewController = viewController
    }
}

// MARK: Default navigation cases

protocol DefaultNavigation {
    func back()
}

extension DefaultNavigation where Self: Navigation {
    func back() {
        if viewController.isModal {
            viewController.dismiss(animated: true)
        } else {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}