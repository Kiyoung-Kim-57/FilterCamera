import AVFoundation
import CoreImage
import Combine
import UIKit

final class CameraManager: NSObject {
    private let imageFilterManager: ImageFilterManager
    private var captureSession = AVCaptureSession()
    private var videoDataOutput = AVCaptureVideoDataOutput()
    private var videoDataInput: AVCaptureDeviceInput?
    private var capturedImage: CIImage?
    private var videoView: VideoView?
    private var presentFilter: Filter = .original
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var position: AVCaptureDevice.Position = .back
    
    init(imageFilterManager: ImageFilterManager) {
        self.imageFilterManager = imageFilterManager
        super.init()
        bindDevicePosition()
    }
    
    // Get Photo from camera
    func takePhoto(scale: CGFloat = 1.0, orientation: UIImage.Orientation = .right) -> UIImage? {
        guard let ciImage = capturedImage else { return nil }
        captureSession.stopRunning()
        return UIImage(ciImage: ciImage, scale: scale, orientation: orientation)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            captureSession.startRunning()
        }
    }
    
    func changeFilter(filter: Filter) {
        presentFilter = filter
    }
    
    func changeDevicePosition() {
         position = (position == .back) ? .front : .back
    }
}

// Set Up
extension CameraManager {
    func setupCamera(preset: AVCaptureSession.Preset = .photo, view: VideoView) {
        self.captureSession.sessionPreset = .photo
        
        do {
            try setDeviceInput(position: .back)
            setupOutput()
            videoView = view
            startSession()
        } catch {
            print("Camera Setting Error: \(error)")
        }
    }
    
    private func setupOutput() {
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
    }
    
    private func setDeviceInput(position: AVCaptureDevice.Position) throws {
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) else { return }
        
        let newInput = try AVCaptureDeviceInput(device: camera)
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
            startSession()
        }
        
        if let input = videoDataInput {
            captureSession.removeInput(input)
        }
        
        videoDataInput = newInput
        
        if captureSession.canAddInput(newInput) {
            captureSession.addInput(newInput)
        }
    }
    
    private func bindDevicePosition() {
        $position
            .sink { [weak self] position in
                do {
                    try self?.setDeviceInput(position: position)
                } catch {
                    print("Device Setting Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        guard let filtered = imageFilterManager.applyFilters(ciImage, filter: self.presentFilter) else { return }
        capturedImage = filtered
        let rotated = filtered.transformed(by: CGAffineTransform(rotationAngle: -.pi / 2))
        let flipped = flipImageWhenFrontCamera(rotated)
        let cgImage = imageFilterManager.context.createCGImage(flipped, from: flipped.extent)
        videoView?.renderCGImage(cgImage)
    }
    
    private func flipImageWhenFrontCamera(_ image: CIImage) -> CIImage {
        return (position == .front) ? image.transformed(by: CGAffineTransform(scaleX: -1, y: 1)) : image
    }
}
