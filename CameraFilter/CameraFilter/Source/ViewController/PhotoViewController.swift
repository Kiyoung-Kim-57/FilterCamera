import Combine
import UIKit
import SnapKit

final class PhotoViewController: UIViewController {
    private let photoView = UIImageView()
    private let photoViewModel: PhotoViewModel
    private var input = PassthroughSubject<PhotoViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(image: UIImage, photoViewModel: PhotoViewModel) {
        photoView.image = image
        photoView.contentMode = .scaleAspectFit
        
        self.photoViewModel = photoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        setupConsraints()
        bindOutput()
    }
    
    private func bindOutput() {
        let output = photoViewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { output in }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        [photoView].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupConsraints() {
        photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    deinit {
        input.send(.photoViewDidDeinit)
    }
}
