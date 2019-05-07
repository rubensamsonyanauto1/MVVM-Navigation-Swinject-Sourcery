import Foundation
import RxSwift
import RxCocoa

protocol EventGetter {
    var event: Observable<EventType> { get }
}

protocol EventSetter {
    func forward(event: EventType)
}

final class SimpleExternalEventProvider: EventGetter, EventSetter {
    private let eventRelay = EventRelay()
    private(set) lazy var event: Observable<EventType> = eventRelay.asObservable()

    func forward(event: EventType) {
        eventRelay.accept(event)
    }
}
