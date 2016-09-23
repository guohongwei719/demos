//
//  AJKBrowseViewController.h
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AJKBrowseCollectionViewCell.h"

typedef void (^AJKFinishTapBlock)(NSInteger currentIndex);
typedef void (^AJKBrowseOriginImageLogBlock)();
typedef void (^AJKSaveImageLogBlock)();



@interface AJKBrowseViewController : UIViewController

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex andStartRect:(CGRect)rect;
- (void)showBrowseViewController;
- (void)showBrowseViewControllerDismissAnimated:(BOOL)animated;
- (void)setFinishTap:(AJKFinishTapBlock)finishTapBlock;
- (void)setBrowseOriginImageLog:(AJKBrowseOriginImageLogBlock)browseOriginImageLogBlock;
- (void)setSaveImageLogBlock:(AJKSaveImageLogBlock)saveImageLogBlock;

@end
