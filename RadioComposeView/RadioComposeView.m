//
//  RadioComposeView.m
//  RadioComposeViewDemo
//
//  Created by lichq on 14-11-12.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "RadioComposeView.h"
#import "UIScrollView+CJAddContentView.h"
#import "UIView+CJAddSubVIew.h"

@interface RadioComposeView () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIView *contentView;
    
    UIView *_viewL;
    UIView *_viewC;
    UIView *_viewR;
    
    NSInteger changeToShowViewIndex;    /**< 选择切换到哪个 */
}
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) BOOL isDragByMyself;

@end

@implementation RadioComposeView

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self commonInit];
}


- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    self.isDragByMyself = YES;
    
    [self addScrollViewToSelf];
    [self addContentViewToScrollView];
    
    //Left、Center、Right
    [self addLeftViewToScrollView];
    [self addCenterViewToScrollView];
    [self addRightViewToScrollView];
}

- (void)setDataSource:(id<RadioComposeViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    //loadViews
    [self reloadViews];
}



/** 完整的描述请参见文件头部 */
- (void)reloadViews {
    //self.views
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cj_radioViewsInRadioComposeView:)]) {
        self.views = [self.dataSource cj_radioViewsInRadioComposeView:self];
    }
    if (self.views.count < 3) {
        NSAssert(NO, @"error: self.views.count < 3, wouldn't be reloadVies");
        return;
    }
    
    _currentShowViewIndex = -1;
    
    //defaultShowIndex
    NSInteger defaultShowIndex = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cj_defaultShowIndexInRadioComposeView:)]) {
        defaultShowIndex = [self.dataSource cj_defaultShowIndexInRadioComposeView:self];
        
        if (defaultShowIndex >= self.views.count) {
            NSAssert(NO, @"指定默认显示的index，大于最大index");
        }
    }
    [self resetViewToLeftCenterRightWithShowViewIndex:defaultShowIndex];
}

/**
 *  为 左·中·右视图 重新附上新的视图，且页面上显示的中视图的的视图在所有视图中所在的位置为index
 *
 *  @param showViewIndex 中视图的的视图在所有视图中的位置index
 */
- (void)resetViewToLeftCenterRightWithShowViewIndex:(NSInteger)centerViewIndex {
    if (_currentShowViewIndex == centerViewIndex) {
        NSLog(@"resetViewToLeftCenterRight failure");
        return;
    }
    
    /* 取得 左·中·右视图，分别是所有view中的哪几个 */
    NSInteger indexForLeftView = (centerViewIndex == 0) ? self.views.count-1 : centerViewIndex-1;
    NSInteger indexForCenterView = centerViewIndex;
    NSInteger indexForRightView = (centerViewIndex == self.views.count-1) ? 0 : centerViewIndex+1;
    
    [self resetScrollViewWithLeft:indexForLeftView center:indexForCenterView right:indexForRightView];
    _currentShowViewIndex = centerViewIndex;
    
    //滑动到显示的视图(即中视图)
    if (self.delegate && [self.delegate respondsToSelector:@selector(cj_radioComposeView:didChangeToIndex:)]) {
        [self.delegate cj_radioComposeView:self didChangeToIndex:centerViewIndex];
    }
}


/**
 *  为 左·中·右视图 重新附上新的视图，且页面上显示的中视图的的视图在所有视图中所在的位置为index
 *
 *  @param leftViewIndex    左视图的的视图在所有视图中的位置index
 *  @param centerViewIndex  中视图的的视图在所有视图中的位置index
 *  @param rightViewIndex   右视图的的视图在所有视图中的位置index
 */
- (void)resetScrollViewWithLeft:(NSInteger)leftViewIndex
                         center:(NSInteger)centerViewIndex
                          right:(NSInteger)rightViewIndex
{
    [self replaceScrollLeftView:leftViewIndex];
    [self replaceScrollCenterView:centerViewIndex];
    [self replaceScrollRightView:rightViewIndex];
}


/**
 *  替换 左视图 上的视图
 *
 *  @param leftViewIndex    左视图的的视图在所有视图中的位置index
 */
- (void)replaceScrollLeftView:(NSInteger)leftViewIndex {
    for (UIView *view in _viewL.subviews) {
        [view removeFromSuperview];
    }
    
    //注：从保持的self.views中，拿出的 左·中·右视图 都已经把该view下的所有样式都完整的包含进去了，所以取出来的也是放好的
    UIView *newLeftView = [self.views objectAtIndex:leftViewIndex];
    [_viewL cj_addSubView:newLeftView withEdgeInsets:UIEdgeInsetsZero];
}

/**
 *  替换 右视图 上的视图
 *
 *  @param rightViewIndex   右视图的的视图在所有视图中的位置index
 */
- (void)replaceScrollRightView:(NSInteger)rightViewIndex {
    for (UIView *view in _viewR.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *newRightView = [self.views objectAtIndex:rightViewIndex];
    [_viewR cj_addSubView:newRightView withEdgeInsets:UIEdgeInsetsZero];
}

/**
 *  替换 中视图 上的视图
 *
 *  @param centerViewIndex  中视图的的视图在所有视图中的位置index
 */
- (void)replaceScrollCenterView:(NSInteger)centerViewIndex {
    for (UIView *view in _viewC.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *newCenterView = [self.views objectAtIndex:centerViewIndex];
    [_viewC cj_addSubView:newCenterView withEdgeInsets:UIEdgeInsetsZero];
}


#pragma mark - ScrolView、ContentView、LeftView、CenterView、RightView的加载
- (void)addScrollViewToSelf {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    [self cj_addSubView:_scrollView withEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


- (void)addContentViewToScrollView {
    //scrollView采用三页显示（只将前一页，现在页，下一页的页面加载进来，其他的不加载)，以此来节省内存开销。
    contentView = [_scrollView cj_addContentViewWithWidthMultiplier:3 heightMultiplier:1];
}

- (void)addLeftViewToScrollView {
    UIView *view = [[UIView alloc] init];
    [contentView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    /* width、height、top是不变的所以这里可以先写 */
    //width
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0]];
    //height
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    //top
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    /* 计算left要多少 */
    //left
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1
                                                            constant:0]];
    
    //
    _viewL = view;
}

- (void)addCenterViewToScrollView {
    UIView *view = [[UIView alloc] init];
    [contentView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    /* width、height、top是不变的所以这里可以先写 */
    //width
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0]];
    //height
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    //top
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    /* 计算left要多少 */
    //left
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_viewL
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1
                                                            constant:0]];
    
    //
    _viewC = view;
}


- (void)addRightViewToScrollView {
    UIView *view = [[UIView alloc] init];
    [contentView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    /* width、height、top是不变的所以这里可以先写 */
    //width
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0]];
    //height
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:1
                                                            constant:0]];
    //top
    [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:0]];
    /* 计算left要多少 */
    //left
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_viewC
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1
                                                            constant:0]];
    
    //
    _viewR = view;
}



#pragma mark - 手动选择显示哪个viewController.view
/** 完整的描述请参见文件头部 */
- (void)cj_selectComponentAtIndex:(NSInteger)showViewIndex animated:(BOOL)animated {
    self.isDragByMyself = NO;
    
    if (_currentShowViewIndex == showViewIndex) {
        NSLog(@"选择的index未变化，仍是%zd", showViewIndex);
        return;
    }
    
    NSInteger oldShowViewIndex = _currentShowViewIndex;
    NSLog(@"由%zd到%zd", oldShowViewIndex, showViewIndex);
    
    
    BOOL isShowViewIndexLeftThanCurrent = showViewIndex < oldShowViewIndex || (oldShowViewIndex==0 && showViewIndex == self.views.count-1); //目标视图位于左侧的情况
    //BOOL isShowViewIndexRightThanCurrent = showViewIndex > oldShowViewIndex || (oldShowViewIndex==self.views.count-1 && showViewIndex==0);  //目标视图位于右侧的情况
    /* 判断要显示的新视图位于当前视图的左边还是右边 */
    if (ABS(showViewIndex - oldShowViewIndex) < 2) {
        //NSLog(@"要切换到的位置就在隔壁，故无需事先替换隔壁视图");
        
    } else {
        if (isShowViewIndexLeftThanCurrent) {
            [self replaceScrollLeftView:showViewIndex];
        } else {
            [self replaceScrollRightView:showViewIndex];
        }
    }
    
    
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    if (isShowViewIndexLeftThanCurrent) {
        [_scrollView setContentOffset:CGPointMake(0*width, 0) animated:animated];
    } else {
        [_scrollView setContentOffset:CGPointMake(2*width, 0) animated:animated];
    }
    
    if (animated == NO) {
        [self resetViewToLeftCenterRightWithShowViewIndex:showViewIndex];
    } else {
        changeToShowViewIndex = showViewIndex;
        //NSLog(@"有动画的时候，我们需要将resetViewToLeftCenterRightWithShowViewIndex放在scrollView的委托方法scrollViewDidEndDecelerating里");
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //由于我们这里使用的是只加载当前页及当前页的前后两页来显示的方式，以减少内存方式，所以当我们拖动到不是所加载的这几页时，比如拖动到当前页的前两页时，就会由于之前没有加载，而显示空内容(即尤其是当我们拖动的距离超过一页的时候)。但是由于我们这里scrollView只设置了三页，也就是说scrollView的contentSize只有三页大小，意味着当scrollView处于中视图时候(实际上显示的时候一直是处于中视图的)，其根本不可能滑动操作一页。所以，我们这里也就没必要在拖动过程中随时检查是否超过一页，来为了避免出现拖动过程中出现空内容的view的情况。
    if (scrollView != _scrollView) {
        return;
    }
    
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    switch (self.scrollType) {
        case RadioComposeViewScrollTypeNormal:
        {
            
            break;
        }
        case RadioComposeViewScrollTypeBanScrollHorizontal:
        {
            CGFloat scrollViewWidth = CGRectGetWidth(scrollView.frame);
            if (contentOffsetX < scrollViewWidth || contentOffsetX > scrollViewWidth) {
                contentOffsetX = scrollViewWidth;
                scrollView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
            }
            
            break;
        }
//        case RadioComposeViewScrollTypeBanScrollVertical:
//        {
//            CGFloat scrollViewHeight = CGRectGetHeight(scrollView.frame);
//            if (contentOffsetY < scrollViewHeight || contentOffsetY > scrollViewHeight) {
//                contentOffsetY = scrollViewHeight;
//                scrollView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
//            }
//            break;
//        }
        case RadioComposeViewScrollTypeBanScrollCycle:
        {
            if (_currentShowViewIndex == 0) {
                CGFloat scrollViewWidth = CGRectGetWidth(scrollView.frame);
                if (contentOffsetX < scrollViewWidth) {
                    contentOffsetX = scrollViewWidth;
                    scrollView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
                }
            }
            if (_currentShowViewIndex == self.views.count-1) {
                CGFloat scrollViewWidth = CGRectGetWidth(scrollView.frame);
                if (contentOffsetX > scrollViewWidth) {
                    contentOffsetX = scrollViewWidth;
                    scrollView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
                }
            }
            
            break;
        }
        default:
            break;
    }
}


/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging: %@", decelerate ? @"YES" : @"NO");
    NSLog(@"因为这里scrollView.pagingEnabled = YES;所以，我们视图的拖动结束和滚动结束都统一到scrollViewDidEndDecelerating中去处理。");
}
*/

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //NSLog(@"执行有滚动动画的代码操作时，比如scrollRectToVisible或setContentOffset:的animated为YES的时候，都会该滚动动画结束的时候调用此方法");
    
    [self resetViewToLeftCenterRightWithShowViewIndex:changeToShowViewIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //拖动drag的时候才会执行
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    NSInteger maxIndex = self.views.count-1;
    
    if (contentOffsetX >= width && contentOffsetX < 2*width) {
        changeToShowViewIndex = _currentShowViewIndex;
        
    } else if (contentOffsetX < width) {
        changeToShowViewIndex = _currentShowViewIndex-1;
        if (changeToShowViewIndex < 0) {
            changeToShowViewIndex = maxIndex;
        }
    } else if (contentOffsetX >= 2*width) {
        changeToShowViewIndex = _currentShowViewIndex+1;
        if (changeToShowViewIndex > maxIndex) {
            changeToShowViewIndex = 0;
        }
    }
    
    [self resetViewToLeftCenterRightWithShowViewIndex:changeToShowViewIndex];
}

/**
 *  滑动到显示的视图(即中视图)
 *
 *  @param isAnimate 滚动过程中是否要有动画
 */
- (void)scrollToCenterViewWithAnimate:(BOOL)isAnimate {
    if (isAnimate) {
        CGFloat width = CGRectGetWidth(_scrollView.frame);
        CGFloat height = CGRectGetHeight(_scrollView.frame);
        [_scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:YES];
        //注：scrollRectToVisible:有时候会无效(eg:在layoutSubviews里不起作用)，所以当在layoutSubviews里执行的时候请一定选择使用通过设置contentOffset的方式来设置滚动
        
    } else {
        CGFloat width = CGRectGetWidth(_scrollView.frame);
        _scrollView.contentOffset = CGPointMake(width, 0);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
