//
//  AJKBrowseZoomScrollView.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "AJKBrowseZoomScrollView.h"

@interface AJKBrowseZoomScrollView ()

@property (nonatomic, copy) AJKBrowseZoomScrollViewTapBlock tapBlock;
@property (nonatomic, assign) BOOL isSingleTap;

@end

@implementation AJKBrowseZoomScrollView

- (UIImageView *)zoomImageView
{
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc]init];
        _zoomImageView.contentMode = UIViewContentModeScaleAspectFill;
        _zoomImageView.userInteractionEnabled = YES;
        _zoomImageView.clipsToBounds = YES;
    }
    return _zoomImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createZoomScrollView];
    }
    return self;
}

- (void)createZoomScrollView
{
    self.delegate = self;
    self.isSingleTap = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 3.0f;
    
    [self addSubview:self.zoomImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = self.zoomImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < CGRectGetWidth(self.frame)) {
        rect.origin.x = floorf((CGRectGetWidth(self.frame) - rect.size.width) / 2.0);
    }
    if (rect.size.height < CGRectGetHeight(self.frame)) {
        rect.origin.y = floorf((CGRectGetHeight(self.frame) - rect.size.height) / 2.0);
    }
    self.zoomImageView.frame = rect;
}

- (void)tapClick:(AJKBrowseZoomScrollViewTapBlock)tapBlock
{
    self.tapBlock = tapBlock;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    if(touch.tapCount == 1) {
        [self performSelector:@selector(singleTapClick) withObject:nil afterDelay:0.3];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        // 防止先执行单击手势后还执行下面双击手势动画异常问题
        if(!self.isSingleTap) {
            CGPoint touchPoint = [touch locationInView:self.zoomImageView];
            [self zoomDoubleTapWithPoint:touchPoint];
        }
    }
}

- (void)singleTapClick
{
    self.isSingleTap = YES;
    if(self.tapBlock) {
        self.tapBlock();
    }
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint
{
    if(self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)resetZoomImageViewFrame;
{
    CGRect scrollViewframe = self.frame;
    if (self.zoomImageView.image) {
        self.zoomScale = 1.0;
        CGSize imageSize = self.zoomImageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        CGFloat ratio = scrollViewframe.size.width / imageFrame.size.width;
        imageFrame.size.height = imageFrame.size.height * ratio;
        imageFrame.size.width = scrollViewframe.size.width;
        self.contentSize = imageFrame.size;
        imageFrame.origin.x = (self.bounds.size.width > self.contentSize.width)? (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;;
        imageFrame.origin.y = (self.bounds.size.height > self.contentSize.height)?
        (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
        self.zoomImageView.frame = imageFrame;
        
        // 根据图片大小找到最大缩放等级
        CGFloat maxScale = scrollViewframe.size.height / imageFrame.size.height;
        maxScale = scrollViewframe.size.width / imageFrame.size.height > maxScale ? scrollViewframe.size.width / imageFrame.size.width : maxScale;
        maxScale = maxScale > 3.0 ? maxScale : 3.0;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = maxScale;
    } else {
        scrollViewframe.origin = CGPointZero;
        self.zoomImageView.frame = scrollViewframe;
        self.contentSize = self.zoomImageView.frame.size;
    }
    self.contentOffset = CGPointZero;
}

@end
