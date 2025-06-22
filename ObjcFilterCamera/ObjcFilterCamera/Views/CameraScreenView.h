//
//  CameraScreenView.h
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/6/25.
//

#import <UIKit/UIKit.h>

@interface CameraScreenView : UIView

- (void)renderCGImage: (CGImageRef) cgImage;

@end
