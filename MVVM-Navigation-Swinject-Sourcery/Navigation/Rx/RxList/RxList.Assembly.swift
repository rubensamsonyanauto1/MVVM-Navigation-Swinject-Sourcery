import Swinject

extension RxList {
    struct Assembly: Swinject.Assembly {
        func assemble(container: Container) {
            container.register(EventResponding.self, name: "RxList") { (resolver, controller: UIViewController) in
                let common = resolver.resolve(EventResponding.self, name: "Common", arguments: controller, nil as EventResponding?)
                let alert = resolver.resolve(EventResponding.self, name: "Alert", arguments: controller, common)
                return EventResponder(next: alert, resolver: resolver, viewController: controller)
            }

            container.register(Context.self) { resolver in
                return Context()
            }

            container.register(RxListViewModeling.CreateHandler.self) { (resolver, eventResponder: EventResponding, data: Data) in
                let context = resolver.resolve(Context.self)!
                return ViewModel.make(context: context, data: data, eventResponder: eventResponder)
            }

            container.register(RxListViewController.self) { (resolver) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "RxListViewController") as! RxListViewController
                let eventResponder = resolver.resolve(EventResponding.self, name: "RxList" as String?, argument: controller as UIViewController)!
                controller.createHandler = resolver.resolve(RxListViewModeling.CreateHandler.self, arguments: eventResponder, Data())!
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
