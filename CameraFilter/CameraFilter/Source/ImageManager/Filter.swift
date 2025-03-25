import CoreImage

enum Filter {
    case photoEffectTransfer
    case photoEffectTonal
    case randomGenerator
    case multiplyBlendMode
    case vignette
    case sepiaTone
    
    var ciFilter: CIFilter {
        switch self {
        case .photoEffectTransfer: CIFilter(name: "CIPhotoEffectTransfer")!
        case .photoEffectTonal: CIFilter(name: "CIPhotoEffectTonal")!
        case .randomGenerator: CIFilter(name: "CIRandomGenerator")!
        case .multiplyBlendMode: CIFilter(name: "CIMultiplyBlendMode")!
        case .vignette: CIFilter(name: "CIVignette")!
        case .sepiaTone: CIFilter(name: "CISepiaTone")!
        }
    }
}
