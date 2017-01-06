//
//  OneViewController.m
//  WangYiSlider
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 mgjr. All rights reserved.
//

#import "OneViewController.h"
#import "SliderHeadView.h"
#import "TextViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
  
    
    NSArray *titleArr = @[@"美食美食",@"旅游美食",@"电影美食",@"招聘美食",@"娱乐",@"肯德基",@"美食",@"旅游",@"电影",@"招聘",@"娱乐",@"肯德基",@"美食",@"旅游",@"电影",@"招聘",@"娱乐",@"肯德基",@"美食",@"旅游",@"电影",@"招聘",@"娱乐",@"肯德基"];

    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < titleArr.count; i++) {
        
        TextViewController *textViewController = [[TextViewController alloc] init];
        [vcArray addObject:textViewController];
    }

    SliderHeadView *slideVC = [[SliderHeadView alloc]initWithControllDatas:vcArray ViewTitles:titleArr];
    [self.view addSubview:slideVC];
}



@end
