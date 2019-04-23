import Foundation
import RxCocoa

struct RxList {
    // MARK: - View input/output
    struct ViewState {
        let title: String
        let dataSource: [CellModel]
    }

    struct ViewEvents {
        let back: Driver<Void>
        let reload: Driver<Void>
        let selectedIndex: Driver<Int>
        let alert: Driver<Void>
    }
    
    // MARK: View model input/output

    struct Context {}
    struct Data {}

    enum Event: EventType {
        case detail(Detail)
    }

    enum CellEvent: EventType {
        case track
        case reload
    }
}
