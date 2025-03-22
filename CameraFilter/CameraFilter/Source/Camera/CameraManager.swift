import Foundation
import AVFoundation
import UIKit
import CoreImage

// MARK: 디바이스의 카메라 데이터 처리
final class CameraManager {
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var capturedImage: CIImage?
    
    func setupCamera(preset: AVCaptureSession.Preset = .photo, view: UIView) {
        self.captureSession.sessionPreset = preset

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: camera)

            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
            }

            DispatchQueue.main.async {
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.videoPreviewLayer.videoGravity = .resizeAspectFill
                self.videoPreviewLayer.frame = view.bounds
                view.layer.addSublayer(self.videoPreviewLayer)
            }

            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }

        } catch {
            print("Camera Setting Error: \(error)")
        }
    }
    //ViewController의 captureOutput 메서드에서 사용
    func adaptCIFilterToFrame(buffer: CMSampleBuffer, context: CIContext, filter: CIFilter?) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else  { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        guard let output = filter?.outputImage else { return }
        
        self.capturedImage = output
        context.render(output, to: pixelBuffer)
    }
    
    // Get Photo from camera
    func takePhoto(scale: CGFloat = 1.0, orientation: UIImage.Orientation = .up) -> UIImage? {
        guard let ciImage = self.capturedImage else { return nil }
        
        return UIImage(ciImage: ciImage, scale: scale, orientation: orientation)
    }
}
