import Foundation
import RxSwift
import RxCocoa

final class EventRelay {
    private enum Event: EventType {
        case dummy
    }
    private let eventsRelay = PublishRelay<EventType>()

    func accept(_ event: EventType) {
        eventsRelay.accept(event)
    }

    func asDriver() -> Driver<EventType> {
        return eventsRelay.asDriver(onErrorJustReturn: Event.dummy).filter { if case Event.dummy = $0 { return false } else { return true } }
    }

    func asObservable() -> Observable<EventType> {
        return eventsRelay.asObservable()
    }
}

private let errorMessage = """
                           `drive*` family of methods can be only called from `MainThread`.
                           This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n
                           """

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy, E == EventType {
    func drive(_ relay: EventRelay) -> Disposable {
        MainScheduler.ensureExecutingOnScheduler(errorMessage: errorMessage)
        return drive(onNext: { e in
            relay.accept(e)
        })
    }
}

extension ObservableType where E == EventType {
    func bind(to relay: EventRelay) -> Disposable {
        return subscribe(onNext: { e in
            relay.accept(e)
        })
    }
}