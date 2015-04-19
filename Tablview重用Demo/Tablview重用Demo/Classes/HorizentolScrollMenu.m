//
//  HorizentolScrollMenu.m
//  2313
//
//  Created by maguanghai on 14-9-9.
//  Copyright (c) 2014年 maguanghai. All rights reserved.
//  水平滑动菜单栏

#import "HorizentolScrollMenu.h"
#import "UIView+Frame.h"

#define PADDING 5
#define MenuBtnWidth 68

@interface HorizentolScrollMenu()
//保存所有菜单按钮
@property(nonatomic,strong)NSMutableArray *buttons;

@end

@implementation HorizentolScrollMenu

#pragma mark 懒加载

-(NSMutableArray *)buttons
{
 if(_buttons ==nil)
 {
     _buttons =[[NSMutableArray alloc]init];
 }
    return _buttons;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = YES;
        //消除滑动指示
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        
        self.bounces =YES;
        //添加菜单按钮
        [self setupButtons];
        //设置frame
        
    }
    return self;
}
- (void)setDataList:(NSArray *)dataList
{
    _dataList =dataList;
    [self setupButtons];
    [self setupFrames];
}
-(void)setupButtons
{
    UIImage *image =[UIImage imageNamed:@"基本"];
    
    for(int i =0;i<self.dataList.count;i++)
    {
     [self addButtonWithImage:image Titile:self.dataList[i] andTag:i];
    }
  
}
/**
 *  根据图片 titl 添加按钮 并计算出frame
 *
 *  @param image <#image description#>
 *  @param title <#title description#>
 *  @param tag   <#tag description#>
 */
-(void)addButtonWithImage:(UIImage *)image Titile:(NSString *)title andTag:(NSInteger)tag
{
    UIButton *btn =[[UIButton alloc]init];
    btn.tag =tag;
    btn.backgroundColor =[UIColor clearColor];
    //文字
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:)forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self.buttons addObject:btn];
}
-(void)setupFrames
{
    /**遍历所有Button 设置Frame*/
    for(int i =0;i<self.buttons.count;i++)
    {
        UIButton *btn =self.buttons[i];
        btn.x =PADDING +(MenuBtnWidth +PADDING) *i;
        btn.y =0;
        btn.width =MenuBtnWidth;
        btn.height =self.height;
    }
    //设置可滑动大小
    UIButton *lastButton = [self.buttons lastObject];
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame)+PADDING, self.height);
}
/**
 *  菜单按钮点击事件 通过代理方法传递Tag值给VC
 *
 *  @param btn <#btn description#>
 */
-(void)btnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(horizentolScrollMenu:didClick:)])
    {
        [self.delegate horizentolScrollMenu:self didClick:btn.tag];
    }
}

@end
