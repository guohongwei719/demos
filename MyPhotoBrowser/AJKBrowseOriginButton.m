//
//  AJKBrowseOriginButton.m
//  Anjuke2
//
//  Created by 黑化肥发灰 on 16/3/22.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "AJKBrowseOriginButton.h"

@interface AJKBrowseOriginButton()

@property (nonatomic, strong) UIView *grayMask;

@end

@implementation AJKBrowseOriginButton

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.imageViewstopScanOrigin];
        [self addSubview:self.grayMask];
        [self.grayMask mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

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

- (UIView *)grayMask {
    if (!_grayMask) {
        _grayMask = [[UIView alloc] init];
        _grayMask.backgroundColor = [UIColor blackColor];
        _grayMask.alpha = 0.3;
        _grayMask.hidden = YES;
    }
    return _grayMask;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self tweakState:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self tweakState:selected];
}

- (void)tweakState:(BOOL)state
{
    if (state) {
        self.grayMask.hidden = NO;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    } else {
        self.grayMask.hidden = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}


@end
