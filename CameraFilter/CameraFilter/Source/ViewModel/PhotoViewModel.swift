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
    }
    
    enum Output { }
    
    private var output = PassthroughSubject<Output, Never>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .photoViewDidDeinit:
                    cameraManager.startSession()
                }
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func connectCameraDataToView(view: VideoView) {
        cameraManager.setupCamera(view: view)
    }
}
