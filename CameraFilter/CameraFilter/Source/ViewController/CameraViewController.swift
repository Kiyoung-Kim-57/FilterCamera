import AVFoundation
import UIKit
import Combine
import SnapKit

final class CameraViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
  
    private let cameraBottomView: CameraBottomView
    private let cameraViewModel: CameraViewModel
    private let cameraView = UIView()
    
    private let input = PassthroughSubject<CameraViewModel.Input, Never>()

    init(cameraBottomView: CameraBottomView, cameraViewModel: CameraViewModel) {
        self.cameraBottomView = cameraBottomView
        self.cameraViewModel = cameraViewModel
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.bottomViewHeight)
        }
        
        cameraView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(cameraBottomView.snp.top)
        }
    }
    
    public func configureUI() {
        cameraView.backgroundColor = .clear
    }
    
    public func bindInput() {
        cameraBottomView.cameraButtonTapped
            .sink { [weak self] _ in
            }
            .store(in: &cancellables)
    }
    
    public func bindOutput() {
        let output = cameraViewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .cameraImage(let image):
                    debugPrint("for camera image")
                case .filterState(let filter):
                    debugPrint("for filter state")
                }
            }
            .store(in: &cancellables)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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
