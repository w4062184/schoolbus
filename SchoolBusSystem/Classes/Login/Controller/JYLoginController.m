//
//  JYLoginController.m
//  FpdCarInCube
//
//  Created by WXC on 2017/4/10.
//  Copyright © 2017年 jiaoyin. All rights reserved.
//

#import "JYLoginController.h"
#import "JYLoginEntity.h"
#import "JYFindPassWordController.h"
#import "RegisterController.h"
#import "RegistrationIdEntity.h"

@interface JYLoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassWord;
@property (weak, nonatomic) IBOutlet UIButton *login;
/** <#variate#> */
@property (nonatomic, strong) JYLoginEntity *entity;


@end

@implementation JYLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forgetPassWord.titleLabel.textColor = JYCommonColor;
    self.entity = [[JYLoginEntity alloc] initWithReqType:LoginReqPost];
    self.UserName.delegate = self;
    self.PassWord.delegate = self;
    self.login.userInteractionEnabled = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.UserName.text.length&&self.PassWord.text.length) {
        [self.login setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.login.userInteractionEnabled = YES;
    }
    else{
        [self.login setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.login.userInteractionEnabled = NO;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.login setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    self.login.userInteractionEnabled = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger userlength = self.UserName.text.length;
    NSInteger passlength = self.PassWord.text.length;
    if (textField == self.UserName) {
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
    if (textField == self.PassWord) {
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
    if (userlength&&passlength) {
        [self.login setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.login.userInteractionEnabled = YES;
    }
    else{
        [self.login setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.login.userInteractionEnabled = NO;
    }
    return YES;  
}
#pragma mark - 网络处理
- (IBAction)login:(UIButton *)sender {

    if (!self.UserName.text.length) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (!self.PassWord.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    _entity.mobile = self.UserName.text;
    _entity.password = self.PassWord.text;
    [JYNetworkTools requestWithEntity:_entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:self.UserName.text forKey:@"phoneNo"];
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
- (IBAction)forgetPassWord:(UIButton *)sender {
    JYFindPassWordController *findP = [[JYFindPassWordController alloc] init];
    [self.navigationController pushViewController:findP animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)registerUser:(UIButton *)sender {
    
    RegisterController *reg = [[RegisterController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
}



@end
