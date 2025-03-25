import AVFoundation
import UIKit

final class VideoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderCGImage(_ cgImage: CGImage?) {
        DispatchQueue.main.async {
            [weak self] in
            self?.layer.contents = cgImage
        }
    }
}
