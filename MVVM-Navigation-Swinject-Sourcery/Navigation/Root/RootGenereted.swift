import UIKit
import Swinject

// MARK: Navigation

extension RootNavigation where Self: Navigation {
    func showList() {
        let controller = resolver.resolveListViewController()
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
}

private final class RootNavigationDefault: BaseNavigation, RootNavigation {}

// MARK: Swinject

struct RootAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RootViewController.self) { resolver in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
            controller.viewModel = resolver.resolve(RootViewModel.self, argument: controller as UIViewController)!
            return controller
        }

        container.register(RootViewModel.self) { (resolver, controller: UIViewController) in
            let navigation = resolver.resolve(RootNavigation.self, argument: controller)!
            return RootViewModel(navigation: navigation)
        }

        container.register(RootNavigation.self) { (resolver, controller: UIViewController) in
            return RootNavigationDefault(resolver: resolver, viewController: controller)
        }
    }
}

extension Resolver {
    func resolveRootViewController() -> RootViewController {
        return resolve(RootViewController.self)!
    }
}
