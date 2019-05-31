//
//  JYConstant.h
//  FpdCarInCube
//
//  Created by WXC on 2017/4/11.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#ifndef JYConstant_h
#define JYConstant_h

#define JYWriteToPlist(data, filename) [data writeToFile:[NSString stringWithFormat:@"%@/%@.plist",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject, filename] atomically:YES];

#define JYCarDetectionWriteToPlist(data, path,filename) [data writeToFile:[NSString stringWithFormat:@"%@/%@.plist",path, filename] atomically:YES];

//#define JYWriteToPlist(data, filename) [data writeToFile:[NSString stringWithFormat:@"%@/%@.plist",@"/Users/wxc/Desktop", filename] atomically:YES];

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI - M_PI_2)

typedef NS_ENUM(NSInteger, RequestType) {
    DefaultType = 0,
    LoginReqPost = 1,
    RegisterPost = 2,
    GcodePost = 3,
    ChangePost = 4,
    CarMessPost = 5,
    GetSetCarListPost = 6,
    GetTextListPost = 7,
    SelectCarPost = 8,
    AddcarPost = 9,
    DeletecarPost = 10,
    AddcarpointPost = 11,
    GcarpointPost = 12,
    GcargpslistPost = 13,
    GhistorygpslistPost = 14,
    GhistorylistPost = 15,
    GAccountPost = 16,
    ChangePasswordPost = 17,
    UpdateRegistrationIdPost = 18,
    deleteCancelcarPost = 19,
    GetCancelCarListPost = 20,
};
typedef NS_ENUM(NSInteger, CellId) {
    DefaultId = 0,
    StartId = 1,
    EndId = 2,
};
typedef NS_ENUM(NSInteger, HttpRequestMethod) {
    JYGet = 0,
    JYPost,
};



#define ISLOGIN                         @"isHaveLogin"             // 登录
#define CarDetectionTime                @"carDetectionTime"
//----------------：延迟执行---------------------
#define kEventAfter \
- (void)eventAfterDelay:(double)delay andEvent:(void(^)(void))event\
{\
[self performSelector:@selector(afterEvent:) withObject:event afterDelay:delay];\
}\
- (void)afterEvent:(void(^)(void))event\
{\
event();\
}
#endif /* JYConstant_h */
