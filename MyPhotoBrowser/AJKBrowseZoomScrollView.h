//
//  AJKBrowseZoomScrollView.h
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AJKBrowseZoomScrollViewTapBlock)(void);

@interface AJKBrowseZoomScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomImageView;

- (void)tapClick:(AJKBrowseZoomScrollViewTapBlock)tapBlock;
- (void)resetZoomImageViewFrame;

@end
