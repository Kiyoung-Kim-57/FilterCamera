import Foundation
import AVFoundation
import UIKit
import CoreImage

// MARK: 디바이스의 카메라 데이터 처리
final class CameraManager {
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
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
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            //레이어가 어떻게 비디오 컨텐츠를 바운드 내에서 표시할지 선택하는 옵션
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = view.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            captureSession.startRunning()
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
        
        context.render(output, to: pixelBuffer)
    }
}
