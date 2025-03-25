import Combine
import UIKit

final class CameraViewModel {
    private let cameraManager: CameraManager
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraManager: CameraManager) {
        self.cameraManager = cameraManager
    }
    
    // MARK: Input-Output
    enum Input {
        case viewDidLoad(VideoView)
        case cameraButtonTapped
        case filterButtonTapped(Filter)
        case photoViewDidDeinit
    }
    
    enum Output {
        case cameraImage(UIImage)
        case filterState(Filter)
    }
    
    private var output = PassthroughSubject<Output, Never>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .cameraButtonTapped:
                    publishCameraImage(cameraManager.takePhoto() ?? UIImage())
                case .filterButtonTapped(let filter):
                    publishFilterState(filter)
                case .viewDidLoad(let cameraView):
                    connectCameraDataToView(view: cameraView)
                case .photoViewDidDeinit:
                    cameraManager.startSession()
                }
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func publishCameraImage(_ image: UIImage) {
        output.send(.cameraImage(image))
    }
    
    private func publishFilterState(_ filter: Filter) {
        output.send(.filterState(filter))
    }
    
    private func connectCameraDataToView(view: VideoView) {
        cameraManager.setupCamera(view: view)
    }
}
