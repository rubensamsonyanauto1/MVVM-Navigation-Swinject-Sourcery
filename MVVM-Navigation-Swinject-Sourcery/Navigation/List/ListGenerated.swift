import UIKit
import Swinject

// MARK: Swinject

struct ListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ListViewController.self) { (resolver) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            controller.viewModel = resolver.resolve(ListViewModel.self, argument: controller as UIViewController)!
            return controller
        }

        container.register(ListViewModel.self) { (resolver, controller: UIViewController) in
            let navigation = resolver.resolve(ListNavigation.self, argument: controller)!
            return ListViewModel(navigation: navigation)
        }

        container.register(ListNavigation.self) { (resolver, controller: UIViewController) in
            return ListNavigationDefault(resolver: resolver, viewController: controller)
        }
    }
}

final class ListNavigationDefault: BaseNavigation, ListNavigation {}

extension Resolver {
    func resolveListViewController() -> ListViewController {
        return resolve(ListViewController.self)!
    }
}
