//
//  CameraScreenView.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/6/25.
//

#import "CameraScreenView.h"

@implementation CameraScreenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent: 0.8];
    [self.layer setContentsGravity: kCAGravityResizeAspectFill];
    return self;
}

- (void)renderCGImage:(CGImageRef)cgImage {
    if (cgImage == NULL) {
        NSLog(@"경고: NULL CGImageRef가 renderCGImage에 전달되었습니다.");
        return;
    }
    
    // CGImage의 참조 카운트를 증가시켜 안전하게 비동기 작업에서 사용
    CGImageRef imageCopy = CGImageRetain(cgImage);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (imageCopy) {
            self.layer.contents = (__bridge id)imageCopy;
            // 참조 카운트 감소
            CGImageRelease(imageCopy);
        }
    });
}

@end
