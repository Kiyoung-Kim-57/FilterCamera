import AVFoundation
import UIKit
import Combine
import SnapKit

final class CameraViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
  
    private let photoRoomBottomView: CameraBottomView
    private let cameraView = UIView()

    init(cameraBottomView: CameraBottomView) {
        self.photoRoomBottomView = cameraBottomView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addViews()
        setupConstraints()
        configureUI()
        bindInput()
        bindOutput()
    }
    
    public func addViews() {
        [photoRoomBottomView, cameraView].forEach {
            view.addSubview($0)
        }
    }
    
    public func setupConstraints() {
        photoRoomBottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Constants.bottomViewHeight)
        }
        
        cameraView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(photoRoomBottomView.snp.top)
        }
    }
    
    public func configureUI() {
        cameraView.backgroundColor = .gray
    }
    
    public func bindInput() {
        photoRoomBottomView.cameraButtonTapped
            .sink { [weak self] _ in
            }
            .store(in: &cancellables)
    }
    
    public func bindOutput() {
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
