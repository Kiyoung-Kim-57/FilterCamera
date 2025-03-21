import Foundation
import Combine

final class CameraViewModel {
    private let CameraManager: CameraManager
    private let ImageFilter: ImageFilter
    
    init(CameraManager: CameraManager, ImageFilter: ImageFilter) {
        self.CameraManager = CameraManager
        self.ImageFilter = ImageFilter
    }
}
