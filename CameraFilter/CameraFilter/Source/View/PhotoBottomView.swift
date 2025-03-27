import Combine
import UIKit
import SnapKit

final class PhotoBottomView: UIView {
    private let saveButton = UIButton()
    private let shareButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var saveButtonTapped: AnyPublisher<Void, Never> {
        saveButton.tapPublisher
            .eraseToAnyPublisher()
    }
    
    var shareButtonTapped: AnyPublisher<Void, Never> {
        shareButton.tapPublisher
            .eraseToAnyPublisher()
    }
    
    private func addViews() {
        [saveButton, shareButton].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        saveButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(53)
            $0.height.width.equalTo(70)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(53)
            $0.height.width.equalTo(70)
        }
    }
    
    private func configureUI() {
        backgroundColor = CameraColor.background.color
        
        var saveButtonConfig = UIButton.Configuration.plain()
        saveButtonConfig.image = UIImage(systemName: "square.and.arrow.down")
        saveButtonConfig.preferredSymbolConfigurationForImage = .init(pointSize: 30, weight: .medium)
        saveButtonConfig.imagePlacement = .top
        saveButtonConfig.imagePadding = 10
        saveButtonConfig.baseForegroundColor = .darkGray
        saveButtonConfig.title = "Save"
        saveButton.configuration = saveButtonConfig
        
        var shareButtonConfig = UIButton.Configuration.plain()
        shareButtonConfig.image = UIImage(systemName: "square.and.arrow.up")
        shareButtonConfig.preferredSymbolConfigurationForImage = .init(pointSize: 30, weight: .medium)
        shareButtonConfig.imagePlacement = .top
        shareButtonConfig.imagePadding = 10
        shareButtonConfig.baseForegroundColor = .darkGray
        shareButtonConfig.title = "Share"
        shareButton.configuration = shareButtonConfig
    }
}
