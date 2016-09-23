//
//  AJKBrowseCollectionViewCell.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "AJKBrowseCollectionViewCell.h"

@interface AJKBrowseCollectionViewCell ()

@property (nonatomic, copy) MSSBrowseCollectionViewCellTapBlock tapBlock;
@property (nonatomic, copy) MSSBrowseCollectionViewCellLongPressBlock longPressBlock;
@property (nonatomic, copy) AJKBrowseCollectionViewCellScanOrigin scanOriginBlock;
@property (nonatomic, copy) AJKBrowseCollectionViewCellStopScanOrigin stopScanOriginBlock;

@property (nonatomic, strong) UIImageView *imageViewstopScanOrigin;
@property (nonatomic, assign) AJKScanOriginImageState scanOriginImageState;

@end

@implementation AJKBrowseCollectionViewCell

- (UIImageView *)imageViewstopScanOrigin
{
    if (!_imageViewstopScanOrigin) {
        _imageViewstopScanOrigin = [[UIImageView alloc] initWithFrame:CGRectMake(70, 7, 15, 15)];
        _imageViewstopScanOrigin.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewstopScanOrigin.image = [UIImage imageNamed:@"comm_dy_icon_delete"];
        _imageViewstopScanOrigin.hidden = YES;
    }
    return _imageViewstopScanOrigin;
}

- (AJKBrowseOriginButton *)buttonOrigin
{
    if (!_buttonOrigin) {
        _buttonOrigin = [[AJKBrowseOriginButton alloc] init];
        [_buttonOrigin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonOrigin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_buttonOrigin setBackgroundColor:[UIColor clearColor]];
        _buttonOrigin.bounds = CGRectMake(0, 0, 100, 30);
        _buttonOrigin.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height - 30);
        _buttonOrigin.layer.cornerRadius = 5;
        _buttonOrigin.layer.borderColor = [UIColor whiteColor].CGColor;
        _buttonOrigin.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _buttonOrigin.titleLabel.font = [UIFont systemFontOfSize:12];
        _buttonOrigin.hidden = YES;
        [_buttonOrigin addTarget:self action:@selector(scanOrigin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOrigin;
}

//zoomScrollView

- (AJKBrowseZoomScrollView *)zoomScrollView
{
    if (!_zoomScrollView) {
        _zoomScrollView = [[AJKBrowseZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _zoomScrollView.zoomScale = 1.0f;
        _zoomScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    }
    return _zoomScrollView;
}

- (AJKBrowseLoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[AJKBrowseLoadingView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 30)/2, ([UIScreen mainScreen].bounds.size.height - 30)/2, 30, 30)];
    }
    return _loadingView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    __weak __typeof(self) weakSelf = self;
    [self.zoomScrollView tapClick:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.tapBlock) {
            strongSelf.tapBlock(strongSelf);
        }
    }];
    [self.contentView addSubview:self.zoomScrollView];
    [self.zoomScrollView addSubview:self.loadingView];
//    [self.buttonOrigin addSubview:self.imageViewstopScanOrigin];
    [self.contentView addSubview:self.buttonOrigin];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.contentView addGestureRecognizer:longPressGesture];
}

- (void)tapClick:(MSSBrowseCollectionViewCellTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

- (void)longPress:(MSSBrowseCollectionViewCellLongPressBlock)longPressBlock
{
    _longPressBlock = longPressBlock;
}

- (void)scanOrigin:(AJKBrowseCollectionViewCellScanOrigin)scanOriginBlock
{
    _scanOriginBlock = scanOriginBlock;
}

- (void)stopScanOrigin:(AJKBrowseCollectionViewCellStopScanOrigin)stopScanOriginBlock
{
    _stopScanOriginBlock = stopScanOriginBlock;
}


- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.contentView];
    CGRect rect = self.buttonOrigin.frame;
    if (point.x >= rect.origin.x && point.x <= rect.origin.x + rect.size.width && point.y >= rect.origin.y && point.y <= rect.origin.y + rect.size.height) {
        return;
    }
    if(_longPressBlock) {
        if(gesture.state == UIGestureRecognizerStateBegan) {
            _longPressBlock(self);
        }
    }
}

- (void)scanOrigin
{
    if (self.scanOriginImageState == AJKScanOriginImageStateStart) {
        if (_scanOriginBlock) {
            _scanOriginBlock(self);
        }
    } else if (self.scanOriginImageState == AJKScanOriginImageStatePercentage) {
        if (_stopScanOriginBlock) {
            _stopScanOriginBlock(self);
        }
    }
}

- (void)setScanOriginImageState:(AJKScanOriginImageState)state andStateContent:(NSString *)content
{
    if (state == AJKScanOriginImageStateStart) {
        self.scanOriginImageState = AJKScanOriginImageStateStart;
        self.buttonOrigin.imageViewstopScanOrigin.hidden = YES;
        self.buttonOrigin.hidden = NO;
        [self.buttonOrigin setTitle:@"查看原图" forState:UIControlStateNormal];
    } else if (state == AJKScanOriginImageStatePercentage) {
        self.scanOriginImageState = AJKScanOriginImageStatePercentage;
        self.buttonOrigin.imageViewstopScanOrigin.hidden = NO;
        [self.buttonOrigin setTitle:content forState:UIControlStateNormal];
    } else if (state == AJKScanOriginImageStateFinish) {
        self.scanOriginImageState = AJKScanOriginImageStateFinish;
        self.buttonOrigin.imageViewstopScanOrigin.hidden = YES;
        [self.buttonOrigin setTitle:@"已完成" forState:UIControlStateNormal];
        [self performSelector:@selector(setScanOriginButtonHidden) withObject:nil afterDelay:1];
    } else if (state == AJKScanOriginImageStateUnkown) {
        self.buttonOrigin.hidden = YES;
        self.scanOriginImageState = AJKScanOriginImageStateUnkown;
    }
    
    if ((self.browseItem.imageURL &&
        self.browseItem.originImageURL &&
        [self.browseItem.imageURL isEqualToString:self.browseItem.originImageURL]) ||
        self.browseItem.originImageURL == nil) {
        self.buttonOrigin.hidden = YES;
    }
}

- (void)setScanOriginButtonHidden
{
    self.buttonOrigin.hidden = YES;
}


@end
