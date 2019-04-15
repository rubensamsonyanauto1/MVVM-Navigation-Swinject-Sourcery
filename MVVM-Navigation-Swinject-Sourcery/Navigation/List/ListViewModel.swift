import UIKit
import RxSwift
import RxCocoa

protocol ListCellModeling {
    var title: String { get }
    var subTitle: String { get }
    var description: String { get }
}

struct ListCellModel: ListCellModeling {
    let title: String
    let subTitle: String
    let description: String

    init(detail: Detail) {
        self.title = detail.title
        self.subTitle = detail.subTitle
        self.description = detail.description
    }
}

protocol ListViewModeling {
    var dataSource: [ListCellModeling] { get }

    func showDetail(for indexPath: IndexPath)
    func showAlert()
    func goBack()
}

// sourcery: inject
final class ListViewModel: ListViewModeling {
    private let navigation: ListNavigation
    private let data: [Detail] = [
        Detail(title: "Tax Accountant", subTitle: "Ideal Husband, An", description: "et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est"),
        Detail(title: "Marketing Manager", subTitle: "Stage Fright", description: "amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor"),
        Detail(title: "Physical Therapy Assistant", subTitle: "I Will Buy You (Anata kaimasu)", description: "viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non"),
        Detail(title: "Pharmacist", subTitle: "The Anomaly", description: "egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo"),
        Detail(title: "Civil Engineer", subTitle: "Simple Twist of Fate, A", description: "non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere"),
        Detail(title: "Quality Control Specialist", subTitle: "Oscar and Lucinda (a.k.a. Oscar & Lucinda)", description: "vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci")
    ]

    var dataSource: [ListCellModeling] {
        return data.map(createCellModel)
    }

    // sourcery: inject
    init(navigation: ListNavigation) {
        self.navigation = navigation
    }

    func showDetail(for indexPath: IndexPath) {
        let detail = data[indexPath.row]
        navigation.showDetail(with: detail)
    }

    func showAlert() {
        let alertModel = AlertViewModel(title: "Error", message: "Something happened", actions: [AlertActionViewModel(title: "OK")])
        navigation.alert(with: alertModel)
    }

    func goBack() {
        navigation.back()
    }

    func createCellModel(with detail: Detail) -> ListCellModeling {
        return ListCellModel(detail: detail)
    }
}