//
//  CarrouterViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/30.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "CarrouterViewController.h"
#import "CarRouterTableViewCell.h"
#import "CarRouterDetailViewController.h"
#import "Carhistorylistentity.h"
@interface CarrouterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSMutableArray *savedatasource;
@end

@implementation CarrouterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}
- (void)initUI{
    self.title = _carmodel.chepaino;
    self.tableview = [[UITableView alloc]initWithFrame:
                      CGRectMake(0,0,Screen_width,Screen_height-(SsafeBarH+(SIphoneX?88:64))) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithRed:246.0/255 green:248.0/255 blue:250.0/255 alpha:1];
    [self.tableview registerNib:[UINib nibWithNibName:@"CarRouterTableViewCell"bundle:nil] forCellReuseIdentifier:@"CELLID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCarhislist)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.mj_header = header;
}
- (void)initData{
    self.datasource = [[NSMutableArray alloc]init];
    self.savedatasource = [[NSMutableArray alloc]init];
    [self requestCarhislist];
}
- (void)requestCarhislist{
    Carhistorylistentity *car = [[Carhistorylistentity alloc]initWithReqType:GhistorylistPost];
    car.token = [OAuthAccountTool account].token;
    car.userid = [OAuthAccountTool account].userid;
    car.qicheid = _carmodel.qicheid;
    car.currentpage = [NSString stringWithFormat:@"%lu",self.savedatasource.count/10+1];;
    car.pagesize = @"10";
    if (self.datasource.count%10 == 0) {
        [JYNetworkTools requestWithEntity:car needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            NSNumber *code = [responseObject safeObjectForKey:@"code"];
            NSInteger codeI = [code integerValue];
            NSString *msg = [responseObject safeObjectForKey:@"msg"];
            if (codeI == 1) {
                [self.savedatasource addObjectsFromArray:[responseObject safeObjectForKey:@"data"]];
                NSMutableArray *date = [self dealwithhistory:[responseObject safeObjectForKey:@"data"]];
                [self.datasource addObjectsFromArray:date];
                [self.tableview reloadData];
            }
            else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
            [self.tableview.mj_header endRefreshing];
        } failed:^(NSError *error) {
            [self.tableview.mj_header endRefreshing];
        }];
    }
    else{
        [self.tableview.mj_header endRefreshing];
    }
}
- (NSMutableArray *)dealwithhistory:(NSMutableArray *)arr{
    NSMutableArray *datearr = [[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSMutableDictionary *dic = [arr[i] mutableCopy];
        NSString *start = [[dic safeObjectForKey:@"starttime"] substringToIndex:[[dic safeObjectForKey:@"starttime"] localizedStandardRangeOfString:@" "].location];
//        start = [start stringByReplacingCharactersInRange:<#(NSRange)#> withString:<#(nonnull NSString *)#>]
        if (!datearr.count) {
            NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
            [d safeSetObject:start forKey:@"date"];
            NSMutableArray *timearr = [[NSMutableArray alloc]init];
            NSString *starttime = [[dic safeObjectForKey:@"starttime"] substringFromIndex:[[dic safeObjectForKey:@"starttime"] localizedStandardRangeOfString:@" "].location+1];
            NSString *endtime = [[dic safeObjectForKey:@"endtime"] substringFromIndex:[[dic safeObjectForKey:@"endtime"] localizedStandardRangeOfString:@" "].location+1];
            NSMutableDictionary *timedic = [[NSMutableDictionary alloc]init];
            [timedic safeSetObject:[dic safeObjectForKey:@"starttime"] forKey:@"starttime"];
            [timedic safeSetObject:[dic safeObjectForKey:@"endtime"] forKey:@"endtime"];
            
            NSMutableArray *startt = [[self rangeOfSubString:@":" inString:starttime] mutableCopy];
            NSRange rangestart = [startt[startt.count-1] rangeValue];
            starttime = [starttime substringToIndex:rangestart.location];
            NSMutableArray *endt = [[self rangeOfSubString:@":" inString:endtime] mutableCopy];
            NSRange rangeend = [endt[startt.count-1] rangeValue];
            endtime = [endtime substringToIndex:rangeend.location];
            
            [timedic safeSetObject:[NSString stringWithFormat:@"%@~%@",starttime,endtime] forKey:@"timearround"];
            [timearr addObject:timedic];
            [d safeSetObject:timearr forKey:@"time"];
            [datearr addObject:d];
        }
        else{
            for (int j = 0; j<datearr.count; j++) {
                NSMutableDictionary *datedic = datearr[j];
                if (![[datedic safeObjectForKey:@"date"] isEqualToString:start]) {
                    NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
                    [d safeSetObject:start forKey:@"date"];
                    NSMutableArray *timearr = [[NSMutableArray alloc]init];
                    NSString *starttime = [[dic safeObjectForKey:@"starttime"] substringFromIndex:[[dic safeObjectForKey:@"starttime"] localizedStandardRangeOfString:@" "].location+1];
                    NSString *endtime = [[dic safeObjectForKey:@"endtime"] substringFromIndex:[[dic safeObjectForKey:@"endtime"] localizedStandardRangeOfString:@" "].location+1];
                    NSMutableDictionary *timedic = [[NSMutableDictionary alloc]init];
                    [timedic safeSetObject:[dic safeObjectForKey:@"starttime"] forKey:@"starttime"];
                    [timedic safeSetObject:[dic safeObjectForKey:@"endtime"] forKey:@"endtime"];
                    
                    NSMutableArray *startt = [[self rangeOfSubString:@":" inString:starttime] mutableCopy];
                    NSRange rangestart = [startt[startt.count-1] rangeValue];
                    starttime = [starttime substringToIndex:rangestart.location];
                    NSMutableArray *endt = [[self rangeOfSubString:@":" inString:endtime] mutableCopy];
                    NSRange rangeend = [endt[startt.count-1] rangeValue];
                    endtime = [endtime substringToIndex:rangeend.location];
                    
                    [timedic safeSetObject:[NSString stringWithFormat:@"%@~%@",starttime,endtime] forKey:@"timearround"];
                    [timearr addObject:timedic];
                    [d safeSetObject:timearr forKey:@"time"];
                    [datearr addObject:d];
                }
                else{
                    NSMutableArray *timearr = [[datedic objectForKey:@"time"] mutableCopy];
                    NSString *starttime = [[dic safeObjectForKey:@"starttime"] substringFromIndex:[[dic safeObjectForKey:@"starttime"] localizedStandardRangeOfString:@" "].location+1];
                    NSString *endtime = [[dic safeObjectForKey:@"endtime"] substringFromIndex:[[dic safeObjectForKey:@"endtime"] localizedStandardRangeOfString:@" "].location+1];
                    NSMutableDictionary *timedic = [[NSMutableDictionary alloc]init];
                    [timedic safeSetObject:[dic safeObjectForKey:@"starttime"] forKey:@"starttime"];
                    [timedic safeSetObject:[dic safeObjectForKey:@"endtime"] forKey:@"endtime"];
                    //去除秒
                    NSMutableArray *startt = [[self rangeOfSubString:@":" inString:starttime] mutableCopy];
                    NSRange rangestart = [startt[startt.count-1] rangeValue];
                    starttime = [starttime substringToIndex:rangestart.location];
                    NSMutableArray *endt = [[self rangeOfSubString:@":" inString:endtime] mutableCopy];
                    NSRange rangeend = [endt[startt.count-1] rangeValue];
                    endtime = [endtime substringToIndex:rangeend.location];
                    
                    [timedic safeSetObject:[NSString stringWithFormat:@"%@~%@",starttime,endtime] forKey:@"timearround"];
                    [timearr addObject:timedic];
                    [datedic setObject:timearr forKey:@"time"];
                }
            }
        }
    }
    return datearr;
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
            
        }
        
    }
    return rangeArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - tableviewdelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = self.datasource[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 43)];//
    view.backgroundColor = [UIColor clearColor];
    //add your code behind
    UILabel *timelab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, Screen_width-30, 20)];
    timelab.text = [dic safeObjectForKey:@"date"];
    NSString *date = [dic safeObjectForKey:@"date"];
    //去除秒
    NSMutableArray *startt = [[self rangeOfSubString:@"/" inString:date] mutableCopy];
    NSRange rangestart = [[startt lastObject] rangeValue];
    NSRange rangestart1 = [[startt firstObject]rangeValue];
    date = [date stringByReplacingCharactersInRange:rangestart1 withString:@"年"];
    date = [date stringByReplacingCharactersInRange:rangestart withString:@"月"];
    date = [date stringByAppendingString:@"日"];
    timelab.text = date;
    timelab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    timelab.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    [view addSubview:timelab];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarRouterDetailViewController *deatil = [[CarRouterDetailViewController alloc]init];
    NSMutableDictionary *dic = [self.datasource[indexPath.section] mutableCopy];
    NSMutableArray *arr = [dic safeObjectForKey:@"time"];
    [dic setObject:arr[indexPath.row] forKey:@"time"];
    deatil.datasource = dic;
    deatil.carmodel = self.carmodel;
    [self.navigationController pushViewController:deatil animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43.0f;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1f;
//}
#pragma mark - tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datasource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *dic = self.datasource[section];
    NSMutableArray *arr = [dic safeObjectForKey:@"time"];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarRouterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"forIndexPath:indexPath];
    NSMutableDictionary *dic = self.datasource[indexPath.section];
    NSMutableArray *arr = [dic safeObjectForKey:@"time"];
    if (indexPath.row==0) {
        cell.cellid = StartId;
    }
    else if(indexPath.row == arr.count-1){
        cell.cellid = EndId;
    }
    else{
        cell.cellid = DefaultId;
    }
    cell.time.text = arr[indexPath.row][@"timearround"];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
