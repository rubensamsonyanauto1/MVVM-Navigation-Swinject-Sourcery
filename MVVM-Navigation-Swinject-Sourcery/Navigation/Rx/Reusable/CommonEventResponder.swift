import UIKit
import Swinject

enum CommonEvent: EventType {
    case back
}

/// - Tag: CommonEventResponder
final class CommonEventResponder: BaseNavigationEventResponder, EventResponding {
    func handle(event: EventType) -> Bool {
        guard let event = event as? CommonEvent else { return false }

        switch event {
        case .back:
            if viewController.isModal {
                viewController.dismiss(animated: true)
            } else {
                viewController.navigationController?.popViewController(animated: true)
            }
        }

        return true
    }
}

struct CommonEventResponderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EventResponding.self, name: "Common") { (resolver, controller: UIViewController, next: EventResponding?) in
            return CommonEventResponder(next: next, resolver: resolver, viewController: controller)
        }
    }
}
