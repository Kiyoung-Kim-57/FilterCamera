import AVFoundation
import Photos

enum AppPermissionManager {
    static func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("카메라 권한 허용됨")
            } else {
                print("카메라 권한 거부됨")
            }
        }
    }
    
    static func requestMicrophonePermission() {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            if granted {
                print("마이크 권한 허용됨")
            } else {
                print("마이크 권한 거부됨")
            }
        }
    }
    
    static func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .limited:
                print("limited")
            @unknown default:
                fatalError()
            }
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .limited:
                print("limited")
            @unknown default:
                fatalError()
            }
        }
    }
    
    static func checkPhotoLibraryAuthorizationStatus() -> Bool {
        return PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
    }
}
