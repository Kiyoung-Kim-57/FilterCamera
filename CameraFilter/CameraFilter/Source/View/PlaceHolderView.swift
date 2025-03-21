import UIKit
import SnapKit

public final class PlaceHolderView: UIView {
    private let label = UILabel()
    
    public init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setText(_ text: String) {
        self.label.text = text
    }
    
    private func addViews() {
        self.addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        self.backgroundColor = .gray.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
    }
}
