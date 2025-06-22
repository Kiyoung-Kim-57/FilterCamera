//
//  ViewController.m
//  ObjcFilterCamera
//
//  Created by 김기영 on 4/28/25.
//

#import "ViewControllers.h"
#import "Views.h"
#import "CameraManager.h"


@implementation ViewController
{
    CameraBottomView *bottomView;
    CameraScreenView *screenView;
    CameraManager *cameraManager;
    UIImageView *photoImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.cyanColor;
    
    [self initView];
    [self initConstraints];
    cameraManager = [[CameraManager alloc] init];
    [cameraManager setupCameraWithView:screenView];
}

- (void)initView
{
    [self initCameraBottomView];
    [self initCameraScreenView];
}

- (void)initCameraBottomView
{
    bottomView = [[CameraBottomView alloc] initWithFrame:CGRectZero];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [bottomView release];
}

- (void)initCameraScreenView
{
    screenView = [[CameraScreenView alloc] initWithFrame:CGRectZero];
    screenView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:screenView];
    [screenView release];
}

- (void)initConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    
    NSArray<NSLayoutConstraint *> *cameraBottomViewConstraints = [self cameraBottomViewConstraints];
    if (cameraBottomViewConstraints != nil)
    {
        [constraints addObjectsFromArray:cameraBottomViewConstraints];
    }
    
    NSArray<NSLayoutConstraint *> *cameraScreenViewConstraints = [self cameraScreenViewConstraints];
    if (cameraScreenViewConstraints != nil)
    {
        [constraints addObjectsFromArray:cameraScreenViewConstraints];
    }
    
    [NSLayoutConstraint activateConstraints: constraints];
}

- (NSArray<NSLayoutConstraint *> *)cameraBottomViewConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[bottomView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor]];
    [constraints addObject:[bottomView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor]];
    [constraints addObject:[bottomView.heightAnchor constraintEqualToConstant:250.0]];
    [constraints addObject:[bottomView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor]];

    return constraints;
}

- (NSArray<NSLayoutConstraint *> *)cameraScreenViewConstraints
{
    NSMutableArray<NSLayoutConstraint *> *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[screenView.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor]];
    [constraints addObject:[screenView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor]];
    [constraints addObject:[screenView.topAnchor constraintEqualToAnchor: self.view.topAnchor]];
    [constraints addObject:[screenView.bottomAnchor constraintEqualToAnchor: bottomView.topAnchor]];

    return constraints;
}

- (void)cameraButton:(CameraButton *)cameraButton {
    photoImageView = [[UIImageView alloc] init];
    photoImageView.frame = UIScreen.mainScreen.bounds;
    photoImageView.image = [cameraManager takePhoto];
    [photoImageView setUserInteractionEnabled:YES];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    // UITapGestureRecognizer 생성
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                                 action:@selector(handleTap:)];

    [photoImageView addGestureRecognizer:tapGesture];

    [self.view addSubview:photoImageView];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (photoImageView != nil) {
        [photoImageView removeFromSuperview];
        photoImageView = nil;
        
        [cameraManager startSession];
    }
}

- (void)filterbutton:(UIButton *)filterButton { 
    [cameraManager changeFilter];
}

- (void)dealloc {
    [super dealloc];
    [cameraManager release];
    NSLog(@"Main View Controller Dealloc");
}
@end
