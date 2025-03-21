import UIKit

public enum CameraImage {
    case frameIcon
    case chevronLeftWhite
    case chevronRightBlack
    case filterIcon
    case switchIcon
    case ellipsisIcon
    case xmark
    
    public var image: UIImage {
        switch self {
        case .frameIcon:
            return UIImage(resource: .frameIcon)
        case .chevronLeftWhite:
            return UIImage(resource: .chevronLeftWhite)
        case .chevronRightBlack:
            return UIImage(resource: .chevronRightBlack)
        case .filterIcon:
            return UIImage(resource: .filterIcon)
        case .switchIcon:
            return UIImage(resource: .switchIcon)
        case .ellipsisIcon:
            return UIImage(resource: .ellipsisIcon)
        case .xmark:
            return UIImage(resource: .xmark)
        }
    }
}
