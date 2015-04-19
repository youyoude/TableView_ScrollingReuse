//
//  UIView+Frame.h
//  MyWeibo
//
//  Created by maguanghai on 14-8-5.
//  Copyright (c) 2014年 maguanghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)


// 只会生成方法的声明, 不会生成方法的实现和成员变量
@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;


@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;

@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;

@property(nonatomic,assign) CGSize size;

@end
