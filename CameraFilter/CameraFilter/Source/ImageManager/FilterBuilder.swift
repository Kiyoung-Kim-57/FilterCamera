import Foundation
import CoreImage

@resultBuilder
struct FilterBuilder {
    static func buildBlock(_ components: CIFilter...) -> CIImage? {
        guard let final = components.first,
              var image = final.outputImage else { return nil }
        
        for component in components.dropFirst() {
            component.setValue(image, forKey: kCIInputImageKey)
            if let output = component.outputImage {
                image = output
            }
        }
        
        return image
    }
}
