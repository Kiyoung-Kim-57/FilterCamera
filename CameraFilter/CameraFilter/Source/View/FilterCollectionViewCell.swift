import UIKit
import SnapKit

final class FilterCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let filterLabel = UILabel()
    private var sampleImage = UIImage(resource: .sample)
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupConstraints()
        configureUI()
    }
    
    private func addViews() {
        [imageView, filterLabel].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(filterLabel.snp.top)
        }
        
        filterLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFill
    }
    
    func configureCell() {
        
    }
}
