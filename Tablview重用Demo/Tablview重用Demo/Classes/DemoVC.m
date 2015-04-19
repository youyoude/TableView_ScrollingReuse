//
//  DemoVC.m
//  CycleScrollTableDemo
//
//  Created by youyou on 14-9-19.
//  Copyright (c) 2014年 youyou. All rights reserved.
//

#import "DemoVC.h"
#import "ScrollViewController.h"
#import "HorizentolScrollMenu.h"
#define MenuHeight 33
@interface DemoVC()<HorizentolScrollMenuDelegate>
@property(nonatomic,strong)ScrollViewController *scrollVC;
@property(nonatomic,strong)HorizentolScrollMenu *menuView;
@end

@implementation DemoVC

-(ScrollViewController *)scrollVC// 多个tablview的容器
{
 if(_scrollVC ==nil)
 {
     CGFloat viewW =self.view.bounds.size.width;
     CGFloat viewH =self.view.bounds.size.height -MenuHeight;
     CGRect rect =CGRectMake(0, 50, viewW, viewH);
     _scrollVC =[[ScrollViewController alloc]initWithFrame:rect];
     [self addChildViewController:_scrollVC];
     [self.view addSubview:_scrollVC.view];
 }
    return _scrollVC;
}
- (void)loadView
{
    [super loadView];
    //添加滑动顶部菜单栏
    CGRect menuFrame =CGRectMake(0,30, self.view.bounds.size.width, MenuHeight);
    HorizentolScrollMenu *menuView =[[HorizentolScrollMenu alloc]initWithFrame:menuFrame];
    menuView.delegate =self;
    [self.view addSubview:menuView];
    self.menuView =menuView;
    NSArray *arry =@[@"第0组", @"第1组", @"第2组", @"第3组", @"第4组",@"第5组", @"第6组", @"第7组", @"第8组", @"第9组"];
    self.scrollVC.dataList =arry;
    self.menuView.dataList =arry;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
