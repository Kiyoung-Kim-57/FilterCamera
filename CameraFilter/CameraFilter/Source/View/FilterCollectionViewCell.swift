import UIKit
import SnapKit

final class FilterCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String = "FilterCollectionViewCell"
    private let imageView = UIImageView()
    private let filterLabel = UILabel()
    var filter: Filter? = nil
    
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
        [imageView, filterLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(filterLabel.snp.top)
            $0.height.equalTo(contentView.snp.width)
        }
        
        filterLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        filterLabel.textColor = .black
        filterLabel.textAlignment = .center
    }
    
    func configureCell(image: UIImage, filter: Filter) {
        imageView.image = image
        filterLabel.attributedText = NSAttributedString(
            string: filter.rawValue,
            attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .medium)]
        )
        self.filter = filter
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        filterLabel.text = ""
    }
}
