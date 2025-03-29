import AVFoundation
import Combine
import UIKit
import SnapKit

final class CameraViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let filterCollectionViewController: FilterCollectionViewController
    private let cameraBottomView: CameraBottomView
    private let cameraViewModel: CameraViewModel
    private let photoViewModel: PhotoViewModel
    private let cameraView = VideoView()
    private let closeButton = UIButton()
    private var isCaptured: Bool = false
    
    private let cameraInput = PassthroughSubject<CameraViewModel.Input, Never>()
    private let photoInput = PassthroughSubject<PhotoViewModel.Input, Never>()
    
    init(
        filterCollectionViewController: FilterCollectionViewController,
        cameraBottomView: CameraBottomView,
        cameraViewModel: CameraViewModel,
        photoViewModel: PhotoViewModel
    ) {
        self.filterCollectionViewController = filterCollectionViewController
        self.cameraBottomView = cameraBottomView
        self.cameraViewModel = cameraViewModel
        self.photoViewModel = photoViewModel
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
        applyTransform()
    }
    
    private func viewDidLoadInput() {
        cameraInput.send(.viewDidLoad(cameraView))
    }
    
    private func addViews() {
        [filterCollectionViewController].forEach { vc in
            addChild(vc)
        }
        
        [cameraBottomView, cameraView, filterCollectionViewController.view, closeButton].forEach {
            view.addSubview($0)
        }
        
        [filterCollectionViewController].forEach { vc in
            vc.didMove(toParent: self)
        }
    }
    
    private func setupConstraints() {
        cameraBottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(cameraView.snp.bottom)
        }
        
        cameraView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(4.0 / 3.0)
        }
        
        filterCollectionViewController.view.snp.makeConstraints {
            $0.bottom.equalTo(closeButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(cameraView.snp.bottom)
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(80)
            $0.width.equalTo(80)
            $0.leading.equalTo(view.snp.leading).inset(10)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = CameraColor.background.color
        cameraView.backgroundColor = .black
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(systemName: "chevron.down")
        buttonConfig.preferredSymbolConfigurationForImage = .init(pointSize: 24, weight: .medium)
        buttonConfig.baseForegroundColor = .black
        closeButton.configuration = buttonConfig
    }
    
    private func bindInput() {
        cameraBottomView.cameraButtonTapped
            .throttle(for: .seconds(2.0), scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                self?.cameraInput.send(.cameraButtonTapped)
            }
            .store(in: &cancellables)
        
        cameraBottomView.filterButtonTapped
            .sink { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.restoreTransform()
                }
            }
            .store(in: &cancellables)
        
        cameraBottomView.switchButtonTapped
            .sink { [weak self] _ in
                self?.cameraInput.send(.switchButtonTapped)
            }
            .store(in: &cancellables)
        
        closeButton.tapPublisher
            .sink { [weak self] _ in
                UIView.animate(withDuration: 0.3) {
                    self?.applyTransform()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindOutput() {
        let cameraOutput = cameraViewModel.transform(input: cameraInput.eraseToAnyPublisher())
        let photoOutput = photoViewModel.transform(input: photoInput.eraseToAnyPublisher())
        
        cameraOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .cameraImage(let image):
                    guard !isCaptured else { return }
                    let photoViewController = PhotoViewController(image: image, photoViewModel: photoViewModel)
                    navigationController?.pushViewController(photoViewController, animated: true)
                    isCaptured = true
                }
            }
            .store(in: &cancellables)
        
        photoOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .didDeinit: self.isCaptured = false
                case .failAlert: return
                case .successAlert: return
                }
            }
            .store(in: &cancellables)
    }
    
    private func applyTransform() {
        [filterCollectionViewController.view, closeButton].forEach {
            $0?.transform = CGAffineTransform(translationX: 0, y: 300)
        }
    }
    
    private func restoreTransform() {
        [filterCollectionViewController.view, closeButton].forEach {
            $0?.transform = .identity
        }
    }
}
