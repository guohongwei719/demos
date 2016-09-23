//
//  AJKBrowseRemindView.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//


#import "AJKBrowseRemindView.h"
#import "UIView+AJKScanImageLayout.h"

@interface AJKBrowseRemindView ()

@property (nonatomic,strong) UILabel *remindLabel;
@property (nonatomic,strong) UIView *maskView;

@end

@implementation AJKBrowseRemindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createRemindView];
    }
    return self;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5f;
        _maskView.layer.cornerRadius = 5.0f;
        _maskView.layer.masksToBounds = YES;
    }
    return _maskView;
}

- (UILabel *)remindLabel
{
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc]init];
        _remindLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _remindLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _remindLabel.textColor = [UIColor whiteColor];
    }
    return _remindLabel;
}

- (void)createRemindView
{
    self.alpha = 0;
    [self addSubview:self.maskView];
    [self addSubview:self.remindLabel];
}

- (void)showRemindViewWithText:(NSString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.remindLabel.font} context:nil];
    CGSize size = textRect.size;
    [self.maskView setFrameInSuperViewCenterWithSize:CGSizeMake(size.width + 20, size.height + 40)];
    [self.remindLabel setFrameInSuperViewCenterWithSize:CGSizeMake(size.width, size.height)];
    self.remindLabel.text = text;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hideRemindView
{
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        
    }];
}

@end
