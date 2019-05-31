//
//  MyViewController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/1/29.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "MyViewController.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"
#import <PassKit/PassKit.h>
#import "BraintreeApplePay.h"
#import "BraintreeCard.h"
#import "Mycarwait.h"
#import "Myaddress.h"
#import "FollowCar.h"
#import "BuyPay.h"
#import "Logoutview.h"
#import "NoteViewController.h"
#import "KYViewController.h"
#import "FollowCarViewController.h"
#import "PayViewController.h"
#import "RegistrationIdEntity.h"
@interface MyViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) BTAPIClient *braintreeClient;
/* header视图 */
@property (nonatomic, strong) UIView *headerview;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:@"sandbox_bbbvcxg6_wv7y835yvnc8yb33"];
    
    // Conditionally show Apple Pay button based on device availability
//    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex,PKPaymentNetworkChinaUnionPay]]) {
//        UIButton *button = [self applePayButton];
//        // TODO: Add button to view and set its constraints/frame...
//        button.frame = CGRectMake(0, 100, Screen_width, 100);
//         [self.view addSubview:button];
//    }
    [self intData];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self addmoreview];
}
- (void)initUI{
    _headerview = [[UIView alloc]init];
    _headerview.frame = CGRectMake(0,0 , Screen_width, SstatusBarH+180);
    UIImageView *imagev = [[UIImageView alloc]init];
    imagev.frame = CGRectMake(0,0 , Screen_width, SstatusBarH+180);
    imagev.image = [UIImage imageNamed:@"个人信息"];
    [_headerview addSubview:imagev];
    
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, SstatusBarH, Screen_width, 44);
    navView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(Screen_width/2 - 120, 0, 240, 44);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    titleLabel.text = NSLocalizedString(@"个人中心", nil);
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"navigationButtonReturn3"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(11.5, 11.67, 11.5, 19.33);
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    UIButton *notebut = [[UIButton alloc]init];
    notebut.frame = CGRectMake(Screen_width-15-19, 12, 19, 22);
    [notebut setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    notebut.adjustsImageWhenHighlighted = NO;
    [notebut addTarget:self action:@selector(note) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:notebut];
    
    UILabel *notelab = [[UILabel alloc]init];
    notelab.frame = CGRectMake(Screen_width-12-8, 13, 8, 8);
    notelab.backgroundColor = JYColor(248, 68, 65);
    notelab.layer.cornerRadius = 4.0f;
    notelab.layer.masksToBounds = YES;
    notelab.hidden = YES;
    [navView addSubview:notelab];
    
    [_headerview addSubview:navView];
    
    UIButton *headerbut = [UIButton buttonWithType:UIButtonTypeCustom];
    headerbut.frame = CGRectMake(Screen_width/2-30, SstatusBarH+14+50, 60, 60);
    [headerbut setImage:[UIImage imageNamed:@"icon-默认头像"] forState:UIControlStateNormal];
    headerbut.adjustsImageWhenHighlighted = NO;
    [headerbut addTarget:self action:@selector(headerbut) forControlEvents:UIControlEventTouchUpInside];
    [_headerview addSubview:headerbut];
    
    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, SstatusBarH+14+50+60+20, Screen_width, 36);
    CGSize size = [[[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNo"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"SFNSDisplay" size:19],NSFontAttributeName,nil]];
    label.frame = CGRectMake(0, SstatusBarH+14+50+60+20, Screen_width, size.height);
    label.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNo"];
    label.font = [UIFont fontWithName:@"SFNSDisplay" size:19];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
    [_headerview addSubview:label];
    [self.view addSubview:_headerview];
    
}
- (void)addmoreview{
    Mycarwait *my = [self.view viewWithTag:0];
    Myaddress *address = [self.view viewWithTag:1];
    FollowCar *follow = [self.view viewWithTag:2];
    BuyPay *pay = [self.view viewWithTag:3];
    Logoutview *logout = [self.view viewWithTag:4];
    
    [my removeFromSuperview];
    [address removeFromSuperview];
    [follow removeFromSuperview];
    [pay removeFromSuperview];
    [logout removeFromSuperview];
    
    Mycarwait *mycarview = [[NSBundle mainBundle] loadNibNamed:@"Mycarwait" owner:nil options:nil].lastObject;
    mycarview.frame = CGRectMake(0, SstatusBarH+180, Screen_width, 50);
    mycarview.tag = 0;
    [mycarview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mycarview];
    
    if ([OAuthAccountTool account].pointAddress&&![[OAuthAccountTool account].pointAddress isEqualToString:@""]) {
        Myaddress *myaddress = [[NSBundle mainBundle] loadNibNamed:@"Myaddress" owner:nil options:nil].lastObject;
        myaddress.tag = 1;
        myaddress.frame = CGRectMake(0, SstatusBarH+180+50+1, Screen_width, 50);
        myaddress.addresslab.text = [OAuthAccountTool account].pointAddress;
        [self.view addSubview:myaddress];
        
        FollowCar *followcarview = [[NSBundle mainBundle] loadNibNamed:@"FollowCar" owner:nil options:nil].lastObject;
        followcarview.frame = CGRectMake(0, SstatusBarH+180+100+15, Screen_width, 50);
        followcarview.tag = 2;
        [followcarview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:followcarview];
        
        BuyPay *payview = [[NSBundle mainBundle] loadNibNamed:@"BuyPay" owner:nil options:nil].lastObject;
        payview.frame = CGRectMake(0, SstatusBarH+180+150+30, Screen_width, 50);
        payview.tag = 3;
        [payview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payview];
        
        Logoutview *logoutview = [[NSBundle mainBundle] loadNibNamed:@"Logoutview" owner:nil options:nil].lastObject;
        logoutview.frame = CGRectMake(0, SstatusBarH+180+200+45, Screen_width, 50);
        logoutview.tag = 4;
        [logoutview.seletBut addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logoutview];
    }
    else{
        FollowCar *followcarview = [[NSBundle mainBundle] loadNibNamed:@"FollowCar" owner:nil options:nil].lastObject;
        followcarview.frame = CGRectMake(0, SstatusBarH+180+50+15, Screen_width, 50);
        followcarview.tag = 2;
        [followcarview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:followcarview];
        
        BuyPay *payview = [[NSBundle mainBundle] loadNibNamed:@"BuyPay" owner:nil options:nil].lastObject;
        payview.frame = CGRectMake(0, SstatusBarH+180+100+30, Screen_width, 50);
        payview.tag = 3;
        [payview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payview];
        
        Logoutview *logoutview = [[NSBundle mainBundle] loadNibNamed:@"Logoutview" owner:nil options:nil].lastObject;
        logoutview.frame = CGRectMake(0, SstatusBarH+180+150+45, Screen_width, 50);
        logoutview.tag = 4;
        [logoutview.seletBut addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logoutview];
    }
}
- (void)intData{
    
}

- (UIButton *)applePayButton {
    UIButton *button;
    
    if ([PKPaymentButton class]) { // Available in iOS 8.3+
        button = [PKPaymentButton buttonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleWhiteOutline];
    } else {
        // TODO: Create and return your own apple pay button
        // button = ...
    }
    
    [button addTarget:self action:@selector(tappedApplePay) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (IBAction)tappedApplePay {
//    PKPaymentRequest *paymentRequest = [self paymentRequest];
//    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//    vc.delegate = self;
//    [self presentViewController:vc animated:YES completion:nil];
    BTAPIClient *braintreeClient = [[BTAPIClient alloc] initWithAuthorization:@"sandbox_bbbvcxg6_wv7y835yvnc8yb33"];
    BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient:braintreeClient];
    BTCard *card = [[BTCard alloc] initWithNumber:@"4111111111111111"
                                  expirationMonth:@"12"
                                   expirationYear:@"2018"
                                              cvv:nil];
    [cardClient tokenizeCard:card
                  completion:^(BTCardNonce *tokenizedCard, NSError *error) {
                      // Communicate the tokenizedCard.nonce to your server, or handle error
                  }];
}


- (PKPaymentRequest *)paymentRequest {
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = @"merchant.com.joinData.SchoolBusSystem";
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard,PKPaymentNetworkChinaUnionPay];
    paymentRequest.merchantCapabilities = PKMerchantCapabilityCredit|PKMerchantCapabilityDebit|PKMerchantCapability3DS|PKMerchantCapabilityEMV;
    paymentRequest.countryCode = @"CN"; // e.g. US
    paymentRequest.currencyCode = @"CNY"; // e.g. USD
    paymentRequest.paymentSummaryItems =
    @[
      [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]],
      // Add add'l payment summary items...
//      [PKPaymentSummaryItem summaryItemWithLabel:@"COMPANY_NAME" amount:[NSDecimalNumber decimalNumberWithString:@"GRAND_TOTAL"]]
      ];
    return paymentRequest;
}

- (IBAction)show:(UIButton *)sender {
    
//    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJmZjc5ZjA5OGZjY2RlNTJkYTA5OGMyNmM4YTEwMDUzMDZhNjhhM2FlZmU5ZmYyNTdhMzcxY2VjOTY5MjgyZmU1fGNyZWF0ZWRfYXQ9MjAxOC0wMS0yOVQwOToyMjo0OC4xNzI4MDI1NTYrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
//
//    [self showDropIn:clientToken];
    RegistrationIdEntity *registration = [[RegistrationIdEntity alloc]initWithReqType:UpdateRegistrationIdPost];
    registration.userid = [OAuthAccountTool account].userid;
    registration.token = [OAuthAccountTool account].token;
    registration.registrationid = @"";
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
    [OAuthAccountTool removeAccount];// 移除登录状态
    [OAuthAccountTool account].pointAddress = @"";
    [OAuthAccountTool account].pointcoordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    [[UIApplication sharedApplication].keyWindow switchRootViewController];
//    PKPaymentRequest *paymentRequest = [self paymentRequest];
//    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//    vc.delegate = self;
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
        }
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}



- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    NSURL *paymentURL = [NSURL URLWithString:@"https://your-server.example.com/checkout"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    request.HTTPBody = [[NSString stringWithFormat:@"payment_method_nonce=%@", paymentMethodNonce] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle success and failure
    }] resume];
}


- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    // Example: Tokenize the Apple Pay payment
    BTApplePayClient *applePayClient = [[BTApplePayClient alloc]
                                        initWithAPIClient:self.braintreeClient];
    [applePayClient tokenizeApplePayPayment:payment
                                 completion:^(BTApplePayCardNonce *tokenizedApplePayPayment,
                                              NSError *error) {
                                     if (tokenizedApplePayPayment) {
                                         // On success, send nonce to your server for processing.
                                         // If applicable, address information is accessible in `payment`.
                                         NSLog(@"nonce = %@", tokenizedApplePayPayment.nonce);
                                         
                                         // Then indicate success or failure via the completion callback, e.g.
                                         completion(PKPaymentAuthorizationStatusSuccess);
                                     } else {
                                         // Tokenization failed. Check `error` for the cause of the failure.
                                         
                                         // Indicate failure via the completion callback:
                                         completion(PKPaymentAuthorizationStatusFailure);
                                     }
                                 }];
}

// Be sure to implement -paymentAuthorizationViewControllerDidFinish:
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - action
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)note{
    NoteViewController *note = [[NoteViewController alloc]init];
    [self.navigationController pushViewController:note animated:YES];
}
- (void)headerbut{
    
}
- (void)seletview:(UIButton *)button{
//    KYViewController *pay = [[KYViewController alloc] init];
//    [self.navigationController pushViewController:pay animated:YES];
    if ([button.superview isKindOfClass:[FollowCar class]]) {
        FollowCarViewController *f = [[FollowCarViewController alloc]init];
        [self.navigationController pushViewController:f animated:YES];
    }
    if ([button.superview isKindOfClass:[Mycarwait class]]) {
        HomeController *pay = [[HomeController alloc] init];
        pay.issetCar = YES;
        [self.navigationController pushViewController:pay animated:YES];
    }
    if ([button.superview isKindOfClass:[BuyPay class]]) {
        PayViewController *pay = [[PayViewController alloc] init];
        [self.navigationController pushViewController:pay animated:YES];
    }
    
}

@end
