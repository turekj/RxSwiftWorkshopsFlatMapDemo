import UIKit

enum RequestStatus: String {
    case pending = "Pending..."
    case cancelled = "Cancelled"
    case finished = "200 OK"
}

extension RequestStatus {

    var color: UIColor {
        switch self {
        case .pending:
            return .black
        case .cancelled:
            return .red
        case .finished:
            return .green
        }
    }

}
