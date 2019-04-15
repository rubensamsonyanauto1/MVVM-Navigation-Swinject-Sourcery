import Foundation
import UIKit
import RxSwift
import RxCocoa
import Swinject

// MARK: - Event responding

protocol EventType {}

protocol EventResponding: class {
    var disposeBag: DisposeBag { get }
    var next: EventResponding? { get }

    func handle(events: Driver<EventType>)
    func handle(event: EventType) -> Bool
    func handleInChain(event: EventType) -> Bool
}

extension EventResponding {
    func handle(events: Driver<EventType>) {
        events.drive(onNext: { [weak self] event in
                  self?.handleSingleEvent(event: event)
              })
              .disposed(by: disposeBag)
    }

    func handleInChain(event: EventType) -> Bool {
        let result = handle(event: event)
        guard !result else { return true }
        guard let next = next else { return false }
        return next.handleInChain(event: event)
    }

    func handleSingleEvent(event: EventType) {
        guard handleInChain(event: event) else {
            #if DEBUG
            assertionFailure("⚠️ The event '\(event)' is not handled")
            #else
            print("⚠️ The event '\(event)' is not handled")
            #endif
            return
        }
    }
}

class BaseEventResponder {
    var disposeBag = DisposeBag()
    let next: EventResponding?

    init(next: EventResponding?) {
        self.next = next
    }
}

class BaseNavigationEventResponder: BaseEventResponder {
    let resolver: Resolver
    private(set) weak var viewController: UIViewController!

    init(next: EventResponding?, resolver: Resolver, viewController: UIViewController!) {
        self.resolver = resolver
        self.viewController = viewController
        super.init(next: next)
    }
}
