//
//  ViewController.m
//  WaterFall
//
//  Created by eassy on 2019/7/10.
//  Copyright © 2019年 eassy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic ,strong) UIView *stickerImageView;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ViewController

#pragma mark - life cycle


- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public methods

#pragma mark - private methods

- (void)setUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self setNav];
    [self addSubViews];
    [self setConstraints];
}

- (void)addSubViews {
    [self.view addSubview:self.contentView];
    [self.contentView setFrame:CGRectMake(20, 180, kScreenWidth - 40, 300)];
}

- (void)setConstraints {
    
}

- (void)setNav {
    
}

#pragma mark - handler Data


#pragma mark - event handlers

- (void)addASticker {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"sticker"];
    [self.contentView addSubview:imageView];
    [imageView setFrame:CGRectMake(0, 0, 90, 90)];
//    imageView.center = self.contentView.center;
    imageView.clipsToBounds = YES;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panGes.delegate = self;
    [imageView addGestureRecognizer:panGes];
    
    UIRotationGestureRecognizer *rotationGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandler:)];
    rotationGes.delegate = self;
    [imageView addGestureRecognizer:rotationGes];
    
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    pinchGes.delegate = self;
    [imageView addGestureRecognizer:pinchGes];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [imageView addGestureRecognizer:tapGes];
}

- (void)tapHandler:(UITapGestureRecognizer *)tapGes {
    UIImageView *imgView = (UIImageView *)tapGes.view;
    [self.contentView bringSubviewToFront:imgView];
}

- (void)panHandler:(UIPanGestureRecognizer *)panGest {
    //拖拽的距离(距离是一个累加)
    CGPoint trans = [panGest translationInView:self.contentView];
    NSLog(@"%@",NSStringFromCGPoint(trans));
    UIImageView *imgView = (UIImageView *)panGest.view;
    [self.contentView bringSubviewToFront:imgView];
    //设置图片移动
    CGPoint center =  imgView.center;
    center.x += trans.x;
    center.y += trans.y;
    imgView.center = center;
    
    //清除累加的距离
    [panGest setTranslation:CGPointZero inView:self.contentView];
}

- (void)rotateHandler:(UIRotationGestureRecognizer *)rotateGes {
    //旋转角度
    //旋转的角度也一个累加的过程
    NSLog(@"旋转角度 %f",rotateGes.rotation);
    UIImageView *imgView = (UIImageView *)rotateGes.view;
    [self.contentView bringSubviewToFront:imgView];
    // 设置图片的旋转
    imgView.transform = CGAffineTransformRotate(imgView.transform, rotateGes.rotation);
    
    // 清除 "旋转角度" 的累
    rotateGes.rotation = 0;
}

- (void)pinchHandler:(UIPinchGestureRecognizer *)pinchGes {
    UIImageView *imgView = (UIImageView *)pinchGes.view;
    [self.contentView bringSubviewToFront:imgView];
    imgView.transform = CGAffineTransformScale(imgView.transform, pinchGes.scale, pinchGes.scale);
    
    // 还源
    pinchGes.scale = 1;
}

#pragma mark - customDelegates

#pragma mark - systemDelegates

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - getters && setters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addASticker)]];
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

@end
