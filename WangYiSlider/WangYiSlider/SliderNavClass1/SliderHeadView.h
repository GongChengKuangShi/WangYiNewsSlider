//
//  SliderHeadView.h
//  WangYiSlider
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderHeadView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView   *titleScrollView;

@property (strong, nonatomic) UIScrollView   *controllScrollView;

@property (strong, nonatomic) NSArray        *titleArray;

@property (strong, nonatomic) NSArray        *ViewControllerArray;

@property (strong, nonatomic) NSMutableArray *buttonsArray;

@property (strong, nonatomic) UIButton       *selectButton;

@property (strong, nonatomic) UIImageView    *backImageView;

- (instancetype)initWithControllDatas:(NSArray *)controllData ViewTitles:(NSArray *)viewArray;

- (void)setSliderHeadView;

- (void)addChildViewController:(UIViewController *)childViewController ViewTitle:(NSString *)viewTitle;

@end
