import Foundation
import RxSwift
import RxCocoa

extension RxList {
    /// - Tag: RxList.EventResponder
    final class EventResponder: BaseNavigationEventResponder, EventResponding {
        func handleOrReturn(event: EventType) -> EventType? {
            guard let e = event as? Event else { return event }
            switch e {
            case .detail(let detail):
                let controller = resolver.resolveDetailViewController(detail: detail)
                viewController.present(controller, animated: true)
                return nil
            case .back:
                return CommonEvent.back
            case .alert(let viewModel):
                return AlertEvent.present(viewModel)
            }
        }
    }
}
