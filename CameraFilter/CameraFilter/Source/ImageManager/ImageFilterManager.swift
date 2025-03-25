import CoreImage
import CoreImage.CIFilterBuiltins

final class ImageFilterManager {
    let context = CIContext()
    
    func applyFilters(_ ciImage: CIImage, filter: Filter) -> CIImage? {
        switch filter {
        case .original:
            return ciImage
        case .vintage:
            return applyVintageFilter(ciImage: ciImage)
        case .noir:
            return applyNoirFilter(ciImage: ciImage)
        case .bloom:
            return applyBloomFilter(ciImage: ciImage)
        }
    }
    
    func applyVintageFilter(ciImage: CIImage) -> CIImage? {
        @FilterBuilder
        var filteredImage: CIImage? {
            photoEffectTransfer(ciImage: ciImage)
            noiseFilter(rect: ciImage.extent)
            sepiaFilter()
            vignetteFilter(intensity: 1.5, radius: 3.0)
        }
        
        return filteredImage
    }
    
    func applyNoirFilter(ciImage: CIImage) -> CIImage? {
        @FilterBuilder
        var filteredImage: CIImage? {
            noirFilter(ciImage: ciImage)
            vignetteFilter(intensity: 1.2, radius: 3.0)
        }
        return filteredImage
    }
    
    func applyBloomFilter(ciImage: CIImage) -> CIImage? {
        @FilterBuilder
        var filteredImage: CIImage? {
            photoEffectTransfer(ciImage: ciImage)
            sepiaFilter()
            bloomFilter()
        }
        return filteredImage
    }
}

// MARK: Filters
extension ImageFilterManager {
    private func photoEffectTransfer(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = CIFilter.photoEffectTransfer()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    //덮어씌울 노이즈 레이어 생성
    private func noiseLayer(rect: CGRect) -> CIImage? {
        let filter = CIFilter.randomGenerator()
        let noiseImage = filter.outputImage?.cropped(to: rect)
        return noiseImage
    }
    
    //노이즈 필터
    private func noiseFilter(ciImage: CIImage = CIImage(), rect: CGRect) -> CIFilter {
        let filter = CIFilter.multiplyBlendMode()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(noiseLayer(rect: rect), forKey: kCIInputBackgroundImageKey)
        return filter
    }
    
    // 비네트필터
    private func vignetteFilter(ciImage: CIImage = CIImage(), intensity: CGFloat, radius: CGFloat) -> CIFilter {
        let filter = CIFilter.vignette()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        return filter
    }
    
    // Tonal, 흑백 느와르 필터
    private func tonalFilter(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = CIFilter.photoEffectTonal()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    // SepiaTone
    private func sepiaFilter(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = CIFilter.sepiaTone()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    //Noir
    private func noirFilter(ciImage: CIImage = CIImage()) -> CIFilter {
        let filter = CIFilter.photoEffectNoir()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        return filter
    }
    
    // Bloom
    private func bloomFilter(
        ciImage: CIImage = CIImage(),
        radius: CGFloat = 10,
        intensity: CGFloat = 0.5
    ) -> CIFilter {
        let filter = CIFilter.bloom()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        filter.setValue(intensity, forKey: kCIInputIntensityKey)
        return filter
    }
}


