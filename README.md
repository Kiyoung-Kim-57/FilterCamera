# App
This camera app applies filters to the live camera feed in real time. 
Users can select different filters, save the captured photos, and share them easily.
### Tech
#UIKit #Combine #AVFoundation #CoreImage #MVVM
### Features

|Camera|Filter|Save&Share|
|--------|-----|------------|
|<img src="https://i.imgur.com/UYAY1vZ.png" width="200">|<img src="https://i.imgur.com/t47nGDn.png" width="200"> |<img src="https://i.imgur.com/IpUOQHa.png" width="200">|

### GIF
<img src="https://i.imgur.com/u4gFhYu.gif" width="200"> 


# Develop
## Custom Camera With AVFoundation
### Structure of Camera Manager
![](https://i.imgur.com/AqzEYmb.png)
1. **AVCaptureDevice**(Camera) sends data to **AVCaptureDeviceInput**
2. The Input sends video data to **AVCaptureVideoOuput**
3. The Output conforms to `AVCaptureVideoDataOutputSampleBufferDelegate` to use `captureOutput` method which is used for handling **CMSampleBuffer** from the output. 
4. CameraManager uses **ImageFilterManager** to apply CIFilters to CMSampleBuffer
5. CameraManager renders **CGImage** with filtered CIImage from ImageFilterManager
6. CameraManager sets the `contents` of the **VideoView**'s layer to render the layer with CGImage
7. CameraManager uses `capturedImage` when taking a photo(`capturedImage` is updated on every frame update)

## FilterBuilder
- This resultBuilder makes easier to connect CIFilter chaining.
```swift
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
```

#### Before
```swift
// Before
func applyFilters(to image: CIImage) -> CIImage? {
    // 1️⃣ Apply sepiaTone filter
    let sepiaFilter = CIFilter(name: "CISepiaTone")
    sepiaFilter?.setValue(image, forKey: kCIInputImageKey)
    sepiaFilter?.setValue(0.8, forKey: kCIInputIntensityKey)

    guard let sepiaOutput = sepiaFilter?.outputImage else { return nil }

    // 2️⃣ Add vignette effect
    let vignetteFilter = CIFilter(name: "CIVignette")
    vignetteFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
    vignetteFilter?.setValue(1.5, forKey: kCIInputIntensityKey)
    vignetteFilter?.setValue(2.0, forKey: kCIInputRadiusKey)

    return vignetteFilter?.outputImage // 🎨 최종 CIImage (레시피)
}
```

#### After
```swift
// After
func applyFilters(to image: CIImage) -> CIImage? {
	@FilterBuilder
	var filteredImage: CIImage? {
		sepiaFilter(ciImage: image)
		vignetteFilter(intensity: 1.2, radius: 3.0)
	}
	
	return filteredImage
}

// Filter Method Example
private func sepiaFilter(ciImage: CIImage = CIImage()) -> CIFilter {
	let filter = Filter.sepiaTone.ciFilter
	filter.setValue(ciImage, forKey: kCIInputImageKey)
	return filter
}
```

## Issues
### Failed to save photo
1. Although all permission were granted, I failed to save the photo.
2. The reason I failed to save it was that the UIImage I tried to save was not in png or jpg format.(PhotoLibrary requires jpg, png format)
3.  To save an image in my photo library, image must be in png or jpg format.
4. So, I improved the photo capture function by rendering the UIImage with PNG data.
#### Improved code
```swift
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
```

### AVCaptureVideoPreviewLayer
### Failed to apply filters to the live camera feed
1. At the first time, I used `AVCaptureVideoPreviewLayer` to render video data on the screen
2. After setting `captureOutput` delegate method, I realize that filtering is not working on the camera
3. The reason was that the `AVCaptureVideoPreviewLayer` just render input data directly whatever I do on `captureOuput` method.
4. So I made VideoView which is subclass of UIView and render data on its layer and replace # `AVCaptureVideoPreviewLayer` with VideoView
```swift
final class VideoView: UIView {
	//...init...
    func renderCGImage(_ cgImage: CGImage?) {
        DispatchQueue.main.async {
            [weak self] in
            self?.layer.contents = cgImage
        }
    }
}

// CameraManager.swift
func captureOutput(_ output: AVCaptureOutput, 
					didOutput sampleBuffer: CMSampleBuffer, 
					from connection: AVCaptureConnection) {
	guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) 
	else { return }
	// ...
	videoView?.renderCGImage(cgImage)
}
```
