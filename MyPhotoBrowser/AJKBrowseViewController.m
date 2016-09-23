//
//  AJKBrowseViewController.m
//  Anjuke2
//
//  Created by guohongwei719 on 16/3/15.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import "AJKBrowseViewController.h"
#import "AJKBrowseRemindView.h"
#import "UIView+AJKScanImageLayout.h"

static const CGFloat kBrowseSpace = 30.0f;

@interface AJKBrowseViewController () <UIActionSheetDelegate, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *browseItemArray;
@property (nonatomic, assign) BOOL isFirstOpen;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL dismissAnimated;
@property (nonatomic, strong) UILabel *countLabel;// 当前图片位置
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, strong) NSMutableArray *verticalBigRectArray;
@property (nonatomic, strong) NSMutableArray *horizontalBigRectArray;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) AJKBrowseRemindView *browseRemindView;
@property (nonatomic, strong) AJKBrowseCollectionViewCell *currentCell;
@property (nonatomic, assign) CGRect startRect;
@property (nonatomic, copy) AJKFinishTapBlock finishTapBlock;
@property (nonatomic, copy) AJKBrowseOriginImageLogBlock browseOrginImageLogBlock;
@property (nonatomic, copy) AJKSaveImageLogBlock saveImageLogBlock;


@end

@implementation AJKBrowseViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        // 布局方式改为从上至下，默认从左到右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Section Inset就是某个section中cell的边界范围
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 每行内部cell item的间距
        flowLayout.minimumInteritemSpacing = 0;
        // 每行的间距
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _screenWidth + kBrowseSpace, _screenHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.backgroundColor = [UIColor blackColor];
    }
    return _collectionView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:20];
        _countLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        _countLabel.bounds = CGRectMake(0, 0, 80, 30);
        _countLabel.center = CGPointMake(self.view.frame.size.width * 0.5, 40);
        _countLabel.layer.cornerRadius = 15;
        _countLabel.clipsToBounds = YES;
    }
    return _countLabel;
}

- (void)setFinishTap:(AJKFinishTapBlock)finishTapBlock
{
    _finishTapBlock = finishTapBlock;
}

- (void)setBrowseOriginImageLog:(AJKBrowseOriginImageLogBlock)browseOriginImageLogBlock
{
    _browseOrginImageLogBlock = browseOriginImageLogBlock;
}
- (void)setSaveImageLogBlock:(AJKSaveImageLogBlock)saveImageLogBlock
{
    _saveImageLogBlock = saveImageLogBlock;
}


- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex andStartRect:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        _dismissAnimated = YES;
        _startRect = rect;
        _browseItemArray = browseItemArray;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)showBrowseViewController
{
    if (self.browseItemArray.count == 0) {
        return;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        _snapshotView = [rootViewController.view snapshotViewAfterScreenUpdates:NO];
    }
    [rootViewController presentViewController:self animated:NO completion:^{
        
    }];
}
- (void)showBrowseViewControllerDismissAnimated:(BOOL)animated
{
    _dismissAnimated = NO;
    [self showBrowseViewController];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createBrowseView];
}

- (void)initData
{
    _isFirstOpen = YES;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
}

// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
{
    // 改用[UIApplication sharedApplication].keyWindow.rootViewController.view，防止present新viewController坐标转换不准问题
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)createBrowseView
{
    self.view.backgroundColor = [UIColor blackColor];
    if(_snapshotView) {
        _snapshotView.hidden = YES;
        [self.view addSubview:_snapshotView];
    }
    [self.view addSubview:self.bgView];
    

    [self.collectionView registerClass:[AJKBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"AJKBrowserCell"];
    self.collectionView.contentOffset = CGPointMake(self.currentIndex * (_screenWidth + kBrowseSpace), 0);
    [self.bgView addSubview:self.collectionView];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentIndex + 1,(long)_browseItemArray.count];
    [self.bgView addSubview:self.countLabel];
    
    _browseRemindView = [[AJKBrowseRemindView alloc] initWithFrame:self.bgView.bounds];
    [self.bgView addSubview:_browseRemindView];
}


#pragma mark UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AJKBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AJKBrowserCell" forIndexPath:indexPath];
    if(cell) {
        // 停止加载
        [cell.loadingView stopAnimation];
        
        AJKBrowsePhotoModel *browseItem = [_browseItemArray objectAtIndex:indexPath.row];
        cell.browseItem = browseItem;
        cell.buttonOrigin.hidden = YES;
        self.currentCell = cell;

        [self loadBigImageWithBrowseItem:browseItem cell:cell];
        __weak __typeof(self)weakSelf = self;
        [cell scanOrigin:^(AJKBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf scanOriginImage:browseCell];
        }];
        
        [cell stopScanOrigin:^(AJKBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf stopScanOriginImage:browseCell];
        }];

        [cell tapClick:^(AJKBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf tap:browseCell];
        }];
        [cell longPress:^(AJKBrowseCollectionViewCell *browseCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([[SDImageCache sharedImageCache] diskImageExistsWithKey:browseItem.imageURL])
            {
                [strongSelf longPress:browseCell];
            }
        }];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _browseItemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_screenWidth + kBrowseSpace, _screenHeight);
}

// 加载大图
- (void)loadBigImageWithBrowseItem:(AJKBrowsePhotoModel *)browseItem cell:(AJKBrowseCollectionViewCell *)cell
{
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellDefault"]];;
    // 加载圆圈显示
    NSString *imageURLString = browseItem.imageURL;
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:browseItem.originImageURL]) {
        imageURLString = browseItem.originImageURL;
    }

    [cell.loadingView startAnimation];
    __weak __typeof(self) weakSelf = self;
    if (![[SDImageCache sharedImageCache] diskImageExistsWithKey:imageURLString]) {
        // 默认为屏幕中间
        [imageView setFrameInSuperViewCenterEqualScreenWidthWithSize:CGSizeMake(CGRectGetWidth(tempImageView.frame), CGRectGetHeight(tempImageView.frame))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"CellDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            // 关闭图片浏览view的时候，不需要继续执行小图加载大图动画
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.collectionView.userInteractionEnabled) {
                // 停止加载
                [cell.loadingView stopAnimation];
                if(error) {
                    [strongSelf showBrowseRemindViewWithText:@"图片加载失败"];
                }
                else {
                    // 图片加载成功
                    [cell.zoomScrollView resetZoomImageViewFrame];
                    [cell setScanOriginImageState:AJKScanOriginImageStateStart andStateContent:nil];
                }
            }
        }];

    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            // 关闭图片浏览view的时候，不需要继续执行小图加载大图动画
            if(strongSelf.collectionView.userInteractionEnabled) {
                // 停止加载
                [cell.loadingView stopAnimation];
                if(error) {
                    [strongSelf showBrowseRemindViewWithText:@"图片加载失败"];
                } else {
                    // 第一次打开浏览页需要加载动画
                    if(strongSelf.isFirstOpen) {
                        strongSelf.isFirstOpen = NO;
                        cell.zoomScrollView.zoomImageView.frame = self.startRect;
                        [UIView animateWithDuration:0.2 animations:^{
                            [cell.zoomScrollView resetZoomImageViewFrame];
                        }];
                    } else {
                        [cell.zoomScrollView resetZoomImageViewFrame];
                    }
                    if ([imageURLString isEqualToString:browseItem.imageURL]) {
                        [cell setScanOriginImageState:AJKScanOriginImageStateStart andStateContent:nil];
                    } else {
                        [cell setScanOriginImageState:AJKScanOriginImageStateUnkown andStateContent:nil];
                    }
                }
            }
        }];
    }
}

#pragma mark - UIScrollViewDeletate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (AJKBrowseCollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.buttonOrigin.hidden = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x / (_screenWidth + kBrowseSpace);
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_currentIndex + 1,(long)_browseItemArray.count];
    for (AJKBrowseCollectionViewCell *cell in self.collectionView.visibleCells) {
        if (cell.browseItem.originImageURL && ![[SDImageCache sharedImageCache] diskImageExistsWithKey:cell.browseItem.originImageURL]) {
            cell.buttonOrigin.hidden = NO;
        } else {
            cell.buttonOrigin.hidden = YES;
        }
    }
}

#pragma mark - Tap Method
- (void)tap:(AJKBrowseCollectionViewCell *)browseCell
{
    if(_snapshotView) {
        _snapshotView.hidden = NO;
    } else {
        self.view.backgroundColor = [UIColor clearColor];
    }
    // 集合视图背景色设置为透明
    self.collectionView.backgroundColor = [UIColor clearColor];
    // 动画结束前不可点击透明背景后的内容
    self.collectionView.userInteractionEnabled = NO;
    // 显示状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    // 停止加载
    NSArray *cellArray = self.collectionView.visibleCells;
    for (AJKBrowseCollectionViewCell *cell in cellArray) {
        [cell.loadingView stopAnimation];
        cell.buttonOrigin.hidden = YES;
    }
    [self.countLabel removeFromSuperview];
    self.countLabel = nil;
    browseCell.zoomScrollView.zoomScale = 1.0f;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    
    if (self.dismissAnimated) {
        [UIView animateWithDuration:0.3 animations:^{
            browseCell.zoomScrollView.zoomImageView.transform = transform;
            browseCell.zoomScrollView.zoomImageView.frame = self.startRect;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.finishTapBlock) {
                    self.finishTapBlock(self.currentIndex);
                }
            }];
        }];

    } else {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.finishTapBlock) {
                self.finishTapBlock(self.currentIndex);
            }
        }];
    }

}

- (void)longPress:(AJKBrowseCollectionViewCell *)browseCell
{
    UIActionSheet *saveImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    [saveImageSheet showInView:self.view];
}

- (void)scanOriginImage:(AJKBrowseCollectionViewCell *)browseCell
{
    [browseCell.loadingView startAnimation];
    if (self.browseOrginImageLogBlock) {
        self.browseOrginImageLogBlock();
    }
    __weak __typeof(self)weakSelf = self;
    [browseCell.zoomScrollView.zoomImageView sd_setImageWithURL:[NSURL URLWithString:browseCell.browseItem.originImageURL] placeholderImage:browseCell.zoomScrollView.zoomImageView.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        int percent = (int)(((CGFloat)receivedSize / expectedSize) * 100);
        NSString *percentage = [NSString stringWithFormat:@"%d%%", percent];
        [browseCell setScanOriginImageState:AJKScanOriginImageStatePercentage andStateContent:percentage];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [browseCell.loadingView stopAnimation];
        if (!error) {
            [browseCell setScanOriginImageState:AJKScanOriginImageStateFinish andStateContent:nil];
            [browseCell.zoomScrollView resetZoomImageViewFrame];
        } else {
            [weakSelf showBrowseRemindViewWithText:@"图片加载失败"];
            [browseCell setScanOriginImageState:AJKScanOriginImageStateStart andStateContent:nil];
        }
    }];

}

- (void)stopScanOriginImage:(AJKBrowseCollectionViewCell *)browseCell
{
    [browseCell.zoomScrollView.zoomImageView sd_cancelCurrentImageLoad];
    [browseCell.loadingView stopAnimation];
    [browseCell setScanOriginImageState:AJKScanOriginImageStateStart andStateContent:nil];
}


#pragma mark StatusBar Method
- (BOOL)prefersStatusBarHidden
{
    if(!self.collectionView.userInteractionEnabled) {
        return NO;
    }
    return YES;
}


#pragma mark - UIActionSheetDelegate


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *text = nil;
    if(error) {
        text = @"保存图片失败";
    } else {
        text = @"已保存至系统相册";
    }
    [self showBrowseRemindViewWithText:text];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImageWriteToSavedPhotosAlbum(self.currentCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            if (self.saveImageLogBlock) {
                self.saveImageLogBlock();
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark RemindView Method

- (void)showBrowseRemindViewWithText:(NSString *)text
{
    [_browseRemindView showRemindViewWithText:text];
    self.bgView.userInteractionEnabled = NO;
    [self performSelector:@selector(hideRemindView) withObject:nil afterDelay:0.7];
}

- (void)hideRemindView
{
    [_browseRemindView hideRemindView];
    self.bgView.userInteractionEnabled = YES;
}

@end
