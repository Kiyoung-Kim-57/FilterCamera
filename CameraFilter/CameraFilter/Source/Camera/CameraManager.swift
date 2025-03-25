import AVFoundation
import CoreImage
import UIKit

// MARK: 디바이스의 카메라 데이터 처리
final class CameraManager: NSObject {
    private let imageFilterManager: ImageFilterManager
    private var captureSession = AVCaptureSession()
    private var videoDataOutput = AVCaptureVideoDataOutput()
    private var capturedImage: CIImage?
    private var videoView: VideoView?
    
    init(imageFilterManager: ImageFilterManager) {
        self.imageFilterManager = imageFilterManager
    }
    
    func setupCamera(preset: AVCaptureSession.Preset = .photo, view: VideoView) {
        self.captureSession.sessionPreset = preset

        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        ) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: camera)

            setupInput(input)
            setupOutput()
            videoView = view
            videoView?.contentMode = .scaleAspectFill
            
            startSession()
        } catch {
            print("Camera Setting Error: \(error)")
        }
    }
    
    private func setupInput(_ input: AVCaptureDeviceInput) {
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
    }
    
    private func setupOutput() {
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
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
    func takePhoto(scale: CGFloat = 1.0, orientation: UIImage.Orientation = .right) -> UIImage? {
        guard let ciImage = self.capturedImage else { return nil }
        captureSession.stopRunning()
        return UIImage(ciImage: ciImage, scale: scale, orientation: orientation)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            captureSession.startRunning()
        }
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        guard let filtered = imageFilterManager.applyVintageFilter(ciImage: ciImage) else { return }
        capturedImage = filtered
        
        let rotated = filtered.transformed(by: CGAffineTransform(rotationAngle: -.pi / 2))
        let cgImage = imageFilterManager.context.createCGImage(rotated, from: rotated.extent)
        videoView?.renderCGImage(cgImage)
    }
}
