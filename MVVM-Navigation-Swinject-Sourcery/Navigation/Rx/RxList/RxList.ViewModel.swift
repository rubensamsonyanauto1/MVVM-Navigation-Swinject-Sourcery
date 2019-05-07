import Foundation
import RxSwift
import RxCocoa

protocol RxListViewModel {
    typealias CreateHandler = (RxList.ViewEvents) -> RxListViewModel
    var state: Driver<RxList.ViewState> { get }

    // No methods to be called from controller. Only if there is need to call from outside
}

extension RxList {
    /// Responders chain: RxList.EventResponder -> AlertEventResponder -> CommonEventResponder
    struct ViewModel: RxListViewModel, ViewModeling {
        let state: Driver<ViewState>

        init(context: Context, data: Data, viewEvents: ViewEvents, eventResponder: EventResponding) {
            let helper = Helper()
            let cellEventsSetup = helper.setupCellEvents(with: eventResponder)
            let reload = Driver.merge(cellEventsSetup.reload, viewEvents.reload)
            let dataSource = reload.map { getData() }.startWith(getData())

            state = dataSource.map { ViewState(title: "RxList Example", dataSource: $0.map { CellModel(detail: $0, eventResponder: cellEventsSetup.responder) }) }
            handle(viewEvents: viewEvents, with: eventResponder, dataSource: dataSource, helper: helper)
        }

        private func handle(viewEvents: ViewEvents, with eventResponder: EventResponding, dataSource: Driver<[Detail]>, helper: Helper) {
            let events = Driver<Event>.merge(
                viewEvents.back.map { .back },
                viewEvents.selectedIndex.withLatestFrom(dataSource) { $1[$0] }.map { .detail($0) },
                viewEvents.alert.map { .alert(helper.makeAlertViewModel()) }
            )
            eventResponder.handle(events: events)
        }

        private struct Helper {
            func setupCellEvents(with next: EventResponding?) -> (responder: EventResponding, reload: Driver<Void>) {
                let inlineResponder = InlineEventResponder<CellEvent>(next: next) {
                    switch $0 {
                    case .track:
                        print("Track some event")
                        return nil
                    case .reload:
                        return $0
                    case .alert(let viewModel):
                        return Event.alert(viewModel)
                    }
                }
                let reload = inlineResponder.takeEvent(where: { CellEvent.reload == $0 }).map { _ in () }

                return (inlineResponder, reload)
            }

            func makeAlertViewModel() -> AlertViewModel {
                return AlertViewModel(title: "Error",
                                      message: "Something happened",
                                      actions: [AlertActionViewModel(title: "OK")])
            }
        }
    }
}

protocol RxListCellModel {
    var title: String { get }
    var subTitle: String { get }
    var description: String { get }

    var reload: PublishRelay<Void> { get }
    var alert: PublishRelay<Void> { get }
    var track: PublishRelay<Void> { get }
}

extension RxList {
    struct CellModel: RxListCellModel {
        let title: String
        let subTitle: String
        let description: String

        let reload = PublishRelay<Void>()
        let alert = PublishRelay<Void>()
        let track = PublishRelay<Void>()

        init(detail: Detail, eventResponder: EventResponding) {
            self.title = detail.title
            self.subTitle = detail.subTitle
            self.description = detail.description

            let alertModel = AlertViewModel(title: "Alert from Cell",
                                            message: "Something happened",
                                            actions: [AlertActionViewModel(title: "OK")])

            let events = Driver<CellEvent>.merge(
                reload.asDriver(onErrorJustReturn: ()).map { .reload },
                alert.asDriver(onErrorJustReturn: ()).map { .alert(alertModel) },
                track.asDriver(onErrorJustReturn: ()).map { .track }
            )
            eventResponder.handle(events: events)
        }
    }
}

private func getData() -> [Detail] {
    return [
        Detail(title: "Tax Accountant", subTitle: "Ideal Husband, An", description: "et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est"),
        Detail(title: "Marketing Manager", subTitle: "Stage Fright", description: "amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor"),
        Detail(title: "Physical Therapy Assistant", subTitle: "I Will Buy You (Anata kaimasu)", description: "viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non"),
        Detail(title: "Pharmacist", subTitle: "The Anomaly", description: "egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo"),
        Detail(title: "Civil Engineer", subTitle: "Simple Twist of Fate, A", description: "non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere"),
        Detail(title: "Quality Control Specialist", subTitle: "Oscar and Lucinda (a.k.a. Oscar & Lucinda)", description: "vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci")
    ]
}
