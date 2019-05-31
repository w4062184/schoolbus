//
//  JYURLManager.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/11.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "JYURLManager.h"


@implementation JYURLManager


+ (NSString *)URLOfEntity:(JYBaseEntity *)entity
{
    NSString *url = nil;
    RequestType type = entity.reqType;
    switch (type)
    {
        case RegisterPost:
        {
            url = UserReg;
        }
            break;
            
        case GcodePost:
        {
            url = userGcode;
        }
            break;
            
        case LoginReqPost:
        {
            url = UserLogin;
        }
            break;
        case ChangePost:
        {
            url = ChangePswd;
        }
             break;
        case CarMessPost:
        {
            url = CarMess;
        }
             break;
        case  GetSetCarListPost:
        {
            url = GetSetCarList;
        }
             break;
        case  GetTextListPost:
        {
            url = GetTextList;
        }
             break;
        case  SelectCarPost:
        {
            url = selectcar;
        }
             break;
        case  AddcarPost:
        {
            url = addcar;
        }
             break;
        case  DeletecarPost:
        {
            url = deletecar;
        }
             break;
        case  AddcarpointPost:
        {
            url = addcarpoint;
        }
             break;
        case  GcarpointPost:
        {
            url = Gcarpoint;
        }
             break;
        case  GcargpslistPost:
        {
            url = Gcargpslist;
        }
             break;
        case  GhistorygpslistPost:
        {
            url = Ghistorygpslist;
        }
             break;
        case  GhistorylistPost:
        {
            url = Ghistorylist;
        }
             break;
        case  GAccountPost:
        {
            url = GAccount;
        }
            break;
        case  ChangePasswordPost:
        {
            url = ChangePassword;
        }
            break;
        case  UpdateRegistrationIdPost:
        {
            url = UpdateRegistrationId;
        }
            break;
        case  deleteCancelcarPost:
        {
            url = deleteCancelcar;
        }
            break;
        case  GetCancelCarListPost:
        {
            url = GetCancelCarList;
        }
            break;
        default:
            break;
    }
    
    return url;
}

@end
