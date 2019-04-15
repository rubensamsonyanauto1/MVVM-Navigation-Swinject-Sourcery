import Foundation
import RxSwift
import RxCocoa

final class RxEventResponder: BaseEventResponder, EventResponding {
    private var eventsCache: Driver<EventType> = .never()
    private var predicates: [(EventType) -> Bool] = []

    func handle(events: Driver<EventType>) {
        eventsCache = Driver.merge(eventsCache, events)
        let eventsToHandle = eventsCache.filter { [weak self] event in
            guard let self = self else { return false }
            return self.predicates.reduce(true, { $0 && !$1(event) })
        }

        disposeBag = DisposeBag()
        eventsToHandle.drive(onNext: { [weak self] event in
                          self?.handleSingleEvent(event: event)
                      })
                      .disposed(by: disposeBag)
    }

    func event(where predicate: @escaping (EventType) -> Bool) -> Driver<EventType> {
        predicates.append(predicate)
        return eventsCache.filter(predicate)
    }

    func handle(event: EventType) -> Bool { return false }
}