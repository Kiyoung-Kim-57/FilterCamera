import Combine
import UIKit
import SnapKit

final class PhotoViewController: UIViewController {
    private var photo = UIImage()
    private let photoView = UIImageView()
    private let photoViewModel: PhotoViewModel
    private let photoBottomView = PhotoBottomView()
    private var input = PassthroughSubject<PhotoViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(image: UIImage, photoViewModel: PhotoViewModel) {
        photo = image
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
        view.backgroundColor = CameraColor.background.color
        setupView()
        setupConsraints()
        bindOutput()
        bindInput()
        configureUI()
    }
    
    private func bindInput() {
        photoBottomView.saveButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                if AppPermissionManager.checkPhotoLibraryAuthorizationStatus()
                {
                    self.input.send(.saveButtonTapped(self.photo))
                } else {
                    self.showAlertForPhotoLibraryPermission()
                }
            }
            .store(in: &cancellables)
        
        photoBottomView.shareButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                self.showActivityViewController(image: self.photo)
            }
            .store(in: &cancellables)
    }
    
    private func bindOutput() {
        let output = photoViewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .successAlert:
                    self?.showAlertSavedSuccess()
                case .failAlert:
                    self?.showAlertSaveFailed()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        [photoView, photoBottomView].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupConsraints() {
        photoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(4.0 / 3.0)
        }
        
        photoBottomView.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(photoView.snp.bottom)
        }
    }
    
    private func configureUI() {
        photoView.backgroundColor = .darkGray
    }
    
    private func showActivityViewController(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    deinit {
        input.send(.photoViewDidDeinit)
    }
}

// MARK: Alerts
extension PhotoViewController {
    private func showAlertForPhotoLibraryPermission() {
        let alertController = UIAlertController(
            title: "Please grant access permission to save the photo.",
            message: "Please go to the following path to grant permission: Settings > Apps > CameraFilter.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Setting", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        present(alertController, animated: true)
    }
    
    private func showAlertForNoImage() {
        let alertController = UIAlertController(
            title: "The captured photo does not exist.",
            message: "Please go back to the camera and take the photo again.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive))
        present(alertController, animated: true)
    }
    
    private func showAlertSavedSuccess() {
        let alertController = UIAlertController(
            title: "The photo has been successfully saved.",
            message: "The saved photo can be found in the album.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Confirm", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showAlertSaveFailed() {
        let alertController = UIAlertController(
            title: "Failed to save the photo.",
            message: "Please contact the developer.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Confirm", style: .cancel))
        present(alertController, animated: true)
    }
}
