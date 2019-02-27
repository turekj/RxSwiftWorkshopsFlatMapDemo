import Foundation
import RxDataSources

struct Request: IdentifiableType, Equatable {
    let id: Int
    let url: String
    var status: RequestStatus
    let started: Date
    var finished: Date?

    var identity: Int {
        return id
    }

}
