//
//  CameraButton.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/1/25.
//

#import <Foundation/Foundation.h>
#import "CameraButton.h"
@implementation CameraButton
{
    UIView * innerCircle;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    [self initViews];
    [self initConstraints];
    
    return self;
}

- (void)initViews
{
    self.layer.borderWidth = 4;
    self.layer.borderColor = UIColor.whiteColor.CGColor;
    
    [self initInnerCircle];
}

- (void)initInnerCircle
{
    innerCircle = [[UIView alloc] init];
    innerCircle.userInteractionEnabled = NO;
    innerCircle.translatesAutoresizingMaskIntoConstraints = NO;
    innerCircle.backgroundColor = UIColor.systemRedColor;
    
    [self addSubview:innerCircle];
    [innerCircle release];
}

- (void)initConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    
    NSArray<NSLayoutConstraint *> *innerCircleConstraints = [self innerCircleConstraints];
    if (innerCircleConstraints != nil)
    {
        [constraints addObjectsFromArray:innerCircleConstraints];
    }
    
    [NSLayoutConstraint activateConstraints: constraints];
}

- (NSArray<NSLayoutConstraint *> *)innerCircleConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    
    [constraints addObject:[innerCircle.widthAnchor constraintEqualToConstant:52.0]];
    [constraints addObject:[innerCircle.heightAnchor constraintEqualToConstant:52.0]];
    [constraints addObject:[innerCircle.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]];
    [constraints addObject:[innerCircle.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]];
    
    return constraints;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.width / 2;
    
    innerCircle.layer.cornerRadius = innerCircle.bounds.size.width / 2;
}

@end
