import UIKit
import RxSwift
import Swinject

enum CommonEvent: EventType {
    case back
}

/// - Tag: CommonEventResponder
final class CommonEventResponder: BaseNavigationEventResponder, EventResponding {
    func handleOrReturn(event: EventType) -> EventType? {
        guard let e = event as? CommonEvent else { return event }
        switch e {
        case .back:
            if viewController.isModal {
                viewController.dismiss(animated: true)
            } else {
                viewController.navigationController?.popViewController(animated: true)
            }
            return nil
        }
    }
}

struct CommonEventResponderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EventResponding.self, name: "Common") { (resolver, controller: UIViewController, next: EventResponding?, isEnabled: Observable<Bool>) in
            return CommonEventResponder(next: next, isEnabled: isEnabled, resolver: resolver, viewController: controller)
        }
    }
}
