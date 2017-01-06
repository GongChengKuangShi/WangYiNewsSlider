//
//  SliderHeadView.m
//  WangYiSlider
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "SliderHeadView.h"


#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


static CGFloat const buttonWidth = 80; /**按钮宽度*/
static CGFloat const titleH = 44;/** 文字高度  */
static CGFloat const MaxScale = 1.2;/** 选中文字放大  */

@implementation SliderHeadView

- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}

- (instancetype)init {
    return [self initWithControllDatas:nil ViewTitles:nil];
}

- (instancetype)initWithControllDatas:(NSArray *)controllData ViewTitles:(NSArray *)viewArray {
    if (self = [super init]) {
        
        _titleArray = viewArray;
        _ViewControllerArray = controllData;
        [self setData];
        [self setSliderHeadView];
        
    }
    return self;
}



- (void)setSliderHeadView {
    [self setTitleScrollView];         /** 添加文字标签  */
    [self setControllScrollView];      /** 添加scrollView  */
    [self setupTitle];                 /** 设置标签按钮 文字 背景图  */
    
    self.controllScrollView.contentSize = CGSizeMake(self.titleArray.count * ScreenW, 0);
    self.controllScrollView.pagingEnabled = YES;
    self.controllScrollView.showsHorizontalScrollIndicator = NO;
    self.controllScrollView.delegate = self;
    self.controllScrollView.bounces = NO;
}

- (UIViewController *)findViewController:(UIView *)sourceView {
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (void)setData {
    
    for (int i = 0; i < _titleArray.count; i ++) {
        [self addChildViewController:[_ViewControllerArray objectAtIndex:i] ViewTitle:[_titleArray objectAtIndex:i]];
    }
}

- (void)addChildViewController:(UIViewController *)childViewController ViewTitle:(NSString *)viewTitle {
    
    UIViewController *superViewController = [self findViewController:self];
    childViewController.title = viewTitle;
    [superViewController addChildViewController:childViewController];
}

- (void)setTitleScrollView {
    UIViewController *superViewController = [self findViewController:self];
    CGRect rect  = CGRectMake(0, 64, ScreenW, titleH);
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [superViewController.view addSubview:self.titleScrollView];
}

- (void)setControllScrollView {
    UIViewController *superViewController = [self findViewController:self];
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, ScreenW, ScreenH-titleH);
    self.controllScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [superViewController.view addSubview:self.controllScrollView];
}

- (void)setupTitle {
    UIViewController *superViewController = [self findViewController:self];
    
    NSUInteger count = superViewController.childViewControllers.count;
    CGFloat x = 0;
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80 - 10, titleH -10)];
    self.backImageView.image = [UIImage imageNamed:@"b1"];
    self.backImageView.backgroundColor = [UIColor whiteColor];
    self.backImageView.userInteractionEnabled = YES;
    [self.titleScrollView addSubview:self.backImageView];
    
    for (int i = 0; i < count; i++) {
        UIViewController *viewController = [superViewController.childViewControllers objectAtIndex:i];
        x = i * buttonWidth;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, 0, buttonWidth, titleH);
        button.tag = i;
        [button setTitle:viewController.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [button addTarget:self action:@selector(touchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArray addObject:button];
        [self.titleScrollView addSubview:button];
        
        if (i == 0) {
            [self touchButtonClick:button];
        }
    }
    self.titleScrollView.contentSize = CGSizeMake(count * buttonWidth, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)touchButtonClick:(UIButton *)sender {
    [self selectTitleButton:sender];
    NSInteger index = sender.tag;
    CGFloat x = index * ScreenW;
    self.controllScrollView.contentOffset = CGPointMake(x, 0);
    [self setupOneChildController:index];
}

- (void)selectTitleButton:(UIButton *)button {
    [self.selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.selectButton.transform = CGAffineTransformIdentity;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectButton = button;
    
    [self setupTitleCenter:button];
}

- (void)setupTitleCenter:(UIButton *)sender {
    CGFloat offset = sender.center.x - ScreenW * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - ScreenW;
    if (offset > maxOffset && maxOffset > 0) {
        offset = maxOffset;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)setupOneChildController:(NSInteger)index {
    
    UIViewController *superViewController = [self findViewController:self];
    
    CGFloat x = index * ScreenW;
    UIViewController *viewController = [superViewController.childViewControllers objectAtIndex:index];
    if (viewController.view.superview) {
        return;
    }
    viewController.view.frame = CGRectMake(x, 0, ScreenW, ScreenH - self.controllScrollView.frame.origin.y);
    [self.controllScrollView addSubview:viewController.view];
}

#pragma mark -- UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.controllScrollView.contentOffset.x / ScreenW;
    [self selectTitleButton:[self.buttonsArray objectAtIndex:index]];
    [self setupOneChildController:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / ScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = [self.buttonsArray objectAtIndex:leftIndex];
    UIButton *rightButton = nil;
    if (rightIndex < self.buttonsArray.count) {
        rightButton = [self.buttonsArray objectAtIndex:rightIndex];
    }
    CGFloat scaleR  = offsetX / ScreenW - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1;
    
    self.backImageView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.controllScrollView.contentSize.width)), 0);
    
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    UIColor *rightColor = [UIColor colorWithRed:(174+66*scaleR)/255.0 green:(174-71*scaleR)/255.0 blue:(174-174*scaleR)/255.0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:(174+66*scaleL)/255.0 green:(174-71*scaleL)/255.0 blue:(174-174*scaleL)/255.0 alpha:1];
    
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}


@end
