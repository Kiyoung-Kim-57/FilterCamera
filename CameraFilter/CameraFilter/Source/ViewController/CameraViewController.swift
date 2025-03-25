import AVFoundation
import Combine
import UIKit
import SnapKit

final class CameraViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
  
    private let cameraBottomView: CameraBottomView
    private let cameraViewModel: CameraViewModel
    private let photoViewModel: PhotoViewModel
    private let cameraView = VideoView()
    
    private let input = PassthroughSubject<CameraViewModel.Input, Never>()

    init(cameraBottomView: CameraBottomView, cameraViewModel: CameraViewModel, photoViewModel: PhotoViewModel) {
        self.cameraBottomView = cameraBottomView
        self.cameraViewModel = cameraViewModel
        self.photoViewModel = photoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addViews()
        setupConstraints()
        configureUI()
        bindInput()
        bindOutput()
        viewDidLoadInput()
    }
    
    private func viewDidLoadInput() {
        input.send(.viewDidLoad(cameraView))
    }
    
    public func addViews() {
        [cameraBottomView, cameraView].forEach {
            view.addSubview($0)
        }
    }
    
    public func setupConstraints() {
        cameraBottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(cameraView.snp.bottom)
        }
        
        cameraView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(4.0 / 3.0)
        }
    }
    
    public func configureUI() {
        view.backgroundColor = CameraColor.background.color
        cameraView.backgroundColor = .clear
    }
    
    public func bindInput() {
        cameraBottomView.cameraButtonTapped
            .sink { [weak self] _ in
                self?.input.send(.cameraButtonTapped)
            }
            .store(in: &cancellables)
    }
    
    public func bindOutput() {
        let output = cameraViewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .cameraImage(let image):
                    let photoViewController = PhotoViewController(image: image, photoViewModel: photoViewModel)
                    navigationController?.pushViewController(photoViewController, animated: true)
                case .filterState(let filter):
                    debugPrint("for filter state")
                }
            }
            .store(in: &cancellables)
    }
}

extension CameraViewController {
    private enum Constants {
        static let bottomViewHeight: CGFloat = 100
        static let navigationHeight: CGFloat = 48
        static let circleButtonSize: CGSize = CGSize(width: 52, height: 52)
        static let micButtonBottomSpacing: CGFloat = -4
        static let micButtonLeadingSpacing: CGFloat = 16
    }
}
