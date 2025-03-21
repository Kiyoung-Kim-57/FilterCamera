import UIKit
import Combine

final class CameraViewModel {
    private let CameraManager: CameraManager
    private let ImageFilter: ImageFilter
    private var cancellables = Set<AnyCancellable>()
    
    init(CameraManager: CameraManager, ImageFilter: ImageFilter) {
        self.CameraManager = CameraManager
        self.ImageFilter = ImageFilter
    }
    
    // MARK: Input-Output
    enum Input {
        case cameraButtonTapped
        case filterButtonTapped(Filter)
    }
    
    enum Output {
        case cameraImage(UIImage)
        case filterState(Filter)
    }
    
    private var output = PassthroughSubject<Output, Never>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            guard let self else { return }
            
            switch input {
            case .cameraButtonTapped:
                publishCameraImage(UIImage())
            case .filterButtonTapped(let filter):
                publishFilterState(filter)
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
}
