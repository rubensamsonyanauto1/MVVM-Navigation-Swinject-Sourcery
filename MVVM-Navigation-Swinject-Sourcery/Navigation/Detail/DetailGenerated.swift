import Foundation
import UIKit
import Swinject

// MARK: Navigation

private final class DetailNavigationDefault: BaseNavigation, DetailNavigation {}

// MARK: Swinject

struct DetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetailViewController.self) { (resolver, detail: Detail) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            controller.viewModel = resolver.resolve(DetailViewModel.self, arguments: controller as UIViewController, detail)!
            return controller
        }

        container.register(DetailViewModel.self) { (resolver, controller: UIViewController, detail: Detail) in
            let navigation = resolver.resolve(DetailNavigation.self, argument: controller)!
            return DetailViewModel(navigation: navigation, detail: detail)
        }

        container.register(DetailNavigation.self) { (resolver, controller: UIViewController) in
            return DetailNavigationDefault(resolver: resolver, viewController: controller)
        }
    }
}

extension Resolver {
    func resolveDetailViewController(detail: Detail) -> DetailViewController {
        return resolve(DetailViewController.self, argument: detail)!
    }
}