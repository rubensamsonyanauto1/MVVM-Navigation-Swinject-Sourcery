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
    var isEnabled: Observable<Bool> { get }

    func handle(events: Observable<EventType>)
    func handleInChain(event: EventType) -> Bool
    func handleOrReturn(event: EventType) -> EventType?
}

extension EventResponding {
    func handle(events: Observable<EventType>) {
        handleEventsIfEnabled(events)
    }

    func handleEventsIfEnabled(_ events: Observable<EventType>) {
        events.withLatestFrom(isEnabled) { ($0, $1) }
              .filter { $0.1 }
              .map { $0.0 }
              .observeOn(MainScheduler.instance)
              .subscribe(onNext: { [weak self] event in
                  self?.handleSingleEvent(event: event)
              })
              .disposed(by: disposeBag)
    }

    func handleInChain(event: EventType) -> Bool {
        guard let event = handleOrReturn(event: event) else { return true }
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

extension EventResponding {
    func handle(events: Driver<EventType>) {
        handle(events: events.asObservable())
    }

    func handle<E: EventType>(events: Driver<E>) {
        handle(events: events.map { $0 as EventType })
    }

    func handle<E: EventType>(events: Observable<E>) {
        handle(events: events.map { $0 as EventType })
    }
}

class BaseEventResponder {
    let disposeBag = DisposeBag()
    let next: EventResponding?
    let isEnabled: Observable<Bool>

    init(next: EventResponding?, isEnabled: Observable<Bool>) {
        self.next = next
        self.isEnabled = isEnabled
    }
}

class BaseNavigationEventResponder: BaseEventResponder {
    let resolver: Resolver
    private(set) weak var viewController: UIViewController!

    init(next: EventResponding?, isEnabled: Observable<Bool>, resolver: Resolver, viewController: UIViewController!) {
        self.resolver = resolver
        self.viewController = viewController
        super.init(next: next, isEnabled: isEnabled)
    }
}
