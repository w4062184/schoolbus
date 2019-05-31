//
//  KSscrollView.h
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KScrollerViewDelegate <NSObject>
@optional
- (void)KScrollerViewDidClicked:(NSInteger)index;

- (void)KScrollerViewScrollToIndex:(NSInteger)index;
@end

@interface KSscrollView : UIView<UIScrollViewDelegate> {
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    NSArray *titleArray;
    UIPageControl *pageControl;
    id<KScrollerViewDelegate> delegate;
    int currentPageIndex;
    int pageChange;
    UILabel *noteTitle;
    //    NSTimer *timer;
    BOOL    chang;
}

/**
 *  设置开始为第几张图片
 */
@property(nonatomic,assign)NSInteger imageIndex;

@property (nonatomic,strong)NSArray *imageAry;

@property(nonatomic,retain)id<KScrollerViewDelegate> delegate;

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr changPic:(BOOL)changPic;
@end
