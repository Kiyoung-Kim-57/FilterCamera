//
//  CameraBottomView.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 5/3/25.
//

#import "CameraBottomView.h"
#import "CameraButton.h"

@implementation CameraBottomView
{
    UIButton *filterButton;
    CameraButton *cameraButton;
    
    UIImage *filterIcon;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    // 초기화 작업
    // 크기 설정을 위한 configuration 생성
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:40.0 weight:UIImageSymbolWeightMedium scale:UIImageSymbolScaleLarge];
    
    filterIcon = [UIImage systemImageNamed:@"camera.filters" withConfiguration:config];
    
    [self initViews];
    [self initConstraints];
    
    return self;
}

- (void)initViews
{
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    [self initFilterButton];
    [self initCameraButton];
}

- (void)initFilterButton
{
    
    filterButton = [[UIButton alloc] init];
    filterButton.translatesAutoresizingMaskIntoConstraints = NO;
    filterButton.contentMode = UIViewContentModeScaleAspectFill;
    filterButton.tintColor = UIColor.orangeColor;
    [filterButton setImage:filterIcon forState: UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:filterButton];
    [filterButton release];
}

- (void)initCameraButton
{
    cameraButton = [[CameraButton alloc] init];
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cameraButton addTarget:self action:@selector(cameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraButton];
    [cameraButton release];
}

- (void)initConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    
    NSArray<NSLayoutConstraint *> *filterButtonConstraints = [self filterButtonConstraints];
    if (filterButtonConstraints != nil)
    {
        [constraints addObjectsFromArray:filterButtonConstraints];
    }
    
    NSArray<NSLayoutConstraint *> *cameraButtonConstraints = [self cameraButtonConstraints];
    if (cameraButtonConstraints != nil)
    {
        [constraints addObjectsFromArray:cameraButtonConstraints];
    }
    
    [NSLayoutConstraint activateConstraints: constraints];
}

- (NSArray<NSLayoutConstraint *> *)filterButtonConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[filterButton.heightAnchor constraintEqualToConstant:40.0]];
    [constraints addObject:[filterButton.widthAnchor constraintEqualToConstant:40.0]];
    [constraints addObject:[filterButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]];
    [constraints addObject:[filterButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:53.0]];

    return constraints;
}

- (NSArray<NSLayoutConstraint *> *)cameraButtonConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[cameraButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]];
    [constraints addObject:[cameraButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]];
    [constraints addObject:[cameraButton.heightAnchor constraintEqualToConstant:56.0]];
    [constraints addObject:[cameraButton.widthAnchor constraintEqualToConstant:56.0]];
    
    return constraints;
}

- (void)cameraButtonTapped: (CameraButton *)cameraButton
{
    if ([_delegate respondsToSelector:@selector(cameraButton:)]) {
        [_delegate cameraButton:cameraButton];
    }
}

- (void)filterButtonTapped: (UIButton *)filterButton
{
    if ([_delegate respondsToSelector:@selector(filterbutton:)]) {
        [_delegate filterbutton:filterButton];
    }
}

@end
