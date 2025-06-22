//
//  CameraBottomView.h
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/3/25.
//

#import <UIKit/UIKit.h>
@class CameraButton;

@protocol CameraBottomViewDelegate <NSObject>
- (void)filterbutton: (UIButton *) filterButton;
- (void)cameraButton: (CameraButton *) cameraButton;
@end

@interface CameraBottomView : UIView 

@property(nonatomic, assign) id<CameraBottomViewDelegate> delegate;

@end
