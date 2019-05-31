//
//  PayViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "Payheaderview.h"
#import "Payfooterview.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) Payheaderview *header;
@property (nonatomic, strong) Payfooterview *footer;
@property (nonatomic, assign) NSInteger selepay;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"充值";
    [self initUI];
    [self initData];
}
- (void)initUI{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0,Screen_width,Screen_height-(SsafeBarH+(SIphoneX?88:64)))
                                                 style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithRed:246.0/255 green:248.0/255 blue:250.0/255 alpha:1];
    Payheaderview *header = [[NSBundle mainBundle] loadNibNamed:@"Payheaderview" owner:nil options:nil].lastObject;
    header.frame = CGRectMake(0, 0, Screen_width, 208);
//    [mycarview.seletBut addTarget:self action:@selector(seletview:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = @"¥189";
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    //设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, 1)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32.0] range:NSMakeRange(1, str.length-1)];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:JYColorA(255, 175, 4, 1) range:NSMakeRange(0, str.length)];
    header.onemoney.attributedText = attrStr;
    header.onesele.selected = YES;
    header.onesele.tag = 1;
    [header.onesele addTarget:self action:@selector(paymoney:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str1 = @"¥99";
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attrStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, 1)];
    [attrStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32.0] range:NSMakeRange(1, str1.length-1)];
    [attrStr1 addAttribute:NSForegroundColorAttributeName value:JYColorA(255, 175, 4, 1) range:NSMakeRange(0, str1.length)];
    header.twomoney.attributedText = attrStr1;
    header.twosele.selected = NO;
    header.twosele.tag = 2;
    [header.twosele addTarget:self action:@selector(paymoney:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str2 = @"¥19";
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attrStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, 1)];
    [attrStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:32.0] range:NSMakeRange(1, str2.length-1)];
    [attrStr2 addAttribute:NSForegroundColorAttributeName value:JYColorA(255, 175, 4, 1) range:NSMakeRange(0, str2.length)];
    header.threemoney.attributedText = attrStr2;
    header.threesele.selected = NO;
    header.threesele.tag = 3;
    [header.threesele addTarget:self action:@selector(paymoney:) forControlEvents:UIControlEventTouchUpInside];
    
    self.header = header;
    self.tableview.tableHeaderView = self.header;
    Payfooterview *footer = [[NSBundle mainBundle] loadNibNamed:@"Payfooterview" owner:nil options:nil].lastObject;
    footer.frame = CGRectMake(0, 0, Screen_width, 150);
    self.footer = footer;
    self.tableview.tableFooterView = self.footer;
    [self.tableview registerNib:[UINib nibWithNibName:@"PayTableViewCell"bundle:nil] forCellReuseIdentifier:@"CELLID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}
- (void)initData{
    self.selepay = 0;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"forIndexPath:indexPath];
    cell.select.selected = (self.selepay != indexPath.row)?NO:YES;
    cell.imagev.image = indexPath.row == 1?[UIImage imageNamed:@"icon-paypal1"]:[UIImage imageNamed:@"icon-paypal"];
    cell.name.text = indexPath.row == 1?@"Apple Pay":@"PayPal";
    cell.select.tag = indexPath.row;
    [cell.select addTarget:self action:@selector(payway:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)paymoney:(UIButton *)but{
    self.header.onesele.selected = but.tag == 1?YES:NO;
    self.header.twosele.selected = but.tag == 2?YES:NO;
    self.header.threesele.selected = but.tag == 3?YES:NO;
}
- (void)payway:(UIButton *)but{
    self.selepay = but.tag;
    [self.tableview reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
