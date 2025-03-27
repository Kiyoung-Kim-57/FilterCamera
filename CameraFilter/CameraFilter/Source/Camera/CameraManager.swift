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
    private var context = CIContext()
    
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
        
        guard let pngData = context.pngRepresentation(
            of: ciImage,
            format: CIFormat.RGBA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        ) else { return nil }
        
        return UIImage(data: pngData)
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
        let rotated = filtered.transformed(by: Transform.rotate90.affine)
        let flipped = flipImageWhenFrontCamera(rotated)
        capturedImage = flipped
        let cgImage = imageFilterManager.context.createCGImage(flipped, from: flipped.extent)
        videoView?.renderCGImage(cgImage)
    }
    
    private func flipImageWhenFrontCamera(_ image: CIImage) -> CIImage {
        let transform = Transform.horizontalFlip.affine
        return (position == .front) ? image.transformed(by: transform) : image
    }
}

extension CameraManager {
    enum Transform {
        case rotate90
        case horizontalFlip
        
        var affine: CGAffineTransform {
            switch self {
            case .rotate90:
                CGAffineTransform(rotationAngle: -.pi / 2)
            case .horizontalFlip:
                CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
}
