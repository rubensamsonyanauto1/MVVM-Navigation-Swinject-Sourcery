import Foundation

protocol RootViewModeling {
    func showList()
}

// sourcery: inject
final class RootViewModel: RootViewModeling {
    private let navigation: RootNavigation

    // sourcery: inject
    init(navigation: RootNavigation) {
        self.navigation = navigation
    }

    // Can be generated
    func showList() {
        navigation.showList()
    }
}
