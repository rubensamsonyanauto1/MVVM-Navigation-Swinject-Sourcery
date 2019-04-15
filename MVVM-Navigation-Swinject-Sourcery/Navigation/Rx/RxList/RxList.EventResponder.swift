import Foundation

extension RxList {
    /// - Tag: RxList.EventResponder
    final class EventResponder: BaseNavigationEventResponder, EventResponding {
        func handle(event: EventType) -> Bool {
            guard let event = event as? Event else { return false }

            switch event {
            case .detail(let detail):
                let controller = resolver.resolveDetailViewController(detail: detail)
                viewController.present(controller, animated: true)
            }

            return true
        }
    }
}
