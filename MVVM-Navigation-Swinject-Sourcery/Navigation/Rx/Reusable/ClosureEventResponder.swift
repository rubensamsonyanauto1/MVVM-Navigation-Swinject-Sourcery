import Foundation

final class ClosureEventResponder: BaseEventResponder, EventResponding {
    private let handle: (EventType) -> Bool

    init(next: EventResponding?, handle: @escaping (EventType) -> Bool) {
        self.handle = handle
        super.init(next: next)
    }

    func handle(event: EventType) -> Bool {
        return handle(event)
    }
}
