//
//  AJKBrowseLoadingView.h
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJKBrowseLoadingView : UIView

@property (nonatomic, assign) CGFloat angle;

- (void)startAnimation;
- (void)stopAnimation;

@end
