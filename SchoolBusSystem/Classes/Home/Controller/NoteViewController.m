//
//  NoteViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/3/28.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteTableViewCell.h"
#import "NoteEntity.h"
#import "NoteModel.h"

@interface NoteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIScrollView *nonteview;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)initUI{
    [self.tableview registerNib:[UINib nibWithNibName:@"NoteTableViewCell"bundle:nil] forCellReuseIdentifier:@"CELLID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestmess)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableview.mj_header = header;
//    self.tableview.estimatedRowHeight = 0;
//    self.tableview.estimatedSectionHeaderHeight = 0;
//    self.tableview.estimatedSectionFooterHeight = 0;
}
- (void)initData{
    self.dataSource = [[NSMutableArray alloc]init];
    self.title = @"消息提醒";
    [self requestmess];
}
- (void)requestmess{
    NoteEntity *messentity = [[NoteEntity alloc]initWithReqType:CarMessPost];
    messentity.token = [OAuthAccountTool account].token;
    messentity.userid = [OAuthAccountTool account].userid;
    messentity.currentpage = [NSString stringWithFormat:@"%lu",self.dataSource.count/10+1];
    messentity.pagesize = @"10";
    if (self.dataSource.count%10 == 0) {
        [JYNetworkTools requestWithEntity:messentity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            NSNumber *code = [responseObject safeObjectForKey:@"code"];
            NSInteger codeI = [code integerValue];
            NSString *msg = [responseObject safeObjectForKey:@"msg"];
            if (codeI == 1) {
                NSMutableArray *arr = [[NoteModel mj_objectArrayWithKeyValuesArray:[responseObject safeObjectForKey:@"data"]] mutableCopy];
                if (!arr.count) {
                    [self addnoteview];
                }
                else{
                    [self.nonteview removeFromSuperview];
                    [self.dataSource addObjectsFromArray:arr];
                    [self.tableview reloadData];
                }
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
- (void)addnoteview{
    [self.nonteview removeFromSuperview];
    self.nonteview = [[UIScrollView alloc]initWithFrame:self.tableview.frame];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_width-100)/2, 108, 100, 100)];
    imagev.image = [UIImage imageNamed:@"nonote"];
    [self.nonteview addSubview:imagev];
    CGSize size = [@"暂无消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Regular" size:15],NSFontAttributeName,nil]];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 208+16,Screen_width , size.height);
    label.text = @"暂无消息";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    [self.nonteview addSubview:label];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestmess)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.nonteview.mj_header = header;
    [self.view addSubview:self.nonteview];
}
#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
//    return 5;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"forIndexPath:indexPath];
    NoteModel *note = self.dataSource[indexPath.row];
    cell.time.text = note.pushtime;
//    cell.time.text = @"12:00";
    cell.label.text = @"校车已到达上车点";
    cell.detaillabel.text = note.content;
//    cell.detaillabel.text = @"5445wqeqw546465121365465410.154654654654654";
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
