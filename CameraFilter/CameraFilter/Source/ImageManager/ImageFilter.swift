import Foundation
import CoreImage

final class ImageFilter {
    func applyVintageFilter(ciImage: CIImage) -> CGImage? {
        let context = CIContext()
        
        @FilterBuilder
        var filteredImage: CIImage? {
            photoEffectTransfer(ciImage: ciImage)
            tonalFilter()
            noiseFilter(rect: ciImage.extent)
            sepiaFilter()
            vignetteFilter(intensity: 1.2, radius: 3.0)
        }
        
        guard let filteredImage else { return nil }
        return context.createCGImage(filteredImage, from: filteredImage.extent)
    }
}

// MARK: Filters
extension ImageFilter {
    private func photoEffectTransfer(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = Filter.photoEffectTransfer.ciFilter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    //덮어씌울 노이즈 레이어 생성
    private func noiseLayer(rect: CGRect) -> CIImage? {
        let filter = Filter.randomGenerator.ciFilter
        let noiseImage = filter.outputImage?.cropped(to: rect)
        return noiseImage
    }
    
    //노이즈 필터
    private func noiseFilter(ciImage: CIImage = CIImage(), rect: CGRect) -> CIFilter {
        let filter = Filter.multiplyBlendMode.ciFilter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(noiseLayer(rect: rect), forKey: kCIInputBackgroundImageKey)
        return filter
    }
    
    // 비네트필터
    private func vignetteFilter(ciImage: CIImage = CIImage(), intensity: CGFloat, radius: CGFloat) -> CIFilter {
        let filter = Filter.vignette.ciFilter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        return filter
    }
    
    // Tonal, 흑백 느와르 필터
    private func tonalFilter(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = Filter.photoEffectTonal.ciFilter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    // SepiaTone
    private func sepiaFilter(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = Filter.sepiaTone.ciFilter
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
}


