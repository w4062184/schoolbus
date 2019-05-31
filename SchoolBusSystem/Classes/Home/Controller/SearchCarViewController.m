//
//  SearchCarViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/29.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "SearchCarViewController.h"
#import "Searchcarview.h"
#import "CarSearchTableViewCell.h"
#import "CarListentity.h"
#import "Updatecarrentity.h"
#import "SearchCarModel.h"

@interface SearchCarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerview;
@property (weak, nonatomic) IBOutlet UISearchBar *cancal;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation SearchCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    Searchcarview *seaview = [[NSBundle mainBundle] loadNibNamed:@"Searchcarview" owner:nil options:nil].lastObject;
//    seaview.frame = CGRectMake(0, 5, self.view.frame.size.width, 56);
//    seaview.backgroundColor = [UIColor redColor];
//    [seaview.cancal addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:seaview];
    [self initUI];
    [self initData];
}
- (void)initUI{
    self.tableview = [[UITableView alloc]initWithFrame:
                      CGRectMake(0,
                                 self.headerview.frame.size.height+self.headerview.frame.origin.y+(SIphoneX?24:0),
                                 Screen_width,
                                 Screen_height-(self.headerview.frame.size.height+self.headerview.frame.origin.y+(SIphoneX?24:0)))
                                                 style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor colorWithRed:246.0/255 green:248.0/255 blue:250.0/255 alpha:1];
    UIView *h = [[UIView alloc]init];
    h.frame = CGRectMake(0, 0, Screen_height, 1);
    h.backgroundColor = [UIColor colorWithRed:246.0/255 green:248.0/255 blue:250.0/255 alpha:1];
    self.tableview.tableHeaderView = h;
    self.tableview.tableFooterView = [[UIView alloc]init];
    [self.tableview registerNib:[UINib nibWithNibName:@"CarSearchTableViewCell"bundle:nil] forCellReuseIdentifier:@"CELLID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}
- (void)initData{
    self.datasource = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)quxiao:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark - 补全分隔线左侧缺失
//- (void)viewDidLayoutSubviews {
//    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//}
#pragma mark - searchbardelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    CarListentity *listentity = [[CarListentity alloc]initWithReqType:GetTextListPost];
//    listentity.token = [OAuthAccountTool account].token;
//    listentity.chepaino = searchText;
//    [JYNetworkTools requestWithEntity:listentity needHud:NO needDismiss:YES success:^(NSDictionary *responseObject) {
//        NSLog(@"%@",responseObject);
//        NSNumber *code = [responseObject safeObjectForKey:@"code"];
//        NSInteger codeI = [code integerValue];
//        NSString *msg = [responseObject safeObjectForKey:@"msg"];
//        if (codeI == 1) {
//            
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:msg];
//        }
//    } failed:^(NSError *error) {
//        
//    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    CarListentity *listentity = [[CarListentity alloc]initWithReqType:GetTextListPost];
    listentity.token = [OAuthAccountTool account].token;
    listentity.chepaino = searchBar.text;
    [JYNetworkTools requestWithEntity:listentity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            self.datasource = [[SearchCarModel mj_objectArrayWithKeyValuesArray:[responseObject safeObjectForKey:@"data"]] mutableCopy];
            [self.tableview reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)addfollowcar:(UIButton *)but{
    SearchCarModel *search = self.datasource[but.tag];
    Updatecarrentity *updateentity = [[Updatecarrentity alloc]initWithReqType:AddcarPost];
    updateentity.token = [OAuthAccountTool account].token;
    updateentity.userid = [OAuthAccountTool account].userid;
    updateentity.qicheid = search.qicheid;
    self.view.userInteractionEnabled = NO;
    [JYNetworkTools requestWithEntity:updateentity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
        self.view.userInteractionEnabled = YES;
    } failed:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
    }];
}
#pragma mark - tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"forIndexPath:indexPath];
    cell.add.tag = indexPath.row;
    SearchCarModel *search = self.datasource[indexPath.row];
    cell.carnumber.text = search.chepaino;
    [cell.add addTarget:self action:@selector(addfollowcar:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
