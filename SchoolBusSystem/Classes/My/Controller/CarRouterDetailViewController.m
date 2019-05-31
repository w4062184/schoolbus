//
//  CarRouterDetailViewController.m
//  SchoolBusSystem
//
//  Created by Jy on 2018/4/2.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//
#define kLatitudeDelta            0.005111     // 纬度跨度，由下面的regionDidChangeAnimated代理调出来的，如何不合适，可以更换
#define kLongitudeDelta           0.005111    // 经度跨度，由下面的regionDidChangeAnimated代理调出来的，如何不合适，可以更换
#import "CarRouterDetailViewController.h"
#import "CarRouteractionview.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ActiononeTableViewCell.h"
#import "ActiontwoTableViewCell.h"
#import "ActionthreeTableViewCell.h"
#import "MapAnnotation.h"
#import "Carhistorydetailentity.h"
@interface CarRouterDetailViewController ()<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (nonatomic,strong) CLLocationManager *mgr;

@property (nonatomic, strong) NSMutableArray *locArray;
@property (nonatomic, strong) UIButton *userloc;

@property (nonatomic, strong) UITableView *actiontableview;
@property (nonatomic, strong) NSMutableArray *tableviewdatasource;
@property (assign, nonatomic) BOOL isAction;
@property (assign, nonatomic) BOOL isZoom;
@end

@implementation CarRouterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"地图轨迹";
    [self initUI];
    [self initData];
}
- (void)initUI{
    self.mapview.mapType = MKMapTypeStandard;
    self.mapview.delegate = self;
    self.mapview.showsCompass = NO;
    self.mapview.showsPointsOfInterest = YES;
    self.mapview.userTrackingMode = MKUserTrackingModeFollow;
    self.mapview.showsUserLocation = NO;
    // 是否可以滚动
//    self.mapview.scrollEnabled = NO;
    // 缩放
//    self.mapview.zoomEnabled = NO;
    // 旋转
//    self.mapview.rotateEnabled = NO;
    // 是否显示3D
    self.mapview.pitchEnabled = NO;
//    self.mapview.centerCoordinate = CLLocationCoordinate2DMake(22.56, 113.94);
//    [self lineDrawing:CLLocationCoordinate2DMake(22.56, 113.94) to:CLLocationCoordinate2DMake(22.56, 114.04)];
    [self inittableviewwith:1];
    UIButton *userl = [UIButton buttonWithType:UIButtonTypeCustom];
    userl.frame = CGRectMake(Screen_width-42-15, Screen_height-15-50-(SIphoneX?(34+88):(0+64))-25-42, 42, 42);
    userl.adjustsImageWhenHighlighted = NO;
    [userl setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [userl addTarget:self action:@selector(userl) forControlEvents:UIControlEventTouchUpInside];
    self.userloc = userl;
    [self.view addSubview:self.userloc];
}
- (void)initData{
//    self.mgr = [[CLLocationManager alloc] init];
//    self.mgr.desiredAccuracy = 1;
//    self.mgr.delegate = self;
//    // 如果是iOS8,需要请求授权方式(进行判断,否则在iOS7会崩溃,需要先在info.plist中配置)
//    if ([self.mgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.mgr requestAlwaysAuthorization];
//    }
//    [self.mgr startUpdatingLocation];
    self.locArray = [[NSMutableArray alloc]init];
    self.tableviewdatasource = [[NSMutableArray alloc]init];
    for (int i = 0; i<44; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        if (i == 10){
            [dic setObject:@"急刹车" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 11){
            [dic setObject:@"急加油" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 12){
            [dic setObject:@"快速变道" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 13){
            [dic setObject:@"弯道加速" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 14){
            [dic setObject:@"碰撞" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 15){
            [dic setObject:@"频繁变道" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 16){
            [dic setObject:@"烂路高速行驶" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 17){
            [dic setObject:@"急转弯" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 18){
            [dic setObject:@"翻车" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 19){
            [dic setObject:@"异常震动" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 20){
            [dic setObject:@"车门异常" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 21){
            [dic setObject:@"胎压和手刹异常" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 30){
            [dic setObject:@"超速报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 31){
            [dic setObject:@"水温报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 32){
            [dic setObject:@"转速报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 33){
            [dic setObject:@"电压报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 34){
            [dic setObject:@"故障报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 35){
            [dic setObject:@"怠速报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 36){
            [dic setObject:@"断电报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 37){
            [dic setObject:@"终端异常上报" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 38){
            [dic setObject:@"拖吊报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 39){
            [dic setObject:@"疲劳驾驶报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        if (i == 43){
            [dic setObject:@"车辆行驶X米报警" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [dic setObject:@"0" forKey:@"ci"];
        if (dic.allKeys.count>1) {
            [self.tableviewdatasource addObject:dic];
        }
    }
    [self requestCarhisrouter];
}
- (void)requestCarhisrouter{
    MapAnnotation *f1 = [[MapAnnotation alloc] init];
    f1.coordinate = [OAuthAccountTool account].pointcoordinate;
    f1.icon = @"ding";
    [self.mapview addAnnotation:f1];
    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:f1.coordinate.latitude longitude:f1.coordinate.longitude]];
    
    Carhistorydetailentity *car = [[Carhistorydetailentity alloc]initWithReqType:GhistorygpslistPost];
    car.token = [OAuthAccountTool account].token;
    car.userid = [OAuthAccountTool account].userid;
    car.qicheid = self.carmodel.qicheid;
    NSMutableDictionary *dic = [self.datasource mutableCopy];
//    NSMutableArray *arr = [dic safeObjectForKey:@"time"];
    NSMutableDictionary *routerdic = [dic safeObjectForKey:@"time"];
    car.startime = [routerdic safeObjectForKey:@"starttime"];
    car.endtime = [routerdic safeObjectForKey:@"endtime"];
    [JYNetworkTools requestWithEntity:car needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            NSMutableArray *routerarr = [[responseObject safeObjectForKey:@"data"] mutableCopy];
            NSMutableArray *saverouterarr = [routerarr mutableCopy];
            for (int i = 0; i<saverouterarr.count; i++) {
                NSMutableDictionary *form = [routerarr[i] mutableCopy];
                if (([form[@"gpslat"] doubleValue]==0)&&([form[@"gpslng"] doubleValue]==0)) {
                    [routerarr removeObjectAtIndex:i];
                    NSMutableDictionary *form = [routerarr[0] mutableCopy];
                    [form setObject:@"1" forKey:@"eventtype"];
                    [routerarr replaceObjectAtIndex:0 withObject:form];
                    break ;
                }
            }
            CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) *routerarr.count);
            for (int i = 0; i<routerarr.count; i++) {
                NSMutableDictionary *form = [routerarr[i] mutableCopy];
                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([form[@"gpslat"] doubleValue], [form[@"gpslng"] doubleValue]);
                if (![Tools isLocationOutOfChina:coor]) {
                    coor = [Tools transformFromWGSToGCJ:coor];
                }
                coords[i].latitude = coor.latitude;
                coords[i].longitude = coor.longitude;
                [self.locArray addObject:[[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude]];
                MapAnnotation *f = [[MapAnnotation alloc] init];
                f.coordinate = coor;
                if ([form[@"eventtype"] isEqualToString:@"1"]) {
                    f.icon = @"icon-start-1";
                    [self.mapview addAnnotation:f];
                }
                else if ([form[@"eventtype"] isEqualToString:@"2"]) {
                    f.icon = @"icon-start-2";
                    [self.mapview addAnnotation:f];
                }
                else if ([form[@"eventtype"] isEqualToString:@"0"]) {
                    
                }
                else{
                    [self dealtableviewdatasourcewithkey:form[@"eventtype"]];
                }
            }
            [self dealtableviewdatasource];
            MKPolygon *pol = [MKPolygon polygonWithCoordinates:coords count:routerarr.count];
            [self.mapview addOverlay:pol];
//            [self.mapview showAnnotations:self.mapview.annotations animated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)dealwithdata:(NSMutableArray *)routerarr{
    NSMutableArray *saverouterarr = [routerarr mutableCopy];
    for (int i = 0; i<saverouterarr.count; i++) {
        NSMutableDictionary *form = [routerarr[i] mutableCopy];
        if (([form[@"gpslat"] doubleValue]==0)&&([form[@"gpslng"] doubleValue]==0)) {
            [routerarr removeObjectAtIndex:i];
            NSMutableDictionary *form = [routerarr[0] mutableCopy];
            [form setObject:@"1" forKey:@"eventtype"];
            [routerarr replaceObjectAtIndex:0 withObject:form];
            break ;
        }
    }
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) *routerarr.count);
    for (int i = 0; i<routerarr.count; i++) {
        NSMutableDictionary *form = [routerarr[i] mutableCopy];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([form[@"gpslat"] doubleValue], [form[@"gpslng"] doubleValue]);
        if (![Tools isLocationOutOfChina:coor]) {
            coor = [Tools transformFromWGSToGCJ:coor];
        }
        coords[i].latitude = coor.latitude;
        coords[i].longitude = coor.longitude;
        [self.locArray addObject:[[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude]];
        MapAnnotation *f = [[MapAnnotation alloc] init];
        f.coordinate = coor;

        if ([form[@"eventtype"] isEqualToString:@"1"]) {
            f.icon = @"icon-start-1";
            [self.mapview addAnnotation:f];
        }
        else if ([form[@"eventtype"] isEqualToString:@"2"]) {
            f.icon = @"icon-start-2";
            [self.mapview addAnnotation:f];
        }
        else if ([form[@"eventtype"] isEqualToString:@"0"]) {

        }
        else{
            [self dealtableviewdatasourcewithkey:form[@"eventtype"]];
        }
    }
    MKPolygon *pol = [MKPolygon polygonWithCoordinates:coords count:routerarr.count];
    [self.mapview addOverlay:pol];
    //            [self.mapview showAnnotations:self.mapview.annotations animated:YES];
}
- (void)dealtableviewdatasourcewithkey:(NSString *)key{
    for (int i = 0; i<self.tableviewdatasource.count; i++) {
        NSMutableDictionary *dic = self.tableviewdatasource[i];
        if ([dic.allKeys containsObject:key]) {
            NSString *ci = [NSString stringWithFormat:@"%ld",[dic[@"ci"] integerValue]+1];
            [dic setObject:ci forKey:@"ci"];
            return;
        }
    }
}
- (void)dealtableviewdatasource{
    NSMutableArray *datasou = [self.tableviewdatasource mutableCopy];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i<self.tableviewdatasource.count; i++) {
        NSMutableDictionary *dic = self.tableviewdatasource[i];
        if ([dic[@"ci"] isEqualToString:@"0"]) {
            [indexSet addIndex:i];
        }
    }
    [datasou removeObjectsAtIndexes:indexSet];
    self.tableviewdatasource = [datasou mutableCopy];
}
- (void)inittableviewwith:(NSInteger)number{
    number = number>5?5:number;
    self.actiontableview = [[UITableView alloc]initWithFrame:CGRectMake(0,Screen_height-15-number*50-(SIphoneX?34+88:0+64), Screen_width, number*50+4) style:UITableViewStylePlain];
    self.actiontableview.dataSource = self;
    self.actiontableview.delegate = self;
    self.actiontableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 2)];
    self.actiontableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 2)];
    [self.actiontableview registerNib:[UINib nibWithNibName:@"ActiononeTableViewCell"bundle:nil] forCellReuseIdentifier:@"ActiononeTableViewCell"];
    [self.actiontableview registerNib:[UINib nibWithNibName:@"ActiontwoTableViewCell"bundle:nil] forCellReuseIdentifier:@"ActiontwoTableViewCell"];
    [self.actiontableview registerNib:[UINib nibWithNibName:@"ActionthreeTableViewCell"bundle:nil] forCellReuseIdentifier:@"ActionthreeTableViewCell"];
    self.actiontableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    CarRouteractionview *action = [[NSBundle mainBundle] loadNibNamed:@"CarRouteractionview" owner:nil options:nil].lastObject;
    //    action.frame = CGRectMake(15, Screen_height-15-50-(SIphoneX?34:0), Screen_width-30, 50);
    //    [action.selectbut addTarget:self action:@selector(caraction) forControlEvents:UIControlEventTouchUpInside];
    self.actiontableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.actiontableview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)lineDrawing:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to{
    
//    self.locArray = [[NSMutableArray alloc]init];
//    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude]];
//    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude]];
//
//    MapAnnotation *f = [[MapAnnotation alloc] init];
//    f.coordinate = from;
//    f.icon = @"icon-start-1";
//    [self.mapview addAnnotation:f];
//    MapAnnotation *t = [[MapAnnotation alloc] init];
//    t.coordinate = to;
//    t.icon = @"icon-start-2";
//    [self.mapview addAnnotation:t];
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:from addressDictionary:nil];
    MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"error:%@", error);
         }
         else {
             JYLog(@"路线距离1：%@ ",response.routes);
             MKRoute *route = response.routes[0];
             [self.mapview addOverlay:route.polyline];
            
             JYLog(@"路线距离：%f  -- %zi",route.distance,response.routes.count);
         }
     }];
}
    
- (void)zoomToMapPoints:(MKMapView*)mapView
{
    
    if(self.locArray .count)
    {//保证self.loc.locArray不为空，才执行
        CLLocation *firstLoc = self.locArray[0];
        CLLocationCoordinate2D location = firstLoc.coordinate;
        
        
        //放大地图到自身的经纬度位置。
        MKCoordinateSpan span ;
        //        span.latitudeDelta = 0.009 ;
        //        span.longitudeDelta = 0.009 ;
        //根据跑步数据结果来微调地图区域设定
        double min_Long = 180;
        double max_Long = -180;
        double min_Lat = 90;
        double max_Lat = -90;
        double temp_val = 0;
        double deltaLong = 0;
        double deltaLat = 0;
        
        
        
        for (int j = 0; j<self.locArray .count; j++)
        {
            CLLocation *loc = self.locArray[j];
            
            CLLocationCoordinate2D  tempLoca = loc.coordinate;
            
            temp_val = tempLoca.longitude;
            if(temp_val < min_Long) min_Long = temp_val;
            if(temp_val > max_Long) max_Long = temp_val;
            
            
            temp_val = tempLoca.latitude;
            if(temp_val > max_Lat) max_Lat = temp_val;
            if(temp_val < min_Lat) min_Lat = temp_val;
            
        }
        deltaLong = max_Long - min_Long;
        deltaLat = max_Lat - min_Lat;
        if( deltaLong > deltaLat)
        {
            span.latitudeDelta = deltaLong /0.8;
            span.longitudeDelta = deltaLong /0.8;
        }
        else
        {
            span.latitudeDelta = deltaLat /0.8;
            span.longitudeDelta = deltaLat /0.8;
        }
        location.latitude = (3*max_Lat + 7*min_Lat)/10;
        location.longitude = (max_Long + min_Long)/2;
        
        
        MKCoordinateRegion region={location,span};
        
        if (!self.isZoom) {
            [_mapview setRegion:region animated:YES];
            self.isZoom = YES;
        }
    }
    
    
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {
        [self.mgr startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.mgr stopUpdatingLocation];
    
    CLLocation *loc = [locations lastObject];
    [self.mapview removeAnnotations:self.mapview.annotations];
    MapAnnotation *anno = [[MapAnnotation alloc] init];
    anno.coordinate = loc.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, span);
    if (![Tools isLocationOutOfChina:loc.coordinate]) {
        anno.coordinate = [Tools transformFromWGSToGCJ:loc.coordinate];
        region = MKCoordinateRegionMake([Tools transformFromWGSToGCJ:loc.coordinate], span);
    }
    self.mapview.centerCoordinate = loc.coordinate;
    [self.mapview setRegion:region animated:YES];
    
//    [self.mapview addAnnotation:anno];
    [self requestCarhisrouter];
    
}
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation *)annotation
{
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        NSLog(@"map%luloc%lu",(unsigned long)self.mapview.annotations.count,(unsigned long)self.locArray.count);
//        for (int i = 0; i<self.locArray.count; i++) {
//            CLLocation *firstLoc = self.locArray[i];
//            CLLocationCoordinate2D location = firstLoc.coordinate;
//            if (annotation.coordinate.latitude == location.latitude&&annotation.coordinate.longitude == location.longitude) {
//                return nil;
//            }
//        }
        static NSString *ID = @"myAnnoView";
        MKAnnotationView *myAnnoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (myAnnoView == nil) {
            myAnnoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        myAnnoView.draggable = YES;
        if (annotation.icon) {
            myAnnoView.image = [UIImage imageNamed:annotation.icon];
        }
        if ([annotation.icon isEqualToString:@"icon-start-2"]) {
            [self zoomToMapPoints:self.mapview];
        }
        return myAnnoView;
    }
    else
    {
        //         [_mapView selectAnnotation:annotation animated:YES];
        //        static NSString *ID = @"userAnnoView";
        //        MKUserLocation *user = (MKUserLocation *)annotation;
        //        MKAnnotationView *myAnnoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        //        myAnnoView.title = @"45645646";
        return nil;
    }
}
//线路的绘制
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer;
    renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    //    renderer.lineDashPattern = @[@5, @10];
    //    renderer.strokeColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    //    renderer.alpha = 0.5;
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor colorWithRed:16.0/255 green:142.0/255 blue:233.0/255 alpha:1];
//    [self zoomToMapPoints:_mapview];
    return renderer;
}
//当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"显示区域改变完成");
}
//当MKMapView显示区域将要发生改变时激发该方法
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域要发生改变");
}
//当地图控件MKMapView开始加载数据时激发该方法
-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始加载地图数据");
    //创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
}
//当MKMapView加载数据完成时激发该方法
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件加载地图数据完成");
}
//当MKMapView加载数据失败时激发该方法
-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"地图控件加载地图数据发生错误：错误信息：%@",error);
}
//当MKMapView开始渲染地图时激发该方法
-(void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    NSLog(@"地图控件开始渲染地图");
}
//当MKMapView渲染地图完成时激发该方法
-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"地图控件渲染完成");
}
#pragma mark - uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_isAction) {
        return 1;
    }
    return self.tableviewdatasource.count==0?1:self.tableviewdatasource.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!_isAction) {
            ActiononeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActiononeTableViewCell"forIndexPath:indexPath];
            return cell;
        }
        else{
            ActiontwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActiontwoTableViewCell"forIndexPath:indexPath];
            return cell;
        }
        
    }
    else {
        NSMutableDictionary *dic = [self.tableviewdatasource[indexPath.row-1] mutableCopy];
        NSMutableArray *keyarr = [dic.allKeys mutableCopy];
        [keyarr removeObject:@"ci"];
        ActionthreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionthreeTableViewCell"forIndexPath:indexPath];
        cell.actionlab.text = dic[keyarr[0]];
        cell.numberlab.text = [NSString stringWithFormat:@"%@次",dic[@"ci"]];
        if (indexPath.row==0) {
            cell.cellid = StartId;
        }
        else if(indexPath.row == self.tableviewdatasource.count){
            cell.cellid = EndId;
        }
        else{
            cell.cellid = DefaultId;
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
#pragma mark - uitableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.actiontableview removeFromSuperview];
    if (!_isAction) {
        _isAction = YES;
        [self inittableviewwith:self.tableviewdatasource.count==0?1:self.tableviewdatasource.count+1];
    }
    else{
        _isAction = NO;
        [self inittableviewwith:1];
    }
}
#pragma mark -action
- (void)userl{
    
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
