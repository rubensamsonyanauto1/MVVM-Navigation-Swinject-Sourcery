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
