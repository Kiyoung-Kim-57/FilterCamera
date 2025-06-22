//
//  CameraManager.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/6/25.
//

#import "CameraManager.h"
#import "CameraScreenView.h"
#import "ObjcFilterCamera-Swift.h"

@implementation CameraManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.captureSession = [[AVCaptureSession alloc] init];
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        self.context = [CIContext context];
        self.position = AVCaptureDevicePositionBack;
        self.filterManager = [ImageFilterManager shared];
        self.presentFilter = FilterOriginal; //assign
        
        [_captureSession release];
        [_videoDataOutput release];
    }
    return self;
}

- (void)setupCameraWithView:(CameraScreenView *)view {
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;

    NSError *error = nil;
    [self setDeviceInputWithPosition:self.position error:&error];
    if (error) {
        NSLog(@"Camera Setting Error: %@", error);
        return;
    }

    [self setupOutput];
    self.screenView = view;
    [self startSession];
}

- (void)setupOutput {
    dispatch_queue_t queue = dispatch_queue_create("videoQueue", NULL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:queue];

    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
}

- (void)setDeviceInputWithPosition:(AVCaptureDevicePosition)position error:(NSError **)error {
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                 mediaType:AVMediaTypeVideo
                                                                  position:position];
    if (!camera) return;

    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:error];
    if (*error) return;

    [self.captureSession beginConfiguration];

    if (self.videoDataInput) {
        [self.captureSession removeInput:self.videoDataInput];
    }

    self.videoDataInput = newInput;

    if ([self.captureSession canAddInput:newInput]) {
        [self.captureSession addInput:newInput];
    }

    [self.captureSession commitConfiguration];
}

- (void)startSession {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.captureSession startRunning];
    });
}

- (void)changeDevicePosition {
    self.position = (self.position == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;

    NSError *error = nil;
    [self setDeviceInputWithPosition:self.position error:&error];
    if (error) {
        NSLog(@"Device Setting Error: %@", error);
    }
}

- (UIImage *)takePhoto
{
    if (!self.capturedImage) return nil;

    [self.captureSession stopRunning];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *pngData = [self.context PNGRepresentationOfImage:self.capturedImage format:kCIFormatRGBA8 colorSpace:colorSpace options:@{}];
    CGColorSpaceRelease(colorSpace);
    if (!pngData) return nil;

    return [UIImage imageWithData:pngData];
}

- (void)changeFilter
{
    Filter presentFilter = self.presentFilter;
    if (presentFilter != 3) {
        presentFilter += 1;
    }
    else {
        presentFilter = 0;
    }
    self.presentFilter = presentFilter;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {

    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!pixelBuffer) return;

    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIImage *filtered = [self.filterManager applyFilters:ciImage filter:self.presentFilter];


    if (!filtered) return;

    CIImage *rotated = [filtered imageByApplyingTransform:[self transformForRotation]];
    CIImage *flipped = [self flipImageIfFrontCamera:rotated];
    self.capturedImage = nil;
    self.capturedImage = flipped;

    CGImageRef cgImage = [self.context createCGImage:flipped fromRect:flipped.extent];
    if (self.screenView != nil)
    {
        [self.screenView renderCGImage:cgImage];
    }
    CGImageRelease(cgImage);
}

#pragma mark - Transform Helpers

- (CGAffineTransform)transformForRotation {
    return CGAffineTransformMakeRotation(-M_PI_2);
}

- (CIImage *)flipImageIfFrontCamera:(CIImage *)image {
    if (self.position == AVCaptureDevicePositionFront) {
        CGAffineTransform flip = CGAffineTransformMakeScale(-1, 1);
        return [image imageByApplyingTransform:flip];
    }
    return image;
}

@end
