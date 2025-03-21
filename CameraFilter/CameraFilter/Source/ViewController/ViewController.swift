import UIKit

class ViewController: UIViewController {
    private let imageFilter = ImageFilter()
    private let imageView = UIImageView()
    private let filteredImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let image = UIImage(named: "Sample")
        var filteredImage: UIImage? {
            guard let image, let ciImage = CIImage(image: image) else {
                print("CIImage is Nil")
                return nil
            }
            let cgImage = imageFilter.applyVintageFilter(ciImage: ciImage)
            
            guard let cgImage else { return nil }
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        filteredImageView.contentMode = .scaleAspectFit
        filteredImageView.image = filteredImage
        
        [imageView, filteredImageView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            filteredImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            filteredImageView.widthAnchor.constraint(equalToConstant: 180),
            filteredImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filteredImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

