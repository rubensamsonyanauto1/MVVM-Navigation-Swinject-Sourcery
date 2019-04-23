import Foundation
import RxSwift
import RxCocoa

final class RxEventResponder: BaseEventResponder, EventResponding {
    private enum Event: EventType {
        case dummy
    }
    private let eventsCacheRelay = BehaviorRelay<EventType>(value: Event.dummy)
    private lazy var eventsCache = eventsCacheRelay.asDriver().skip(1)
    private var predicates: [(EventType) -> Bool] = []

    override init(next: EventResponding?) {
        super.init(next: next)

        eventsCache.filter { [weak self] event in
                       guard let self = self else { return false }
                       return self.predicates.reduce(true, { $0 && !$1(event) })
                   }
                   .drive(onNext: { [weak self] event in
                       self?.handleSingleEvent(event: event)
                   })
                   .disposed(by: disposeBag)
    }

    func handle(events: Driver<EventType>) {
        events.drive(eventsCacheRelay).disposed(by: disposeBag)
    }

    func event(where predicate: @escaping (EventType) -> Bool) -> Driver<EventType> {
        predicates.append(predicate)
        return eventsCache.filter(predicate)
    }

    func handle(event: EventType) -> Bool { return false }
}