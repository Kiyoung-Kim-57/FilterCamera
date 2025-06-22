//
//  AppPermission.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/7/25.
//

#import "AppPermission.h"

@implementation AppPermission

+ (void)requestCameraPermission
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"카메라 권한 허용됨");
        } else {
            NSLog(@"카메라 권한 거부됨");
        }
    }];
}

@end
