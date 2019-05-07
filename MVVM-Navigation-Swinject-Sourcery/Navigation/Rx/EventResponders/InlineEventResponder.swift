import Foundation
import RxSwift
import RxCocoa

final class InlineEventResponder<Event: EventType>: BaseEventResponder, EventResponding {
    private let eventRelay = EventRelay()
    private let handleOrReturn: (Event) -> EventType?
    private var predicates: [(Event) -> Bool] = []
    private lazy var eventsCache = eventRelay.asDriver()

    init(next: EventResponding?, isEnabled: Observable<Bool> = .just(true), handleOrReturn: @escaping (Event) -> EventType? = { return $0 }) {
        self.handleOrReturn = handleOrReturn
        super.init(next: next, isEnabled: isEnabled)
        filterAndHandleEvents()
    }

    func handle(events: Observable<EventType>) {
        events.bind(to: eventRelay).disposed(by: disposeBag)
    }

    func takeEvent(where predicate: @escaping (Event) -> Bool) -> Driver<EventType> {
        predicates.append(predicate)
        return eventsCache.filter {
            guard let event = $0 as? Event else { return false }
            return predicate(event)
        }
    }

    func handleOrReturn(event: EventType) -> EventType? {
        guard let e = event as? Event else { return event }
        return handleOrReturn(e)
    }

    private func filterAndHandleEvents() {
        eventsCache.filter { [weak self] event in
                       guard let self = self, let event = event as? Event else { return false }
                       return self.predicates.reduce(true, { $0 && !$1(event) })
                   }
                   .drive(onNext: { [weak self] event in
                       self?.handleSingleEvent(event: event)
                   })
                   .disposed(by: disposeBag)
    }
}