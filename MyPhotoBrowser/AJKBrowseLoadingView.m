//
//  AJKBrowseLoadingView.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "AJKBrowseLoadingView.h"

@interface AJKBrowseLoadingView ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AJKBrowseLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = NO;
}

- (void)transAnimation
{
    self.angle += 6.0f;
    self.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    if (self.angle > 360.f) {
        self.angle = 0;
    }
}

- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(transAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    self.hidden = NO;
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.hidden = YES;
    self.transform = CGAffineTransformMakeRotation(0);
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"ajk_browseLoading"];
    [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}


@end
