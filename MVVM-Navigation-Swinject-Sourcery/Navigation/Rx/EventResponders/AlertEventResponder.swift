import UIKit
import RxSwift
import Swinject

enum AlertEvent: EventType {
    case present(AlertViewModel)
}

/// - Tag: AlertEventResponder
final class AlertEventResponder: BaseNavigationEventResponder, EventResponding {
    func handleOrReturn(event: EventType) -> EventType? {
        guard let e = event as? AlertEvent else { return event }
        switch e {
        case .present(let viewModel):
            showAlert(with: viewModel)
            return nil
        }
    }

    private func showAlert(with viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)

        viewModel.actions.map { actionViewModel in
                             UIAlertAction(title: actionViewModel.title,
                                           style: actionViewModel.style,
                                           handler: { _ in actionViewModel.handler?() })
                         }
                         .forEach(alert.addAction)

        viewController.present(alert, animated: true)
    }
}

struct AlertEventResponderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EventResponding.self, name: "Alert") { (resolver, controller: UIViewController, next: EventResponding?, isEnabled: Observable<Bool>) in
            return AlertEventResponder(next: next, isEnabled: isEnabled, resolver: resolver, viewController: controller)
        }
    }
}
