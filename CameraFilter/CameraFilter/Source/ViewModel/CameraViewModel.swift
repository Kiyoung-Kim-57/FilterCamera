import UIKit
import Combine

final class CameraViewModel {
    private let cameraManager: CameraManager
    private let imageFilter: ImageFilter
    private var cancellables = Set<AnyCancellable>()
    
    init(cameraManager: CameraManager, imageFilter: ImageFilter) {
        self.cameraManager = cameraManager
        self.imageFilter = imageFilter
    }
    
    // MARK: Input-Output
    enum Input {
        case viewDidLoad(UIView)
        case cameraButtonTapped
        case filterButtonTapped(Filter)
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
                    publishCameraImage(UIImage())
                case .filterButtonTapped(let filter):
                    publishFilterState(filter)
                case .viewDidLoad(let cameraView):
                    connectCameraDataToView(view: cameraView)
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
    
    private func connectCameraDataToView(view: UIView) {
        cameraManager.setupCamera(view: view)
    }
}
