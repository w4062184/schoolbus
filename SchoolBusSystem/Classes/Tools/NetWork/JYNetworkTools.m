//
//  JYNetworkTools.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/10.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "JYNetworkTools.h"


@implementation JYNetworkTools

+ (void)requestWithEntity:(JYBaseEntity *)entity needHud:(BOOL)isNeedHud needDismiss:(BOOL)isNeedDismiss success:(void(^)(id responseObject))success failed:(void(^)(NSError *error))failure
{
    // 判断网络
    BOOL isNetAvailable = [self isConnectionAvailable];
    if (!isNetAvailable) {
        [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络连接"];
        failure(nil);
        return;
    }
    // 请求方法
    HttpRequestMethod reqMthod = [self getRequestMethod:entity.reqType];
    // 数据打包
    NSDictionary *params = [entity package:entity.reqType];
    // 请求url
    NSString *url = [JYURLManager URLOfEntity:entity];
    // 头部信息
    NSDictionary *headerDic = nil;
    if (entity.reqType != LoginReqPost)
    {
//        headerDic = [JYOAuthAccountTool getHeaderDic];
    }
        
    //1.获得请求管理者
    AFHTTPSessionManager *mgr = nil;
    if (entity.mgr) {
        mgr = entity.mgr;
        [mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
    else
    {
        mgr = [AFHTTPSessionManager manager];
    }
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    // 设置请求头信息
    [headerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mgr.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    if (isNeedHud) {
       [SVProgressHUD showWithStatus:@"加载中..."];
    }
    

    switch (reqMthod) {
        case JYGet:
        {
            [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 处理返回结果
                [self dealSuccess:success andResponseObject:responseObject andEntity:entity needDismiss:isNeedDismiss];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    // 处理报错
                    [self dealError:error];
                }
            }];
        }
            break;
            
        case JYPost:
        {
            [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 处理返回结果
                [self dealSuccess:success andResponseObject:responseObject andEntity:entity needDismiss:isNeedDismiss];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                    // 处理报错
                    [self dealError:error];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 处理返回结果
+ (void)dealSuccess:(void(^)(id responseObject))success andResponseObject:(id)responseObject andEntity:(JYBaseEntity *)entity needDismiss:(BOOL)isNeedDismiss
{
    if (isNeedDismiss) {
        [SVProgressHUD dismiss];
    }

    if (success) {
        success(responseObject);
    }

}

#pragma mark - 处理报错
+ (void)dealError:(NSError *)error
{
    [SVProgressHUD dismiss];
//    NSHTTPURLResponse *head = error.userInfo[@"com.alamofire.serialization.response.error.response"];
//    JYLog(@"%@",head.allHeaderFields);
//    JYLog(@"%zi",head.statusCode);
//    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//    if (data) {
//        NSDictionary *body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        if ([body isKindOfClass:[NSDictionary class]]) {
//            NSNumber *State = [body safeObjectForKey:@"State"];
//            NSInteger state = [State integerValue];
//            if (state == 10) {
//                [JYUtils logOut];
//            }
//            else if (state == 11 || state == 12) {
//                [SVProgressHUD showErrorWithStatus:[body safeObjectForKey:@"Message"]];
//                [JYUtils logOut];
//            }
//            else
//            {
//                if (head.statusCode == 500) {
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"错误码:%zi  网络错误，请稍后重试...",head.statusCode]];
//                }
//                else
//                {
//                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"错误码:%zi  %@",head.statusCode,[body safeObjectForKey:@"Message"]]];
//                }
//
//            }
//        }
//    }
    
}

#pragma mark - 判断请求方法
+ (HttpRequestMethod)getRequestMethod:(RequestType)type
{
    HttpRequestMethod reqMthod;
    switch (type) {
        case DefaultType:
        {
            reqMthod = JYPost;
        }
            break;

        default:
            reqMthod = JYPost;
            break;
    }

    return reqMthod;
}


//检查网络
+ (BOOL)isConnectionAvailable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        JYLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


@end
