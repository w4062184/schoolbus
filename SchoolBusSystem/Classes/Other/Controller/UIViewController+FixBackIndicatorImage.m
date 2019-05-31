//
//  UIViewController+FixBackIndicatorImage.m
//  CoreText
//
//  Created by EEKA on 16/8/25.
//  Copyright © 2016年 EEKA. All rights reserved.
//

#import "UIViewController+FixBackIndicatorImage.h"
#import <objc/runtime.h>

static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@interface UINavigationBar (layoutBackFrame)

@end

@implementation UINavigationBar (layoutBackFrame)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzleSelector  = @selector(mf_layoutSubviews);
        swizzling_exchangeMethod(self, originalSelector,swizzleSelector);
        
    });
}


-(void)mf_layoutSubviews
{
    [self mf_layoutSubviews];
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackIndicatorView"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect frame = [view frame];
            frame.origin.x = 14;
            
            [view setFrame:frame];
        }

    }
//    if (@available(iOS 11.0, *)) {
//        self.layoutMargins = UIEdgeInsetsZero;
//        for (UIView *view in [self subviews]) {
//            
//            if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
//                
//                view.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
//            }
//            
//        }
//    }
}

@end

@implementation UIViewController (FixBackIndicatorImage)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL needsDisplaOriginalSelector = @selector(viewWillAppear:);
        SEL needsDisplaSwizzleSelector  = @selector(mf_viewWillAppear:);
        swizzling_exchangeMethod(self, needsDisplaOriginalSelector,needsDisplaSwizzleSelector);
        
    });
}

-(void)mf_viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    [self mf_viewWillAppear:animated];
    
}


@end
