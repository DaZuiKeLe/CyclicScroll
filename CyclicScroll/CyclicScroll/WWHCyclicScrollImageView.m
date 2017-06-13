//
//  WWHCyclicScrollImageView.m
//  CyclicScroll
//
//  Created by kele on 2017/6/12.
//  Copyright © 2017年 daGuanJiaJinRong. All rights reserved.
//

#import "WWHCyclicScrollImageView.h"

#define scrollCount 3
#define wwh_screen_width [UIScreen mainScreen].bounds.size.width

static NSString *collectionID = @"collectionID";


@interface WWHCyclicScrollImageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak)UICollectionView *imageCollectionView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *myTimer;
@end

@implementation WWHCyclicScrollImageView
-(NSMutableArray *)imageArray
{
    
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        
        [self.imageArray removeAllObjects];
        
        [self.imageArray addObjectsFromArray:imageArray];
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = frame.size;
        
        UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.imageCollectionView = imageCollectionView;
        imageCollectionView.backgroundColor = [UIColor whiteColor];
        imageCollectionView.showsHorizontalScrollIndicator = NO;
        [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionID];
        imageCollectionView.pagingEnabled = YES;
        imageCollectionView.dataSource = self;
        imageCollectionView.delegate = self;
        
        
        
        if (self.imageArray.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageArray.count *50 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            });
         
           [self addTimer];
        }
        [self addSubview:imageCollectionView];
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.center = CGPointMake(wwh_screen_width/2.0, frame.size.height - 20);
        self.pageControl.bounds = CGRectMake(0, 0, 100, 20);
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.numberOfPages = self.imageArray.count;
        [self addSubview:self.pageControl];
        
    }
    return self;
}

#pragma mark -添加定时器
-(void)addTimer{
    
    if (_durationTime == 0) {
        _durationTime = 3;
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_durationTime target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.myTimer = timer;
}

-(void)setDurationTime:(NSInteger )durationTime{
    
    _durationTime = durationTime;
    [self removeTimer];
    [self addTimer];
    
}

#pragma mark -移除定时器
-(void)removeTimer{
    
    [self.myTimer invalidate];
    self.myTimer = nil;
}
-(void)nextpage{
    
    NSIndexPath *currentIndex = [[self.imageCollectionView indexPathsForVisibleItems] lastObject];
    NSInteger nextItem = currentIndex.item +1;
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:0];
    [self.imageCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count * 100;
    
}

#pragma mark -重新赋值
-(void)setImageArrays:(NSArray *)imageArrays
{
    _imageArrays = imageArrays;
    [self.imageArray removeAllObjects];
    
    [self.imageArray addObjectsFromArray:imageArrays];
    
    if (self.imageArray.count > 0) {
        [self.imageCollectionView reloadData ];
        
        [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.imageArray.count*50 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
    }
    self.pageControl.numberOfPages = self.imageArray.count;
    [self removeTimer];
    [self addTimer];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *rulStr = self.imageArray[indexPath.item%self.imageArray.count];
    
    UICollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    
    collectionCell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [collectionCell.contentView viewWithTag:100];
    
    if (imageView == nil) {
        for (UIView *subView in collectionCell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIImageView *collectionImage = [[UIImageView alloc] initWithFrame:self.bounds];
        collectionImage.tag = 100;
        imageView = collectionImage;
        [collectionCell.contentView addSubview:collectionImage];
    }
    
    //判断图片来源
    
    if ([rulStr hasPrefix:@"https://"]||[rulStr hasPrefix:@"http://"]) {
#warning 这句话是获取网络图片的，用的是SDWebImage
        // [imageView sd_setImageWithURL:[NSURL URLWithString:rulStr] placeholderImage:[UIImage imageNamed:@"nomaoImage"]];
    }
    else{
        if (rulStr == nil) {
            rulStr = @"";
        }
        [imageView setImage:[UIImage imageNamed:rulStr]];
    }
    
    return collectionCell;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offset = scrollView.contentOffset.x/wwh_screen_width;
    if (offset == 0 || offset == [self.imageCollectionView numberOfItemsInSection:0] - 1) {
        if (offset == 0 ) {
            offset = self.imageArray.count*50*wwh_screen_width;
        }else{
            offset = self.imageArray.count*51*wwh_screen_width - wwh_screen_width;
        }
        
        [self.imageCollectionView setContentOffset:CGPointMake(offset, 0)];
    }
    NSInteger page = (NSInteger)offset%self.imageArray.count;
    self.pageControl.currentPage = page;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger offset = (NSInteger)(scrollView.contentOffset.x/wwh_screen_width)%self.imageArray.count;
    self.pageControl.currentPage = offset;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageClickWithIndexBlock) {
        self.imageClickWithIndexBlock(self.pageControl.currentPage,self.imageArray);
    }
}

@end
