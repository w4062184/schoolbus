//
//  JYFindPassWordController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/8.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYFindPassWordController.h"
#import "JYResetPassWordController.h"
#import "RegisterEntity.h"

@interface JYFindPassWordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *next;

@end

@implementation JYFindPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"忘记密码";
    self.phone.delegate = self;
    self.verificationCode.delegate = self;
    self.next.userInteractionEnabled = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.phone.text.length&&self.verificationCode.text.length) {
        [self.next setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.next.userInteractionEnabled = YES;
    }
    else{
        [self.next setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.next.userInteractionEnabled = NO;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.next setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    self.next.userInteractionEnabled = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger userlength = self.phone.text.length;
    NSInteger passlength = self.verificationCode.text.length;
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
    if (textField == self.verificationCode) {
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
        [self.next setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.next.userInteractionEnabled = YES;
    }
    else{
        [self.next setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.next.userInteractionEnabled = NO;
    }
    return YES;
}
- (IBAction)next:(UIButton *)sender {
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (!self.verificationCode.text.length) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
//    RegisterEntity *entity = [[RegisterEntity alloc] initWithReqType:RegisterPost];
//    entity.mobile = self.phone.text;
//    entity.Mask = self.verificationCode.text;
//
//    [JYNetworkTools requestWithEntity:entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
//
//        NSNumber *code = [responseObject safeObjectForKey:@"code"];
//        NSInteger codeI = [code integerValue];
//        NSString *msg = [responseObject safeObjectForKey:@"msg"];
//        [SVProgressHUD showErrorWithStatus:msg];
//        if (codeI == 1) {
            JYResetPassWordController *RP = [[JYResetPassWordController alloc] init];
    RP.user = self.phone.text;
    RP.Mask = self.verificationCode.text;
            [self.navigationController pushViewController:RP animated:YES];
//        }
//
//    } failed:^(NSError *error) {
//
//    }];
    
}
- (IBAction)getCode:(id)sender {
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    
    GcodeEntity *entity = [[GcodeEntity alloc] initWithReqType:ChangePost];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
