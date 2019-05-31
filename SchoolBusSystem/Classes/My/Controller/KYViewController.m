#import "KYViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "DetailView.h"

@interface KYViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    //2点之间的线路
    CLLocationCoordinate2D fromCoordinate;
    CLLocationCoordinate2D toCoordinate;
    //计算2点之间的距离
    CLLocation *newLocation;
    CLLocation *oldLocation;
    IBOutlet UILabel *titlelabel;
    MyAnnotation *annotation;
}
@property (weak, nonatomic) IBOutlet UITextField *txtQueryKey;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UIImageView *Imageview;
@property (weak, nonatomic) IBOutlet UIButton *noteBut;
@property (weak, nonatomic) IBOutlet UIView *headerView;
/** 点数组 */
@property (nonatomic, strong) NSMutableArray *locArray;
@property (weak, nonatomic) IBOutlet UIButton *jia;
@property (weak, nonatomic) IBOutlet UILabel *radius;
@property (weak, nonatomic) IBOutlet UIButton *jian;

@property (nonatomic, strong) UIView *detailview;
@property (nonatomic, strong) UILabel *detaillab;
/** 轨迹线 */
@property (nonatomic, strong) MKPolyline *polyLine;

@end

@implementation KYViewController

- (void)viewWillAppear:(BOOL)animated
{
    //开始定位
    [locationManager startUpdatingLocation];
    _txtQueryKey.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    _mapView.delegate = nil;
    locationManager.delegate = nil;
    _txtQueryKey.delegate = nil;
    //停止定位
    [locationManager stopUpdatingLocation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化地图
    [self initWithMapView];
    //初始化定位服务管理对象
    [self initWithLocationManager];
    
}

- (void)initWithMapView
{
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    //设置代理
    _mapView.delegate = self;
    //开启自动定位
    _mapView.showsUserLocation = YES;
    self.mapView.showsCompass = NO;
    [_mapView setUserTrackingMode:(MKUserTrackingModeFollow) animated:YES];
    self.title = @"选择上车点";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button.titleLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickMeR) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = CGRectMake(Screen_width/2-20/2, (Screen_height-(SIphoneX?88:64))/2-20, 20, 39);
//    imageview.backgroundColor = [UIColor redColor];
    imageview.image = [UIImage imageNamed:@"ding"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    _Imageview = imageview;
    DetailView *deview= [[DetailView alloc]init];
    deview.frame = CGRectMake(25, (Screen_height-(SIphoneX?88:64))/2-70, Screen_width-50, 50);
    deview.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 10, Screen_width-50-30, 20);
    label.text = @"广东省深圳市南山区高新北六道";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    _detaillab = label;
    [deview addSubview:_detaillab];
    _detailview = deview;
    [self.view addSubview:_Imageview];
    [self.view addSubview:_detailview];
//    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
//    [self.mapView addGestureRecognizer:mTap];
    
}

- (void)initWithLocationManager
{
    //初始化定位服务管理对象
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    //设置精确度
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置设备移动后获取位置信息的最小距离。单位为米
    locationManager.distanceFilter = 10.0f;
    [locationManager startUpdatingHeading];
}
#pragma mark - action
- (void)clickMeR
{
    NSLog(@"ok");
}
- (IBAction)dele:(id)sender {
    self.radius.text = [NSString stringWithFormat:@"%d",([self.radius.text intValue]-100)>=500?([self.radius.text intValue]-100):[self.radius.text intValue]];
}
- (IBAction)add:(id)sender {
    self.radius.text = [NSString stringWithFormat:@"%d",([self.radius.text intValue]+100)<=2000?([self.radius.text intValue]+100):[self.radius.text intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtQueryKey resignFirstResponder];
    return YES;
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    //标准坐标
//    CLLocation *standLoc = [locations lastObject];
//    CLLocationCoordinate2D standCoor=standLoc.coordinate;
//
//    //中国坐标
//    CLLocationCoordinate2D chinaCoor = [Tools transformFromWGSToGCJ:standLoc.coordinate];
//    CLLocation *chinaLoc = [[CLLocation alloc]initWithCoordinate:chinaCoor altitude:standLoc.altitude horizontalAccuracy:standLoc.horizontalAccuracy verticalAccuracy:standLoc.verticalAccuracy course:standLoc.course speed:standLoc.speed timestamp:standLoc.timestamp];
//
//    //控制精度，精度低的点舍弃
//    if (standLoc.horizontalAccuracy > 150) {
//        return;
//    }
//
//    //添加点到数组
//    [self.locArray  addObject:chinaLoc];
//
//    //绘制轨迹
//    [self drawWalkPolyline];
//    [self.mapView setCenterCoordinate:chinaCoor animated:NO];
//
//}
//位置的实时更新
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    fromCoordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _mapView.centerCoordinate = userLocation.location.coordinate;
    //    CLLocationCoordinate2D center = userLocation.location.coordinate;
    //    MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);//这个显示大小精度自己调整
    //    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    //    [mapView setRegion:region animated:YES];
    NSLog(@"location %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLLocation *locNow = [[CLLocation alloc]initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locNow completionHandler:^(NSArray *placemarks,NSError *error)
     {
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         oldLocation = placemark.location;
         CLLocationCoordinate2D coordinate;
         coordinate.latitude = userLocation.location.coordinate.latitude;
         coordinate.longitude = userLocation.location.coordinate.longitude;
         annotation = [[MyAnnotation alloc] init];
         //设置中心
         annotation.coordinate = coordinate;
         
         //触发viewForAnnotation
         
         //设置显示范围
         MKCoordinateRegion region;
         region.span.latitudeDelta = 0.005111;
         region.span.longitudeDelta = 0.005111;
         region.center = coordinate;
         
//         if (![Tools isLocationOutOfChina:coordinate]) {
//             annotation.coordinate = [Tools transformFromWGSToGCJ:coordinate];
//             region.center = [Tools transformFromWGSToGCJ:coordinate];
//             point = [_mapView convertCoordinate:[Tools transformFromWGSToGCJ:coordinate] toPointToView:self.view];
//         }
         
         // 设置显示位置(动画)
         [_mapView setRegion:region animated:YES];
         // 设置地图显示的类型及根据范围进行显示
         [_mapView regionThatFits:region];
         _mapView.showsUserLocation = NO;
         annotation.myTitle = @"我的位置";
         annotation.mySubtitle = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality,placemark.administrativeArea,placemark.thoroughfare];
         annotation.coordinate = placemark.location.coordinate;
//        [_mapView addAnnotation:annotation];

     }];
    
    
}
//当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CGPoint touchPoint = CGPointMake(Screen_width/2-64-25.5/2, Screen_height/2-39);
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.view];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f %d",touchMapCoordinate.latitude,touchMapCoordinate.longitude,animated);
    NSLog(@"%lu",(unsigned long)_mapView.annotations.count);
    annotation.coordinate = _mapView.centerCoordinate;
    fromCoordinate = touchMapCoordinate;
    CLLocation *locNow = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locNow completionHandler:^(NSArray *placemarks,NSError *error)
     {
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         _detaillab.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                            placemark.administrativeArea?placemark.administrativeArea:@"",
                            placemark.subAdministrativeArea?placemark.subAdministrativeArea:@"",
                            placemark.locality?placemark.locality:@"",
                            placemark.subLocality?placemark.subLocality:@"",
                            placemark.thoroughfare?placemark.thoroughfare:@"",
                            placemark.subThoroughfare?placemark.subThoroughfare:@""];
         NSLog(@"ddd%@",[NSString stringWithFormat:@"%@%@%@%@%@%@%@",placemark.administrativeArea,placemark.subAdministrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare,placemark.name]);
         
     }];
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
//- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable UIView *)view;
//- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(nullable UIView *)view;
//计算2点之间的距离
- (IBAction)calculationDistance:(id)sender {
    
    CGFloat distance = [newLocation distanceFromLocation:oldLocation];
    NSLog(@"distance = %f", distance);
    titlelabel.text = [NSString stringWithFormat:@"%f米", distance];
}

//线路的绘制
- (IBAction)lineDrawing:(id)sender {
//    fromCoordinate = CLLocationCoordinate2DMake(40.0,116);
    self.locArray = [[NSMutableArray alloc]init];
    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude]];
    toCoordinate = CLLocationCoordinate2DMake(fromCoordinate.latitude,fromCoordinate.longitude-0.01);
    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:toCoordinate.latitude longitude:toCoordinate.longitude]];
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    //设置中心
    annotation.coordinate = toCoordinate;
    //触发viewForAnnotation
    CGPoint point = [_mapView convertCoordinate:toCoordinate toPointToView:self.view];
    //设置显示范围
    MKCoordinateRegion region;
    region.span.latitudeDelta = _mapView.region.span.latitudeDelta;
    region.span.longitudeDelta = _mapView.region.span.longitudeDelta;
    region.center = toCoordinate;
    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [_mapView addAnnotation:annotation];
    
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate addressDictionary:nil];
    MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:toCoordinate addressDictionary:nil];
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
             [self.mapView addOverlay:route.polyline];
             
             JYLog(@"路线距离：%f  -- %zi",route.distance,response.routes.count);
         }
     }];
    
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
    renderer.strokeColor = [UIColor purpleColor];
    [self zoomToMapPoints:_mapView];
    return renderer;
}
//- (void)drawWalkPolyline
//{
//    //轨迹点
//    NSUInteger count = self.locArray.count;
//
//    // 手动分配存储空间，结构体：地理坐标点，用直角地理坐标表示 X：横坐标 Y：纵坐标
//    MKMapPoint *tempPoints = new MKMapPoint[count];
//
//    [self.locArray enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
//        MKMapPoint locationPoint = MKMapPointForCoordinate(location.coordinate);
//        tempPoints[idx] = locationPoint;
//
//    }];
//
//    //移除原有的绘图
//    if (self.polyLine) {
//        [_mapView removeOverlay:self.polyLine];
//    }
//
//    // 通过points构建BMKPolyline
//    self.polyLine = [MKPolyline polylineWithPoints:tempPoints count:count];
//
//    //添加路线,绘图
//    if (self.polyLine) {
//        [_mapView addOverlay:self.polyLine];
//    }
//
//    // 清空 tempPoints 内存
//    delete []tempPoints;
//
//}

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
            span.latitudeDelta = deltaLong /0.5;
            span.longitudeDelta = deltaLong /0.5;
        }
        else
        {
            span.latitudeDelta = deltaLat /0.5;
            span.longitudeDelta = deltaLat /0.5;
        }
        location.latitude = (3*max_Lat + 7*min_Lat)/10;
        location.longitude = (max_Long + min_Long)/2;
        
        
        MKCoordinateRegion region={location,span};
        
        
        [_mapView setRegion:region animated:YES];
        
    }
    
    
}

//地理信息编码查询
- (IBAction)handleButtonAction:(id)sender {
    
    _mapView.showsUserLocation = NO;
    if (_txtQueryKey.text == nil || _txtQueryKey.text.length == 0) {
        return;
    }
    //地理信息编码查询
    CLGeocoder *geocder = [[CLGeocoder alloc] init];
    [geocder geocodeAddressString:_txtQueryKey.text completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            newLocation = placemark.location;
            toCoordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            //调整地图位置和缩放比例
            //第一个参数指定目标区域的中心点，第二个参数是目标区域的南北跨度，单位为米。第三个参数为目标区域东西跨度，单位为米。后2个参数的调整会影响地图的缩放
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 600, 600);
            //重新设置地图视图的显示区域
            [_mapView setRegion:viewRegion animated:YES];
            //实例化MyAnnotation对象
            MyAnnotation *annotation = [[MyAnnotation alloc] init];
            //将地标CLPlacemark对象取出，放入到MyAnnotation对象中
            annotation.myTitle = placemark.locality;
            annotation.mySubtitle = [NSString stringWithFormat:@"%@, %@, %@",placemark.locality,placemark.administrativeArea,placemark.thoroughfare];
            annotation.coordinate = placemark.location.coordinate;
            
            //把标注点MyAnnotation对象添加到地图上
            [_mapView addAnnotation:annotation];
            //关闭键盘
            [_txtQueryKey resignFirstResponder];
        }
        
    }];
    
}



//在地图视图添加标注时回调
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MyAnnotation *)annotation
{
//    MKAnnotationView *ann = nil;
//    if (ann == nil) {
//        ann = [MyAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
//    }
////    ann.pinColor = MKPinAnnotationColorPurple;
////    ann.animatesDrop = YES;
////    ann.canShowCallout = YES;
//    ann.image = [UIImage imageNamed:@"carStop"];
//    ann.contentMode = UIViewContentModeScaleAspectFit;
    
    MKAnnotationView *ann = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (ann == nil) {
        ann = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"];
    }
    ann.canShowCallout = YES;
//    ann.image = [UIImage imageNamed:@"carStop"];
    return ann;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

@end
