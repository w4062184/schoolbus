//
//  RegisterController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/2/5.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterEntity.h"
#import "JYLoginEntity.h"
#import "RegistrationIdEntity.h"
@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UIButton *registerbtn;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册";
    self.phone.delegate = self;
    self.passWord.delegate = self;
    self.verificationCode.delegate = self;
    self.registerbtn.userInteractionEnabled = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.phone.text.length&&self.passWord.text.length&&self.verificationCode.text.length) {
        [self.registerbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.registerbtn.userInteractionEnabled = YES;
    }
    else{
        [self.registerbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.registerbtn.userInteractionEnabled = NO;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.registerbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    self.registerbtn.userInteractionEnabled = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger userlength = self.phone.text.length;
    NSInteger passlength = self.passWord.text.length;
    NSInteger codelength = self.verificationCode.text.length;
    if (textField == self.phone) {
        if (!userlength) {
            userlength = userlength+string.length;
        }
        else{
            if (range.location) {
                userlength = userlength+string.length;
            }
            else{
                userlength = userlength-([string isEqualToString:@""]?1:string.length);
            }
        }
    }
    if (textField == self.passWord) {
        if (!passlength) {
            passlength = passlength+string.length;
        }
        else{
            if (range.location) {
                passlength = passlength+string.length;
            }
            else{
                passlength = passlength-([string isEqualToString:@""]?1:string.length);
            }
        }
    }
    if (textField == self.verificationCode) {
        if (!codelength) {
            codelength = codelength+string.length;
        }
        else{
            if (range.location) {
                codelength = codelength+string.length;
            }
            else{
                codelength = codelength-([string isEqualToString:@""]?1:string.length);
            }
        }
    }
    if (userlength&&passlength&&codelength) {
        [self.registerbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.registerbtn.userInteractionEnabled = YES;
    }
    else{
        [self.registerbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.registerbtn.userInteractionEnabled = NO;
    }
    return YES;
}

- (IBAction)getCode:(UIButton *)sender {
   
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    
    GcodeEntity *entity = [[GcodeEntity alloc] initWithReqType:GcodePost];
    entity.mobile = self.phone.text;
    [JYNetworkTools requestWithEntity:entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            NSArray *data = [responseObject safeObjectForKey:@"data"];
            NSDictionary *dic = data.firstObject;
//            self.verificationCode.text = [dic safeObjectForKey:@"mask"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}

- (IBAction)reg:(UIButton *)sender {
    
    
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (!self.passWord.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    RegisterEntity *entity = [[RegisterEntity alloc] initWithReqType:RegisterPost];
    entity.mobile = self.phone.text;
    entity.password = self.passWord.text;
    entity.Mask = self.verificationCode.text;
    
    [JYNetworkTools requestWithEntity:entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {

        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        
        if (codeI == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
            [self requestlogin];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }

    } failed:^(NSError *error) {
        
    }];
}
- (void)requestlogin{
    JYLoginEntity *entity = [[JYLoginEntity alloc] initWithReqType:LoginReqPost];
    entity.mobile = self.phone.text;
    entity.password = self.passWord.text;
    [JYNetworkTools requestWithEntity:entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:self.phone.text forKey:@"phoneNo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [OAuthAccountTool saveAccount:responseObject];
            [OAuthAccountTool saveIsLogin];// 保存登录状态
            [self requestregistration];
            [[UIApplication sharedApplication].keyWindow switchRootViewController];
        }
        else{
            if (codeI == 0) {
                [SVProgressHUD showErrorWithStatus:@"操作失败，网络或服务出错"];
            }
            else if (codeI == -1) {
                [SVProgressHUD showErrorWithStatus:@"参数异常"];
            }
            else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
            
        }
        
    } failed:^(NSError *error) {
        
    }];
}
- (void)requestregistration{
    RegistrationIdEntity *registration = [[RegistrationIdEntity alloc]initWithReqType:UpdateRegistrationIdPost];
    registration.userid = [OAuthAccountTool account].userid;
    registration.token = [OAuthAccountTool account].token;
    registration.registrationid = [[NSUserDefaults standardUserDefaults]objectForKey:@"registrationId"];
    [JYNetworkTools requestWithEntity:registration needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
        }
        else{
        }
        
    } failed:^(NSError *error) {
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
