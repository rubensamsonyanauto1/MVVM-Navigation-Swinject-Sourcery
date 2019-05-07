import Swinject
import RxSwift

extension RxList {
    struct Assembly: Swinject.Assembly {
        func assemble(container: Container) {
            container.register(EventResponding.self, name: "RxList") { (resolver, controller: UIViewController, isEnabled: Observable<Bool>) in
                let deepLinking = resolver.resolve(EventResponding.self, name: "DeepLinking", arguments: controller, nil as EventResponding?, isEnabled)
                let common = resolver.resolve(EventResponding.self, name: "Common", arguments: controller, deepLinking, isEnabled)
                let alert = resolver.resolve(EventResponding.self, name: "Alert", arguments: controller, common, isEnabled)
                return EventResponder(next: alert, isEnabled: isEnabled, resolver: resolver, viewController: controller)
            }

            container.register(Context.self) { resolver in
                return Context()
            }

            container.register(RxListViewModel.CreateHandler.self) { (resolver, eventResponder: EventResponding, data: Data) in
                let context = resolver.resolve(Context.self)!
                return ViewModel.make(context: context, data: data, eventResponder: eventResponder)
            }

            container.register(RxListViewController.self) { (resolver) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "RxListViewController") as! RxListViewController
                let eventResponder = resolver.resolve(EventResponding.self, name: "RxList" as String?, arguments: controller as UIViewController, controller.rx.visible.asObservable())!
                controller.createHandler = resolver.resolve(RxListViewModel.CreateHandler.self, arguments: eventResponder, Data())!
                return controller
            }
        }
    }
}

extension Resolver {
    func resolveRxListController() -> RxListViewController {
        return resolve(RxListViewController.self)!
    }
}
