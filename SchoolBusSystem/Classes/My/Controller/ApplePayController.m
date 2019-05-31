//
//  ApplePayController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/1/27.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "ApplePayController.h"
#import <PassKit/PassKit.h>
#import <PassKit/PKAddPaymentPassViewController.h>
#import <AddressBook/AddressBook.h>

@interface ApplePayController ()<PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray * accountlist;// 账户的账单
@property (nonatomic, strong)NSMutableArray * shopway;// 购买的方式</span>

@end

@implementation ApplePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self AccessApplePay]) {
        [self BeginProcess];
    }
}


// 开始之前对设备进行判断
- (BOOL)AccessApplePay
{
    // 判断当前设备支持支付或否
    if (![PKPaymentAuthorizationViewController class]) {
        // 为No的时候，主要是系统不支持，需要在9.0的环境以及iphone6以上机型
        return NO;
    }
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        // 原因同上
        return NO;
    }
    
    // 判断用户是否可进行四种卡片的支付，分别是Amex、MasterCard、Visa与Union四种卡
    NSMutableArray *cardkind = [@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa] mutableCopy];
    if (@available(iOS 9.2, *)) {
        [cardkind addObject:PKPaymentNetworkChinaUnionPay];
    } else {
        // Fallback on earlier versions
    }
    // 下面这步判断的是有没有绑定银行卡
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:cardkind]) {
        NSLog(@"没有绑定卡");
        return NO;
    }
    
    NSLog(@"判断完成");
    return YES;
}


// 达到允许条件之后开始进入流程
- (void)BeginProcess
{
    // 支付卡片的四种选项
    NSMutableArray *cardkind = [@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa] mutableCopy];
    if (@available(iOS 9.2, *)) {
        [cardkind addObject:PKPaymentNetworkChinaUnionPay];
    } else {
        // Fallback on earlier versions
    }
    // 用于支付的卡的种类
    // 设置基本信息
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    payRequest.countryCode = @"CN";         // 国家代码
    payRequest.currencyCode = @"CNY";       // 币种
    
    payRequest.merchantIdentifier = @"merchant.com.joinData.SchoolBusSystem";   // 申请的merchantID
    payRequest.supportedNetworks = cardkind;
    payRequest.merchantCapabilities = PKMerchantCapabilityCredit|PKMerchantCapabilityDebit|PKMerchantCapability3DS|PKMerchantCapabilityEMV;  // 设置支持的交易处理协议
    
//    payRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;  // 送货的信息，设置地址，电话，姓名
    
    // 设置送货方式
    // 免费的快递
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"EMS包邮" amount:[NSDecimalNumber zero]];
    freeShipping.identifier = @"freeshipping";
    freeShipping.detail = @"4-6 天";
    // 需要加钱的快递
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"顺丰速运" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    expressShipping.identifier = @"expressshipping";
    expressShipping.detail = @"2-3 天";
    // 在这里使用到了_shopway的数组
    _shopway = [NSMutableArray arrayWithArray:@[freeShipping, expressShipping]];
    //shippingMethods为配送方式列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行配送方式的调整。
//    payRequest.shippingMethods = _shopway;
    
    NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:10000 exponent:-5 isNegative:NO];// 小数点后两位1000.00
    PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"商品价格" amount:subtotalAmount];
    
    NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:@"-10"];      // 折扣10
    PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"折扣" amount:discountAmount];
    
    NSDecimalNumber *methodsAmount = [NSDecimalNumber zero];
    PKPaymentSummaryItem *methods = [PKPaymentSummaryItem summaryItemWithLabel:@"EMS包邮" amount:methodsAmount];
    
    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
    totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
//    totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
//    totalAmount = [totalAmount decimalNumberByAdding:methodsAmount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"喵喵的账户~" amount:totalAmount];// 收款方名字，账户
//    _accountlist = [NSMutableArray arrayWithArray:@[subtotal, discount, methods, total]];
    _accountlist = [NSMutableArray arrayWithArray:@[subtotal, total]];
    //_accountlist是存放账单的可变数组，后续的代理中可以进行支付金额的调整。
    payRequest.paymentSummaryItems = _accountlist;
    
    
    // 启用ApplePay的页面控件
    PKPaymentAuthorizationViewController *view = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}


#pragma mark 支付的代理设置
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                  didSelectShippingContact:(PKContact *)contact
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    //contact送货地址信息，PKContact类型
    NSPersonNameComponents *name = contact.name;                //联系人 姓名
    CNPostalAddress *postalAddress = contact.postalAddress;     //联系人 地址
    NSString *emailAddress = contact.emailAddress;              //联系人 邮箱
    CNPhoneNumber *phoneNumber = contact.phoneNumber;           //联系人 手机
    NSString *supplementarySubLocality = contact.supplementarySubLocality;
    
    completion(PKPaymentAuthorizationStatusSuccess, _shopway, _accountlist);
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    // 送货方式回调，如果需要根据不同的送货方式进行支付金额的调整，比如EMS包邮和付费顺丰配送，可以实现该代理
    PKShippingMethod *oldShippingMethod = [_accountlist objectAtIndex:2];
    PKPaymentSummaryItem *total = [_accountlist lastObject];
    total.amount = [total.amount decimalNumberBySubtracting:oldShippingMethod.amount];
    total.amount = [total.amount decimalNumberByAdding:shippingMethod.amount];
    
    [_accountlist replaceObjectAtIndex:2 withObject:shippingMethod];
    [_accountlist replaceObjectAtIndex:3 withObject:total];
    
    completion(PKPaymentAuthorizationStatusSuccess, _accountlist);
}

// 支付银行卡回调，看情况根据不同的银行调整，然后付费金额
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod completion:(void (^)(NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    
    completion(_accountlist);
}

// 送货地址的回调
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion{
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    // 支付验证
    PKPaymentToken *payToken = payment.token; // 与服务器验证支付是否有效
    
    PKContact *billingContact = payment.billingContact;     //账单信息
    PKContact *shippingContact = payment.shippingContact;   //送货信息
    PKContact *shippingMethod = payment.shippingMethod;     //送货方式
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        completion(PKPaymentAuthorizationStatusSuccess);
    });
    
    
}
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
