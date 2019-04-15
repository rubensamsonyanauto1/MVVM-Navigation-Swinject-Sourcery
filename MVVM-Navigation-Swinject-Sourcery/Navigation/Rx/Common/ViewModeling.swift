import Foundation

protocol ViewModeling {
    associatedtype Context
    associatedtype Data
    associatedtype ViewEvents

    init(context: Context, data: Data, viewEvents: ViewEvents, eventResponder: EventResponding)
}

extension ViewModeling {
    typealias CreateHandler = (ViewEvents) -> Self
    static func make(context: Context, data: Data, eventResponder: EventResponding) -> CreateHandler {
        return { viewEvents in
            return Self.init(context: context, data: data, viewEvents: viewEvents, eventResponder: eventResponder)
        }
    }
}
