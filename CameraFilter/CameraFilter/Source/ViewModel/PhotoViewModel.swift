import Combine
import UIKit

final class PhotoViewModel {
    private let cameraManager: CameraManager
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    // MARK: Input-Output
    enum Input {
        case photoViewDidDeinit
        case saveButtonTapped(UIImage)
    }
    
    enum Output {
        case successAlert
        case failAlert
        case didDeinit
    }
    
    private var output = PassthroughSubject<Output, Never>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .photoViewDidDeinit:
                    cameraManager.startSession()
                    output.send(.didDeinit)
                case .saveButtonTapped(let image):
                    saveImageToPhotoLibrary(image: image)
                }
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func connectCameraDataToView(view: VideoView) {
        cameraManager.setupCamera(view: view)
    }
    
    private func saveImageToPhotoLibrary(image: UIImage) {
        
        if PhotoSaveManager.savePhoto(image: image) {
            output.send(.successAlert)
        } else {
            output.send(.failAlert)
        }
    }
}
