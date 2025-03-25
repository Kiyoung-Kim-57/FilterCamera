import UIKit

enum CameraColor {
    case background
    
    var color: UIColor {
        switch self {
        case .background: UIColor(resource: .background)
        }
    }
}
