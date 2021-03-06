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
