- (void)didClickModelPhoto:(NSInteger)index {
    NSArray *apiArray = [self allPhotos];
    if (apiArray.count == 0) {
        return;
    }
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [apiArray count];i++)
    {
        NSDictionary *tempDic = [apiArray objectAtIndex:i];
        AJKBrowsePhotoModel *browseItem = [[AJKBrowsePhotoModel alloc]init];
        browseItem.originImageURL = [tempDic objectForKey:@"original_url"];
        browseItem.imageURL = [tempDic objectForKey:@"url"];
        [browseItemArray addObject:browseItem];
    }
    CGRect rect = [self.mainScrollView convertRect:self.headerView.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    AJKBrowseViewController *bvc = [[AJKBrowseViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index andStartRect:rect];
    __weak __typeof(self) weakSelf = self;
    [bvc setFinishTap:^(NSInteger currentIndex) {
        [weakSelf.headerView showImageAtIndex:currentIndex];
    }];
    [bvc setBrowseOriginImageLog:^() {
        [[RTLogger sharedInstance] logWithActionCode:UA_ESF_PROP_BIG_PICTURE_ORIAINALIMAGE page:weakSelf.pageName note:[weakSelf logNote]];
    }];
    [bvc setSaveImageLogBlock:^() {
        [[RTLogger sharedInstance] logWithActionCode:UA_ESF_PROP_BIG_PICTURE_LOAD page:weakSelf.pageName note:[weakSelf logNote]];
    }];
    [bvc showBrowseViewController];
}