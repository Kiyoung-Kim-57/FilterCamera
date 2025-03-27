import Photos
import UIKit

final class PhotoSaveManager {
    static func savePhoto(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            if let error {
                debugPrint("Error occured while saving photo: \(error.localizedDescription)")
            } else {
                debugPrint("Photo saved successfully!")
            }
        }
    }
}
