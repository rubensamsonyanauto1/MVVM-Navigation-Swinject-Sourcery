import UIKit
import Swinject

enum AlertEvent: EventType {
    case present(AlertViewModel)
}

/// - Tag: AlertEventResponder
final class AlertEventResponder: BaseNavigationEventResponder, EventResponding {
    func handle(event: EventType) -> Bool {
        guard let event = event as? AlertEvent else { return false }

        switch event {
        case .present(let viewModel):
            let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)

            viewModel.actions.map { actionViewModel in
                                 UIAlertAction(title: actionViewModel.title,
                                               style: actionViewModel.style,
                                               handler: { _ in actionViewModel.handler?() })
                             }
                             .forEach(alert.addAction)

            viewController.present(alert, animated: true)
        }

        return true
    }
}

struct AlertEventResponderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EventResponding.self, name: "Alert") { (resolver, controller: UIViewController, next: EventResponding?) in
            return AlertEventResponder(next: next, resolver: resolver, viewController: controller)
        }
    }
}
