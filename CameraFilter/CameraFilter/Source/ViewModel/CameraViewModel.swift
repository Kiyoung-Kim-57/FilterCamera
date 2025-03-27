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
        case switchButtonTapped
    }
    
    enum Output {
        case cameraImage(UIImage)
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
                    changeFilterState(filter)
                case .viewDidLoad(let cameraView):
                    connectCameraDataToView(view: cameraView)
                case .switchButtonTapped:
                    changeCameraPosition()
                }
            }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func publishCameraImage(_ image: UIImage) {
        output.send(.cameraImage(image))
    }
    
    private func changeFilterState(_ filter: Filter) {
        cameraManager.changeFilter(filter: filter)
    }
    
    private func connectCameraDataToView(view: VideoView) {
        cameraManager.setupCamera(view: view)
    }
    
    private func changeCameraPosition() {
        cameraManager.changeDevicePosition()
    }
}
