import Photos
import UIKit

final class PhotoSaveManager {
    @discardableResult
    static func savePhoto(image: UIImage) -> Bool {
        var result = true
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            if let error {
                result = false
                debugPrint("Error occured while saving photo: \(error.localizedDescription)")
            } else {
                result = true
                debugPrint("Photo saved successfully!")
            }
        }
        return result
    }
}
