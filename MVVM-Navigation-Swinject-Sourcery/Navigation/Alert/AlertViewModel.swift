import Foundation

class AlertViewModel {
    let title: String?
    let message: String?

    var actions: [AlertActionViewModel]

    init(title: String?, message: String?, actions: [AlertActionViewModel]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

extension AlertViewModel: Equatable {
    static func ==(lhs: AlertViewModel, rhs: AlertViewModel) -> Bool {
        if lhs === rhs { return true }
        if type(of: lhs) != type(of: rhs) { return false }
        return lhs.title == rhs.title
            && lhs.message == rhs.message
    }
}
