//
//  KSscrollView.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights rKServed.
//

#import "KSscrollView.h"
#import "KSview.h"
@interface KSscrollView()
{
    NSArray *_imageAry;
    NSArray *_titleAry;
    NSMutableArray *_imageViewAry;
}
@end


@implementation KSscrollView
@synthesize delegate;

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr changPic:(BOOL)changPic
{
    self = [super initWithFrame:rect];
//    if ([imgArr count] == 0)
//    {
//        imgArr = @[@"个人信息",@"个人信息",@"个人信息"];
//    }
    UIImageView *imv = [[UIImageView alloc]init];
    imv.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    imv.image = [UIImage imageNamed:@"首页-有监控车辆底部"];
    [self addSubview:imv];
    
    if (self && [imgArr count] != 0) {
        _imageViewAry = [[NSMutableArray alloc]init];
        
        _imageAry = imgArr;
        self.userInteractionEnabled=YES;
        titleArray=titArr;
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
        imageArray=[NSArray arrayWithArray:tempArray];
        
        viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        
        for (int i=0; i<pageCount; i++) {
            KSview *ksview = [[NSBundle mainBundle] loadNibNamed:@"KSview" owner:nil options:nil].lastObject;
            ksview.frame = CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height-35);
            ksview.tag=i;
            NSMutableDictionary *dic = [imageArray objectAtIndex:i];
            NSString *status = [[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]?@"监控中":@"未行驶";
            if ([[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]) {
                status = @"行驶";
            }
            else if ([[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"2"]){
                status = @"失联";
            }
            else{
                status = @"停止";
            }
            NSString *str = [NSString stringWithFormat:@"%@ (%@)",[dic safeObjectForKey:@"chepaino"],status];
            //创建NSMutableAttributedString
            NSInteger length = [str localizedStandardRangeOfString:@"("].location;
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
            //设置字体和设置字体的范围
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, str.length)];
            //添加文字颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:JYColorA(51, 51, 51, 1) range:NSMakeRange(0, length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]?JYColorA(255, 175, 4, 1):JYColorA(153, 153, 153, 1) range:NSMakeRange(length, str.length-length)];
            ksview.carnumber.attributedText = attrStr;
            ksview.distance.hidden = [[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]?NO:YES;
            ksview.line.hidden = [[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]?NO:YES;
            ksview.time.hidden = [[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]?NO:YES;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            ksview.userInteractionEnabled=YES;
            [ksview addGestureRecognizer:Tap];
            [scrollView addSubview:ksview];
            [_imageViewAry addObject:ksview];
        }
        
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        if (imgArr.count == 1) {
            scrollView.scrollEnabled = NO;
        }
        else{
            scrollView.scrollEnabled = YES;
        }
        float pageControlWidth=(pageCount-2)*10.0f+20.f;
        float pagecontrolHeight=35.0f;
        if ([imgArr count] >= 1)
        {
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(rect.size.width/2 - pageControlWidth/2 ,rect.size.height - 35, pageControlWidth, pagecontrolHeight)];
        }
        pageControl.pageIndicatorTintColor = JYColorA(221, 221, 221, 1);
        pageControl.currentPageIndicatorTintColor = JYColorA(255, 175, 4, 1);
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        [self addSubview:pageControl];
//        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

//- (void)setImageAry:(NSArray *)imageAry
//{
//    _imageAry = imageAry;
//    if (_imageAry.count == 0) {
//        for (UIView *subView in _imageViewAry) {
//            if ([subView isKindOfClass:[UIImageView class]]) {
//                [subView removeFromSuperview];
//            }
//        }
//        if (pageControl) {
//            pageControl.numberOfPages = 0;
//        }
//    }
//    if ([_imageAry count] == 0)
//    {
//        _imageAry = @[@"个人信息"];
//    }
//    _imageViewAry = [[NSMutableArray alloc]init];
//    
//    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_imageAry];
//    [tempArray insertObject:[_imageAry objectAtIndex:([_imageAry count]-1)] atIndex:0];
//    [tempArray addObject:[_imageAry objectAtIndex:0]];
//    imageArray=[NSArray arrayWithArray:tempArray];
//    
//    viewSize=self.frame;
//    NSUInteger pageCount=[imageArray count];
//    scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
//    scrollView.scrollsToTop = NO;
//    
//    for (int i=0; i<pageCount; i++) {
//        NSString *imgURL=[imageArray objectAtIndex:i];
//        UIImageView *imgView=[[UIImageView alloc]init];
//        
//        if ([imgURL hasPrefix:@"http://"]) {
//            //网络图片 请使用ego异步图片库
//            
//            [imgView setNeedsDisplay];
//        }
//        else
//        {
//            UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
//            [imgView setImage:img];
//        }
//        [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
//        imgView.tag=i;
//        
//        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePrKSsed:)];
//        [Tap setNumberOfTapsRequired:1];
//        [Tap setNumberOfTouchesRequired:1];
//        imgView.userInteractionEnabled=YES;
//        [imgView addGestureRecognizer:Tap];
//        [scrollView addSubview:imgView];
//        [_imageViewAry addObject:imgView];
//    }
//    
//    [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
//    [self addSubview:scrollView];
//    
//    
//    float pageControlWidth=(pageCount-2)*10.0f+40.f;
//    float pagecontrolHeight=20.0f;
//    if (!pageControl)
//    {
//        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - pageControlWidth/2 ,self.frame.size.height - 20, pageControlWidth, pagecontrolHeight)];
//    }
//    
//    pageControl.currentPage=0;
//    pageControl.numberOfPages=(pageCount-2);
//    [self addSubview:pageControl];
//}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    if (page == 0) {
        pageControl.currentPage = imageArray.count - 1;
    }else if (page == imageArray.count + 1)
    {
        pageControl.currentPage = 0;
    }else
    {
        pageControl.currentPage = page - 1;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }
    [delegate KScrollerViewScrollToIndex:pageControl.currentPage];
}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    NSLog(@"%ld",sender.view.tag);
    if (sender.view.tag > [_imageAry count]||sender.view.tag == 0) {
        [self selectImageView:1];
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(KScrollerViewDidClicked:)]) {
        [delegate KScrollerViewDidClicked:sender.view.tag - 1];
    }
    
}

- (void)setImageIndex:(NSInteger)imageIndex
{
    if (imageIndex > [_imageAry count] - 1) {
        return;
    }
    _imageIndex = imageIndex;
    [self selectImageView:_imageIndex];
}

- (void)dismissImageAtIndex:(NSInteger)index
{
    [self selectImageView:index];
}

- (void)selectImageView:(NSInteger)index
{
    currentPageIndex = (int)index - 1;
    CGSize myViewSize = scrollView.frame.size;
    CGRect rect = CGRectMake((currentPageIndex + 2) * myViewSize.width, 0, myViewSize.width, myViewSize.height);
    if (delegate && [delegate respondsToSelector:@selector(KScrollerViewDidClicked:)]) {
        [scrollView scrollRectToVisible:rect animated:YES];
    }else
    {
        [scrollView scrollRectToVisible:rect animated:NO];
    }
}

- (void)dealloc
{
    
}

@end
