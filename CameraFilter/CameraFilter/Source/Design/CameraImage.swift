import UIKit

public enum CameraImage {
    case filterIcon
    case switchIcon
    
    public var image: UIImage {
        switch self {
        case .filterIcon:
            return UIImage(resource: .filterIcon)
        case .switchIcon:
            return UIImage(resource: .switchIcon)
        }
    }
}
