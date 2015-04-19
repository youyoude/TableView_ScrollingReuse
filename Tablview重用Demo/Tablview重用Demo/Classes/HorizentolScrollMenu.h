//
//  HorizentolScrollMenu.h
//  2313
//
//  Created by youyou on 14-9-9.
//  Copyright (c) 2014年 youyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizentolScrollMenu;
@protocol HorizentolScrollMenuDelegate <NSObject>

@optional
-(void)horizentolScrollMenu:(HorizentolScrollMenu *)bottomView didClick:(NSInteger)tag;

@end


@interface HorizentolScrollMenu : UIScrollView

@property(nonatomic,weak) id<HorizentolScrollMenuDelegate> delegate;

@property (nonatomic, strong) NSArray *dataList;


@end
