//
//  AJKBrowseCollectionViewCell.h
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJKBrowseLoadingView.h"
#import "AJKBrowseZoomScrollView.h"
#import "AJKBrowsePhotoModel.h"
#import "AJKBrowseOriginButton.h"

@class AJKBrowseCollectionViewCell;

typedef NS_ENUM(NSUInteger, AJKScanOriginImageState) {
    AJKScanOriginImageStateUnkown,
    AJKScanOriginImageStateStart,
    AJKScanOriginImageStatePercentage,
    AJKScanOriginImageStateFinish
};

typedef void (^MSSBrowseCollectionViewCellTapBlock)(AJKBrowseCollectionViewCell *browseCell);
typedef void (^MSSBrowseCollectionViewCellLongPressBlock)(AJKBrowseCollectionViewCell *browseCell);
typedef void (^AJKBrowseCollectionViewCellScanOrigin)(AJKBrowseCollectionViewCell *browseCell);
typedef void (^AJKBrowseCollectionViewCellStopScanOrigin)(AJKBrowseCollectionViewCell *browseCell);

@interface AJKBrowseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AJKBrowseZoomScrollView *zoomScrollView; // 滚动视图
@property (nonatomic, strong) AJKBrowseLoadingView *loadingView; // 加载视图
@property (nonatomic, strong) AJKBrowseOriginButton *buttonOrigin;
@property (nonatomic, strong) AJKBrowsePhotoModel *browseItem;

- (void)tapClick:(MSSBrowseCollectionViewCellTapBlock)tapBlock;
- (void)longPress:(MSSBrowseCollectionViewCellLongPressBlock)longPressBlock;
- (void)scanOrigin:(AJKBrowseCollectionViewCellScanOrigin)scanOriginBlock;
- (void)stopScanOrigin:(AJKBrowseCollectionViewCellStopScanOrigin)stopScanOriginBlock;

- (void)setScanOriginImageState:(AJKScanOriginImageState)state andStateContent:(NSString *)content;

@end
