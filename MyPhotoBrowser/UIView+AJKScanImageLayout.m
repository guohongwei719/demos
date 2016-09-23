//
//  UIView+AJKScanImageLayout.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "UIView+AJKScanImageLayout.h"

@implementation UIView (AJKScanImageLayout)

- (void)setFrameInSuperViewCenterWithSize:(CGSize)size
{
    if (CGRectGetWidth(self.superview.frame) > size.width && CGRectGetHeight(self.superview.frame) > size.height) {
        self.frame = CGRectMake((CGRectGetWidth(self.superview.frame) - size.width) / 2, (CGRectGetHeight(self.superview.frame) - size.height) / 2, size.width, size.height);
    } else {
        CGRect frame =  CGRectMake(0, 0, size.width, size.height);
        CGFloat ratio = CGRectGetWidth(self.superview.frame) / size.width;
        frame.size.height = size.height * ratio;
        frame.size.width = size.width * ratio;
        frame.origin.x = 0;
        frame.origin.y = (CGRectGetHeight(self.superview.frame) - frame.size.height) * 0.5;
        self.frame = frame;
    }
}

- (void)setFrameInSuperViewCenterEqualScreenWidthWithSize:(CGSize)size
{
    CGRect frame =  CGRectMake(0, 0, size.width, size.height);
    CGFloat ratio = CGRectGetWidth(self.superview.frame) / size.width;
    frame.size.height = size.height * ratio;
    frame.size.width = size.width * ratio;
    frame.origin.x = 0;
    frame.origin.y = (CGRectGetHeight(self.superview.frame) - frame.size.height) * 0.5;
    self.frame = frame;
}

@end
