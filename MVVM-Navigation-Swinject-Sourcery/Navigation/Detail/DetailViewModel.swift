import Foundation
import RxSwift
import RxCocoa

protocol DetailViewModeling {
    var title: String { get }
    var subTitle: String { get }
    var description: String { get }

    func showAlert()
    func close()
}

// sourcery: inject
final class DetailViewModel: DetailViewModeling {
    private let navigation: DetailNavigation

    let title: String
    let subTitle: String
    let description: String

    // sourcery: inject, skip="detail"
    init(navigation: DetailNavigation, detail: Detail) {
        self.navigation = navigation
        self.title = detail.title
        self.subTitle = detail.subTitle
        self.description = detail.description
    }

    func showAlert() {
        navigation.alert(with: AlertViewModel(title: "Error", message: "Something happened", actions: [AlertActionViewModel(title: "OK")]))
    }

    func close() {
        navigation.back()
    }
}
