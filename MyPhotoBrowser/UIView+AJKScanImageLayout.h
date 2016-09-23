//
//  UIView+AJKScanImageLayout.h
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AJKScanImageLayout)

- (void)setFrameInSuperViewCenterWithSize:(CGSize)size;
- (void)setFrameInSuperViewCenterEqualScreenWidthWithSize:(CGSize)size;

@end
