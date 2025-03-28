import Combine
import UIKit

class FilterCollectionViewController: UICollectionViewController {
    private let filterIdentifier = FilterCollectionViewCell.reuseIdentifier
    private let cameraViewModel: CameraViewModel
    private let input = PassthroughSubject<CameraViewModel.Input, Never>()
    private var cancellabes = Set<AnyCancellable>()
    
    init(cameraViewModel: CameraViewModel) {
        self.cameraViewModel = cameraViewModel
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        registerCells()
        bindOutput()
        collectionView.collectionViewLayout = setCollectionViewLayout()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filter.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: filterIdentifier,
            for: indexPath
        ) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let sampleImage = CIImage(image: UIImage(resource: .sample)) ?? CIImage()
        let filter = Filter.allCases[indexPath.item]
        
        guard let filtered = ImageFilterManager.shared.applyFilters(sampleImage, filter: filter) else {
            return UICollectionViewCell()
        }
        
        let image = UIImage(ciImage: filtered)
        
        cell.configureCell(image: image, filter: filter)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = Filter.allCases[indexPath.item]
        input.send(.filterButtonTapped(filter))
    }
    
    private func bindOutput() {
        let _ = cameraViewModel.transform(input: input.eraseToAnyPublisher())
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 100, height: 130)
        layout.sectionInset = .init(top: 0, left: 10, bottom: -10, right: 10)
        return layout
    }
    
    private func registerCells() {
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterIdentifier)
    }
    
    private func configureUI() {
        collectionView.backgroundColor = CameraColor.background.color
        collectionView.showsHorizontalScrollIndicator = false
    }
}
