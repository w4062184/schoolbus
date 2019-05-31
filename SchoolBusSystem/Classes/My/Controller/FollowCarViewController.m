//
//  FollowCarViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "FollowCarViewController.h"
#import "FollowcarTableViewCell.h"
#import "CarrouterViewController.h"
#import "Updatecarrentity.h"
#import "CarModel.h"
#import "LPActionSheet.h"
@interface FollowCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView *headerview;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation FollowCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}
- (void)initUI{
    self.headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 67)];
    UILabel *hlabel = [[UILabel alloc] init];
    hlabel.frame = CGRectMake(15, 15, Screen_width-30, 37);
    hlabel.text = @"一个账号最多关注3台车辆动态信息，如已关注3台车辆信息，需首先取消其中的车辆关注才可关注新车辆";
    hlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    hlabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
//    hlabel.textAlignment = NSTextAlignmentCenter;
    hlabel.numberOfLines = 0;
    [self.headerview addSubview:hlabel];
    self.tableview = [[UITableView alloc]initWithFrame:
                      CGRectMake(0,0,Screen_width,Screen_height-(SsafeBarH+(SIphoneX?88:64))) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithRed:246.0/255 green:248.0/255 blue:250.0/255 alpha:1];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, Screen_width, 20);
    label.text = @"无更多车辆信息";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:175.0/255 green:175.0/255 blue:175.0/255 alpha:1];
    self.tableview.tableFooterView = label;
    self.tableview.tableHeaderView = self.headerview;
    [self.tableview registerNib:[UINib nibWithNibName:@"FollowcarTableViewCell"bundle:nil] forCellReuseIdentifier:@"CELLID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableview addGestureRecognizer:longPressGr];
}
- (void)initData{
    self.title = @"关注的车辆";
    self.datasource = [[NSMutableArray alloc]init];
    [self requestcarlist];
}
- (void)requestcarlist{
    [self.datasource removeAllObjects];
    Updatecarrentity *carlist = [[Updatecarrentity alloc]initWithReqType:GetSetCarListPost];
    carlist.token = [OAuthAccountTool account].token;
    carlist.userid = [OAuthAccountTool account].userid;
    [JYNetworkTools requestWithEntity:carlist needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            NSMutableArray *arr = [[CarModel mj_objectArrayWithKeyValuesArray:[responseObject safeObjectForKey:@"data"]] mutableCopy];
            [self.datasource addObjectsFromArray:arr];
            [self.tableview reloadData];
//            Updatecarrentity *carlistccancal = [[Updatecarrentity alloc]initWithReqType:GetCancelCarListPost];
//            carlistccancal.token = [OAuthAccountTool account].token;
//            carlistccancal.userid = [OAuthAccountTool account].userid;
//            [JYNetworkTools requestWithEntity:carlistccancal needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
//                NSLog(@"%@",responseObject);
//                NSNumber *code = [responseObject safeObjectForKey:@"code"];
//                NSInteger codeI = [code integerValue];
//                NSString *msg = [responseObject safeObjectForKey:@"msg"];
//                if (codeI == 1) {
//                    NSMutableArray *arr1 = [[CarModel mj_objectArrayWithKeyValuesArray:[responseObject safeObjectForKey:@"data"]] mutableCopy];
//                    for (int i = 0; i<arr1.count; i++) {
//                        CarModel *dic = arr1[i];
//                        dic.isAllow = @"0";
//                    }
//                    [self.datasource addObjectsFromArray:arr1];
//                    [self.tableview reloadData];
//                }
//                else{
//                    [SVProgressHUD showErrorWithStatus:msg];
//                }
//            } failed:^(NSError *error) {
//
//            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
    
}
- (void)requestdelecarwith:(CarModel *)model andcancal:(BOOL)cancal{
    Updatecarrentity *carlistccancal = [[Updatecarrentity alloc]initWithReqType:cancal?deleteCancelcarPost:DeletecarPost];
    carlistccancal.token = [OAuthAccountTool account].token;
    carlistccancal.userid = [OAuthAccountTool account].userid;
    carlistccancal.qicheid = model.qicheid;
    [JYNetworkTools requestWithEntity:carlistccancal needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [SVProgressHUD showImage:[UIImage imageNamed:@"success"] status:@"删除成功"];
            [self eventAfterDelay:1 andEvent:^{
                [self requestcarlist];
            }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138.0f;
}
#pragma mark - tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarModel *carmodel = self.datasource[indexPath.row];
    FollowcarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"forIndexPath:indexPath];
    cell.followbut.selected = [carmodel.follow isEqualToString:@"1"]?YES:NO;
    [cell.followbut setTitle:@" 已关注" forState:UIControlStateSelected];
    [cell.followbut setTitle:@"+关注" forState:UIControlStateNormal];
    cell.carnumber.text = carmodel.chepaino;
    cell.followbut.tag = indexPath.row;
    [cell.followbut addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    cell.detailbut.tag = indexPath.row;
    [cell.detailbut addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action
- (void)detail:(UIButton *)but
{
    CarrouterViewController *carrouter = [[CarrouterViewController alloc]init];
    NSLog(@"%ld",(long)but.tag);
    carrouter.carmodel = self.datasource[but.tag];
    [self.navigationController pushViewController:carrouter animated:YES];
}
- (void)follow:(UIButton *)but
{
    NSLog(@"%ld",(long)but.tag);
    FollowcarTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:but.tag inSection:0]];
    [self requestupdatecar:!cell.followbut.selected with:self.datasource[but.tag] and:but];
}
- (void)requestupdatecar:(BOOL)isAdd with:(CarModel *)model and:(UIButton *)but{
    Updatecarrentity *car = [[Updatecarrentity alloc]initWithReqType:isAdd?AddcarPost:DeletecarPost];
    car.token = [OAuthAccountTool account].token;
    car.userid = [OAuthAccountTool account].userid;
    car.qicheid = model.qicheid;
    self.view.userInteractionEnabled = NO;
    [JYNetworkTools requestWithEntity:car needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            [SVProgressHUD showImage:[UIImage imageNamed:@"success"] status:isAdd?@"关注成功":@"取消成功"];
//            [SVProgressHUD showSuccessWithStatus:isAdd?@"关注成功":@"取消成功"];
            [self eventAfterDelay:1 andEvent:^{
                [self requestcarlist];
            }];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        self.view.userInteractionEnabled = YES;
    } failed:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
    }];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableview];
        NSIndexPath * indexPath = [self.tableview indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
//        UIAlertController *alertc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alertc addAction:cancelAction];
//        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"删除车辆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"dele");
//        }];
//        [alertc addAction:OKAction];
//
//        [self presentViewController:alertc animated:YES completion:nil];
        
        [LPActionSheet showActionSheetWithTitle:@"确定不再关注该车辆？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除车辆" otherButtonTitles:nil handler:^(LPActionSheet *actionSheet, NSInteger index) {
            NSLog(@"dele%ld",(long)index);
            if (index == -1) {
                CarModel *car = self.datasource[indexPath.row];
                [self requestdelecarwith:car andcancal:[car.follow isEqualToString:@"1"]?NO:YES];
            }
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
kEventAfter
@end
