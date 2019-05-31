//
//  JYNavigationController.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/10.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "JYNavigationController.h"

@interface JYNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.tintColor = [UIColor whiteColor];
    
    // 设置导航控制器为手势识别器的代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    UIImage *bgImage = [UIImage imageNamed:@"Background"];
    
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]]; 
}

/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果viewController不是最早push进来的子控制器
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 所有设置搞定后, 再push控制器
    [super pushViewController:viewController animated:animated];
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  手势识别器对象会调用这个代理方法来决定手势是否有效
 *
 *  @return YES : 手势有效, NO : 手势无效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}

@end
