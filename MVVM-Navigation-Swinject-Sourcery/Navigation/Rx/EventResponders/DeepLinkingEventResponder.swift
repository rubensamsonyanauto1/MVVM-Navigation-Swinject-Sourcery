import Swinject
import RxSwift
import RxCocoa

enum DeepLinkingEvent: EventType {
    case deepLink
}

/// - Tag: CommonEventResponder
final class DeepLinkingEventResponder: BaseNavigationEventResponder, EventResponding {
    init(next: EventResponding?, isEnabled: Observable<Bool>, resolver: Resolver, viewController: UIViewController, eventProvider: EventGetter) {
        super.init(next: next, isEnabled: isEnabled, resolver: resolver, viewController: viewController)
        self.handle(events: eventProvider.event)
    }

    func handleOrReturn(event: EventType) -> EventType? {
        guard let e = event as? DeepLinkingEvent else { return event }
        switch e {
        case .deepLink:
            if viewController is RxListViewController {
                viewController.navigationController?.popViewController(animated: true)
            }
            let controller = resolver.resolveRxListController()
            viewController.navigationController?.pushViewController(controller, animated: true)
            return nil
        }
    }
}

struct DeepLinkingEventResponderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EventResponding.self, name: "DeepLinking") { (resolver, controller: UIViewController, next: EventResponding?, isEnabled: Observable<Bool>) in
            let eventProvider = resolver.resolve(EventGetter.self, name: "DeepLinking")!
            return DeepLinkingEventResponder(next: next, isEnabled: isEnabled, resolver: resolver, viewController: controller, eventProvider: eventProvider)
        }

        container.register(SimpleExternalEventProvider.self, name: "DeepLinking") { resolver in
            return SimpleExternalEventProvider()
        }.inObjectScope(.container)

        container.register(EventGetter.self, name: "DeepLinking") { resolver in
            return resolver.resolve(SimpleExternalEventProvider.self, name: "DeepLinking")!
        }

        container.register(EventSetter.self, name: "DeepLinking") { resolver in
            return resolver.resolve(SimpleExternalEventProvider.self, name: "DeepLinking")!
        }
    }
}

extension Resolver {
    func resolveDeepLinkingEventForwarder() -> EventSetter {
        return resolve(EventSetter.self, name: "DeepLinking")!
    }
}
