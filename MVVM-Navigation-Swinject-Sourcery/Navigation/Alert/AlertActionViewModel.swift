import UIKit

struct AlertActionViewModel {
    let title: String?
    let style: UIAlertAction.Style
    let handler: (() -> Void)?

    init(title: String?, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension AlertActionViewModel: Equatable {
    public static func ==(lhs: AlertActionViewModel, rhs: AlertActionViewModel) -> Bool {
        return lhs.title == rhs.title
            && lhs.style == rhs.style
    }
}
