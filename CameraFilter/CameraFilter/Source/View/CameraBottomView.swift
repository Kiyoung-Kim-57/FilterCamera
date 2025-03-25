import Combine
import UIKit
import SnapKit

final class CameraBottomView: UIView {
    private let filterButton = UIButton()
    private let switchCameraButton = UIButton()
    private let cameraButton: CameraButton
    
    var cameraButtonTapped: AnyPublisher<Void, Never> {
        cameraButton.tapPublisher
            .eraseToAnyPublisher()
    }
    
    // MARK: init
    init() {
        self.cameraButton = CameraButton()
        super.init(frame: .zero)
        
        addViews()
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        [filterButton, switchCameraButton, cameraButton].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        filterButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.iconButtonSize)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.bottomLeadingSpacing)
        }
        
        switchCameraButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.iconButtonSize)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Constants.bottomTrailingSpacing)
        }
        
        cameraButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(CameraButton.Constants.buttonSize)
        }
    }
    
    private func configureUI() {
        backgroundColor = CameraColor.background.color
        filterButton.setImage(CameraImage.filterIcon.image, for: .normal)
        
        switchCameraButton.setImage(CameraImage.switchIcon.image, for: .normal)
    }
    
    func setCameraButtonTimer(_ count: Int) {
        cameraButton.configureTimer(count)
    }
    
    func stopCameraButtonTimer() {
        cameraButton.stopTimer()
    }
    
    func highlightCameraButton() {
//        cameraButton.layer.borderColor = PTGColor.primaryGreen.color.cgColor
    }
}

extension CameraBottomView {
    private enum Constants {
        static let iconButtonSize: CGFloat = 40
        static let bottomLeadingSpacing: CGFloat = 53
        static let bottomTrailingSpacing: CGFloat = 53
    }
}
