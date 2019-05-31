//
//  JYResetPassWordController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/3/8.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "JYResetPassWordController.h"
#import "PswdEntity.h"
@interface JYResetPassWordController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPswd;
@property (weak, nonatomic) IBOutlet UITextField *Pswd;
@property (weak, nonatomic) IBOutlet UIButton *okbtn;

@end

@implementation JYResetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改密码";
    self.oldPswd.delegate = self;
    self.Pswd.delegate = self;
    self.okbtn.userInteractionEnabled = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.oldPswd.text.length&&self.Pswd.text.length) {
        [self.okbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.okbtn.userInteractionEnabled = YES;
    }
    else{
        [self.okbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.okbtn.userInteractionEnabled = NO;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.okbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    self.okbtn.userInteractionEnabled = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger userlength = self.oldPswd.text.length;
    NSInteger passlength = self.Pswd.text.length;
    if (textField == self.oldPswd) {
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
    if (textField == self.Pswd) {
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
        [self.okbtn setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
        self.okbtn.userInteractionEnabled = YES;
    }
    else{
        [self.okbtn setBackgroundImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
        self.okbtn.userInteractionEnabled = NO;
    }
    return YES;
}
- (IBAction)resetpswd:(id)sender {
    if (!self.oldPswd.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (!self.Pswd.text.length) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (![self.oldPswd.text isEqual:self.Pswd.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码不一致"];
        return;
    }
    PswdEntity *entity = [[PswdEntity alloc] initWithReqType:GAccountPost];
    entity.mobile = self.user;
    entity.Pswd = self.Pswd.text;
    entity.Mask = self.Mask;
    
    [JYNetworkTools requestWithEntity:entity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        
        if (codeI == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
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
