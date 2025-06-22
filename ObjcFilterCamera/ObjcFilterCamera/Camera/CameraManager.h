//
//  CameraManager.h
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/6/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>
#import "ObjcFilterCamera-Swift.h"

@class CameraScreenView;

@interface CameraManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)setupCameraWithView:(CameraScreenView *_Nonnull)view;
- (void)startSession;
- (void)changeDevicePosition;
- (nullable UIImage *)takePhoto;
- (void)changeFilter;

@property (nonatomic, retain) ImageFilterManager * _Nonnull filterManager;
@property (nonatomic, retain) AVCaptureSession * _Nonnull captureSession;
@property (nonatomic, retain) AVCaptureVideoDataOutput * _Nonnull videoDataOutput;
@property (nonatomic, retain) AVCaptureDeviceInput * _Nonnull videoDataInput;
@property (nonatomic, retain) CIImage * _Nullable capturedImage;
@property (nonatomic, retain) CameraScreenView * _Nonnull screenView;
@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, retain) CIContext * _Nonnull context;
@property (nonatomic, assign) Filter presentFilter;

@end
