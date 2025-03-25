import UIKit
import SnapKit

final class CameraButton: UIButton {
    private let innerCircle = UIView()
    private let timerLabel = UILabel()
    
    // MARK: init
    init() {
        super.init(frame: .zero)
        
        addViews()
        setupContstraints()
        configureUI()
        
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        [innerCircle, timerLabel].forEach { addSubview($0) }
    }
    
    private func setupContstraints() {
        innerCircle.snp.makeConstraints {
            $0.width.height.equalTo(Constants.innerCircleSize)
            $0.center.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(22)
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = Constants.ringWidth
        
        innerCircle.isUserInteractionEnabled = false
        innerCircle.backgroundColor = .white
        
        timerLabel.text = "3"
        timerLabel.textAlignment = .center
        timerLabel.textColor = .white
        timerLabel.font = .systemFont(ofSize: Constants.timerLabelFontSize, weight: .semibold)
        timerLabel.isHidden = true
    }
    
    func configureTimer(_ count: Int) {
        innerCircle.isHidden = true
        timerLabel.isHidden = false
    }
    
    func stopTimer() {
        innerCircle.isHidden = false
        timerLabel.isHidden = true
    }
    
    // MARK: 터치 시 카메라 버튼 색상 변경
    private func setActions() {
        self.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.innerCircle.backgroundColor = .systemGray4
        }, for: .touchDown)
        
        self.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.innerCircle.backgroundColor = .white
        }, for: [.touchCancel, .touchUpOutside, .touchUpInside])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        
        innerCircle.layer.cornerRadius = innerCircle.bounds.width / 2
    }
}

extension CameraButton {
    enum Constants {
        fileprivate static let ringWidth: CGFloat = 4
        fileprivate static let innerCircleSize: CGFloat = 52
        fileprivate static let ellipsisWidth: CGFloat = 34
        fileprivate static let ellipsisHeight: CGFloat = 6
        fileprivate static let timerLabelSize: CGFloat = 22
        fileprivate static let timerLabelFontSize: CGFloat = 28
        
        static let buttonSize: CGFloat = 64
    }
}
