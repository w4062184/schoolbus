
//
//  HomeController.m
//  SchoolBusSystem
//
//  Created by WXC on 2018/1/23.
//  Copyright © 2018年 jiaoyin. All rights reserved.
//

#define kLatitudeDelta            0.005111     // 纬度跨度，由下面的regionDidChangeAnimated代理调出来的，如何不合适，可以更换
#define kLongitudeDelta           0.005111    // 经度跨度，由下面的regionDidChangeAnimated代理调出来的，如何不合适，可以更换

#import "HomeController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"
#import "ApplePayController.h"
#import "MyViewController.h"
#import "KYViewController.h"
#import "NoteViewController.h"
#import "SetUpcar.h"
#import "SelectRadView.h"
#import "Homeheaderview.h"
#import "KSscrollView.h"
#import "DetailView.h"
#import "SearchCarViewController.h"
#import "UIImage+Rotate.h"
#import "Carpointentity.h"
#import "Addpointrntity.h"
#import "Updatecarrentity.h"
#import "CarListentity.h"
@interface HomeController ()<MKMapViewDelegate,CLLocationManagerDelegate,KScrollerViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *mgr;

/** <#variate#> */
@property (nonatomic, strong) MapAnnotation *anno;

/** <#variate#> */
@property (nonatomic, assign) BOOL draggable;

/** <#variate#> */
@property (nonatomic, strong) MKPinAnnotationView *annotationView;

/** <#variate#> */
@property (nonatomic, strong) NSMutableArray *locationArray;
/** <#variate#> */
@property (nonatomic, strong) NSMutableArray *polylines;

@property (nonatomic, strong) UIView *headerview;
/** 设置点视图 */
@property (nonatomic, strong) SelectRadView *seleheaderview;
/** 添加点按钮视图 */
@property (nonatomic, strong) SetUpcar *setcar;
/** 关注的车辆视图 */
@property (nonatomic, strong) KSscrollView *ksview;

@property (nonatomic, strong) UIButton *userloc;

@property (nonatomic, assign) BOOL follow;
@property (nonatomic, assign) BOOL isfirst;
/** 点数组 */
@property (nonatomic, strong) NSMutableArray *locArray;

@property (nonatomic, strong) UIImageView *Imageview;
@property (nonatomic, strong) UIView *detailview;
@property (nonatomic, strong) UILabel *detaillab;
/** 点数组 */
@property (nonatomic, assign) CLLocationCoordinate2D pointcoordinate;
@property (nonatomic, strong) MapAnnotation *pointanno;
/** 关注车数组 */
@property (nonatomic, strong) NSMutableArray *Cararray;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Home";
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsPointsOfInterest = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
    // 如果是iOS8,需要请求授权方式(进行判断,否则在iOS7会崩溃,需要先在info.plist中配置)
    if ([self.mgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.mgr requestAlwaysAuthorization];
    }
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:self action:@selector(clickMe)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:self action:@selector(clickMeR)];
    [self initUI];
//    [self initData];
}
- (void)initUI{
    if (!self.issetCar) {
        Homeheaderview *head = [[NSBundle mainBundle] loadNibNamed:@"Homeheaderview" owner:nil options:nil].lastObject;
        head.frame = CGRectMake(0, SstatusBarH+10, Screen_width, 50);
        [head.icon addTarget:self action:@selector(my) forControlEvents:UIControlEventTouchUpInside];
        [head.search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [head.note addTarget:self action:@selector(note) forControlEvents:UIControlEventTouchUpInside];
        head.notelab.layer.cornerRadius = 4.0f;
        head.notelab.layer.masksToBounds = YES;
        head.notelab.hidden = YES;
        _headerview = head;
        [self.view addSubview:_headerview];
    }
    else{
        SelectRadView *radview = [[NSBundle mainBundle] loadNibNamed:@"SelectRadView" owner:nil options:nil].lastObject;
        radview.frame = CGRectMake(0, 0, Screen_width, 50);
        _seleheaderview = radview;
        [self.view addSubview:_seleheaderview];
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.frame = CGRectMake(Screen_width/2-20/2, (Screen_height-(SIphoneX?88:64))/2-40, 20, 39);
        //    imageview.backgroundColor = [UIColor redColor];
        imageview.image = [UIImage imageNamed:@"ding"];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        _Imageview = imageview;
        DetailView *deview= [[DetailView alloc]init];
        deview.frame = CGRectMake(25, (Screen_height-(SIphoneX?88:64))/2-90, Screen_width-50, 50);
        deview.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 10, Screen_width-50-30, 20);
        label.text = @"广东省深圳市南山区高新北六道";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        _detaillab = label;
        [deview addSubview:_detaillab];
        _detailview = deview;
        [self.view addSubview:_Imageview];
        [self.view addSubview:_detailview];
    }
    
}
- (void)initData{
    self.locArray = [[NSMutableArray alloc]init];
    self.Cararray = [[NSMutableArray alloc]init];
//    self.follow = YES;
    [self.mgr startUpdatingLocation];
//    [self requestcarlist];
    
}

- (void)updateUI{
    [self.setcar removeFromSuperview];
    [self.userloc removeFromSuperview];
    [self.ksview removeFromSuperview];
    if (!self.issetCar) {
        if (!self.follow) {
            self.setcar = [[NSBundle mainBundle] loadNibNamed:@"SetUpcar" owner:nil options:nil].lastObject;
            self.setcar.frame = CGRectMake(15, Screen_height-15-50-(SIphoneX?34:0), Screen_width-30, 50);
            [self.setcar.seletBut addTarget:self action:@selector(setc) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.setcar];
            UIButton *userl = [UIButton buttonWithType:UIButtonTypeCustom];
            userl.frame = CGRectMake(Screen_width-42-15, Screen_height-15-50-(SIphoneX?34:0)-25-42, 42, 42);
            userl.adjustsImageWhenHighlighted = NO;
            [userl setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [userl addTarget:self action:@selector(userl) forControlEvents:UIControlEventTouchUpInside];
            self.userloc = userl;
            [self.view addSubview:self.userloc];
        }
        else{
            KSscrollView *scroll = [[KSscrollView alloc]initWithFrameRect:CGRectMake(15, Screen_height-15-100-(SIphoneX?34:0), Screen_width-30, 100) ImageArray:self.Cararray TitleArray:nil changPic:NO];
//            for (int i= 0; i<self.Cararray.count; i++) {
//                NSMutableDictionary *dic = [self.Cararray[i] mutableCopy];
//                if ([[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]) {
//                    scroll.imageIndex = i;
//                }
//            }
            scroll.delegate = self;
            self.ksview = scroll;
            [self.view addSubview:self.ksview];
            UIButton *userl = [UIButton buttonWithType:UIButtonTypeCustom];
            userl.frame = CGRectMake(Screen_width-42-15, Screen_height-15-100-(SIphoneX?34:0)-25-42, 42, 42);
            userl.adjustsImageWhenHighlighted = NO;
            [userl setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [userl addTarget:self action:@selector(userl) forControlEvents:UIControlEventTouchUpInside];
            self.userloc = userl;
            [self.view addSubview:self.userloc];
            
        }
    }
    else{
        UIButton *userl = [UIButton buttonWithType:UIButtonTypeCustom];
        userl.frame = CGRectMake(Screen_width-42-15, Screen_height-(SIphoneX?34+88:64)-25-42, 42, 42);
        userl.adjustsImageWhenHighlighted = NO;
        [userl setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
        [userl addTarget:self action:@selector(userl) forControlEvents:UIControlEventTouchUpInside];
        self.userloc = userl;
        [self.view addSubview:self.userloc];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.issetCar) {
        self.navigationController.navigationBar.hidden = YES;
//        self.mapView.showsUserLocation = YES;
    }
    else{
        self.navigationController.navigationBar.hidden = NO;
//        self.mapView.showsUserLocation = NO;
        self.title = @"选择上车点";
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button.titleLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickMeR) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    }
    [self initData];
    [self updateUI];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeAnnotations:_mapView.annotations];
//    self.mapView.showsUserLocation = NO;
}
#pragma maek - networking
- (void)requestpoint{
    Carpointentity *pointentity = [[Carpointentity alloc]initWithReqType:GcarpointPost];
    pointentity.token = [OAuthAccountTool account].token;
    pointentity.userid = [OAuthAccountTool account].userid;
    [JYNetworkTools requestWithEntity:pointentity needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            NSMutableArray *arr = [[responseObject safeObjectForKey:@"data"] mutableCopy];
            if (arr.count) {
                NSMutableDictionary *dic = [arr[0] mutableCopy];
                if (dic.allKeys.count) {
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([dic[@"Gpslat"] doubleValue], [dic[@"Gpslng"] doubleValue]);
                    [OAuthAccountTool account].pointcoordinate = coor;
                    if (![Tools isLocationOutOfChina:coor]) {
                        coor = [Tools transformFromWGSToGCJ:coor];
                    }
                    MapAnnotation *annot = [[MapAnnotation alloc] init];
                    annot.coordinate = coor;
                    annot.icon = @"ding";
                    _pointanno = annot;
                    [self.mapView addAnnotation:_pointanno];
                    CLLocation *locNow = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
                    [self.locArray addObject:locNow];
                    [self zoomToMapPoints:_mapView];
                    //                    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
                    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
                    [geocoder reverseGeocodeLocation:locNow completionHandler:^(NSArray *placemarks,NSError *error)
                     {
                         CLPlacemark *placemark=[placemarks objectAtIndex:0];
                         [OAuthAccountTool account].pointAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                                                    placemark.administrativeArea?placemark.administrativeArea:@"",
                                                                    placemark.subAdministrativeArea?placemark.subAdministrativeArea:@"",
                                                                    placemark.locality?placemark.locality:@"",
                                                                    placemark.subLocality?placemark.subLocality:@"",
                                                                    placemark.thoroughfare?placemark.thoroughfare:@"",
                                                                    placemark.subThoroughfare?placemark.subThoroughfare:@""];
                         //                     NSLog(@"ddd%@",[NSString stringWithFormat:@"%@%@%@%@%@%@%@",placemark.administrativeArea,placemark.subAdministrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare,placemark.name]);
                         
                     }];
                }
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)requestcarlist{
    Updatecarrentity *carlist = [[Updatecarrentity alloc]initWithReqType:GetSetCarListPost];
    carlist.token = [OAuthAccountTool account].token;
    carlist.userid = [OAuthAccountTool account].userid;
    [JYNetworkTools requestWithEntity:carlist needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            NSMutableArray *arr = [[responseObject safeObjectForKey:@"data"] mutableCopy];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            for (int i = 0; i < arr.count; i++)
            {
                NSMutableDictionary *dic = [arr[i] mutableCopy];
                if (![[dic safeObjectForKey:@"follow"] isEqualToString:@"1"])
                {
                    [indexSet addIndex:i];
                }
            }
            [arr removeObjectsAtIndexes:indexSet];
            self.Cararray = [arr mutableCopy];
            if (self.Cararray.count) {
                self.follow = YES;
                NSMutableDictionary *dic = self.Cararray[0];
                [self requestwithcarnumberDic:dic];
            }
            else{
                self.follow = NO;
            }
            [self updateUI];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
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
    [self.mapView removeAnnotation:_pointanno];
    [self.mapView removeAnnotations:self.mapView.annotations];
    _anno = [[MapAnnotation alloc] init];
    _anno.coordinate = loc.coordinate;
    _anno.icon = @"ding";
    MKCoordinateSpan span = MKCoordinateSpanMake(kLatitudeDelta, kLongitudeDelta);
    MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, span);
    if (![Tools isLocationOutOfChina:loc.coordinate]) {
        _anno.coordinate = [Tools transformFromWGSToGCJ:loc.coordinate];
        region = MKCoordinateRegionMake([Tools transformFromWGSToGCJ:loc.coordinate], span);
    }
    if (!self.issetCar) {
//    [self.mapView addAnnotation:_anno];
        }
    [self.mapView setRegion:region animated:YES];
    [self.locArray addObject:loc];

    if (!self.issetCar) {
        [self requestcarlist];
        [self requestpoint];
    }
    else{
        CLLocationCoordinate2D coor = [OAuthAccountTool account].pointcoordinate;
        if (coor.latitude == 0&&coor.longitude==0) {
        }
        else{
        MKCoordinateRegion region1 = MKCoordinateRegionMake([OAuthAccountTool account].pointcoordinate, span);
        if (![Tools isLocationOutOfChina:coor]) {
            region1 = MKCoordinateRegionMake([Tools transformFromWGSToGCJ:coor], span);
            coor = [Tools transformFromWGSToGCJ:coor];
        }
        self.mapView.centerCoordinate = coor;
        [self.mapView setRegion:region1 animated:YES];
        }
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    // magneticHeading : 距离磁北方向的角度
    // trueHeading : 真北
    // headingAccuracy : 如果是负数,代表当前设备朝向不可用
    if (newHeading.headingAccuracy < 0) {
        return;
    }
    // 角度
    CLLocationDirection angle = newHeading.magneticHeading;
    // 角度-> 弧度
    double radius = angle / 180.0 * M_PI;
    // 反向旋转图片(弧度)
    [UIView animateWithDuration:0.5 animations:^{
        self.mapView.transform = CGAffineTransformMakeRotation(-radius);
    }];
    
}
//当MKMapView显示区域改变完成时激发该方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    if (!_isfirst) {
//        self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
//        _isfirst = YES;
//    }
    CGPoint touchPoint = CGPointMake(CGRectGetMidX(_Imageview.frame)+_Imageview.frame.size.width/2, CGRectGetMaxY(_Imageview.frame));
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.view];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f %d",touchMapCoordinate.latitude,touchMapCoordinate.longitude,animated);
    _pointcoordinate = touchMapCoordinate;
    CLLocation *locNow = [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locNow completionHandler:^(NSArray *placemarks,NSError *error)
     {
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                              placemark.administrativeArea?placemark.administrativeArea:@"",
                              placemark.subAdministrativeArea?placemark.subAdministrativeArea:@"",
                              placemark.locality?placemark.locality:@"",
                              placemark.subLocality?placemark.subLocality:@"",
                              placemark.thoroughfare?placemark.thoroughfare:@"",
                              placemark.subThoroughfare?placemark.subThoroughfare:@""];
         if (address&&![address isEqualToString:@""]) {
             if (![address containsString:placemark.name]) {
                 address = [address stringByAppendingString:placemark.name];
             }
         }
         else{
             address = placemark.name;
         }
         _detaillab.text = address;
         NSLog(@"ddd%@",[NSString stringWithFormat:@"%@%@%@%@%@%@%@",placemark.administrativeArea,placemark.subAdministrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare,placemark.name]);
         
     }];
}
//当MKMapView显示区域将要发生改变时激发该方法
-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"地图控件的显示区域要发生改变");
//    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    double  distance  = [userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:_anno.coordinate.latitude longitude:_anno.coordinate.longitude]];
//    NSString *str = [NSString stringWithFormat:@"您距离停车点%.2fkm 步行约%d分钟",distance/1000,(int)distance];
//    userLocation.title = str;
    if (_pointanno) {
        MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:userLocation.location.coordinate addressDictionary:nil];
        MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:_pointanno.coordinate addressDictionary:nil];
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
                 NSMutableArray *arr = [response.routes mutableCopy];
                 float distance = 0.0;
                 for (int i = 0; i<arr.count; i++) {
                     MKRoute *route = response.routes[i];
                     JYLog(@"路线距离：%f  -- %zi",route.distance,response.routes.count);
                     if (!distance) {
                         distance = route.distance;
                     }
                     else{
                         distance = distance<route.distance?distance:route.distance;
                     }
                 }
                 NSString *str = [NSString stringWithFormat:@"您距离停车点%.2fkm 步行约%d分钟",distance/1000,(int)distance/60];
                 userLocation.title = str;
             }
         }];
    }
    
    
    NSLog(@"location %f,%f,%@",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,userLocation.heading);
}
//线路的绘制
- (void)lineDrawing:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to{
    
    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude]];
    [self.locArray addObject:[[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude]];
    MapAnnotation *f = [[MapAnnotation alloc] init];
    f.coordinate = from;
    f.icon = @"icon-start-1";
    [self.mapView addAnnotation:f];
    MapAnnotation *t = [[MapAnnotation alloc] init];
    t.coordinate = to;
    t.icon = @"car";
    [self.mapView addAnnotation:t];
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
             if (!self.mapView.overlays.count) {
                 [self.mapView addOverlay:route.polyline];
             }
             
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
    NSLog(@"overlay:%lu",(unsigned long)_mapView.annotations.count);
//    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    return renderer;
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
//        [_mapView regionThatFits:region];
        
        [_mapView setRegion:region animated:YES];
    }
    
    
}
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKPinAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    switch (newState) {
        case MKAnnotationViewDragStateNone: {
            JYLog(@"MKAnnotationViewDragStateNone.....");
            self.draggable = NO;
        }
            break;
        case MKAnnotationViewDragStateStarting: {
            JYLog(@"拿起");
            self.draggable = NO;
            [mapView removeOverlays:self.polylines];
            [self.locationArray removeAllObjects];
        }
            break;
        case MKAnnotationViewDragStateDragging: {
            JYLog(@"开始拖拽");
            self.draggable = YES;
            self.annotationView = view;
        }
            break;
        case MKAnnotationViewDragStateCanceling: {
            JYLog(@"取消");
            self.draggable = NO;
        }
            break;
            
        case MKAnnotationViewDragStateEnding: {
            JYLog(@"放下,并将大头针 %f-%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
            self.draggable = NO;
            [self dealCoordinate:view.annotation.coordinate];
        }
            break;
        default:
            return;
    }
    
}

/**
 *  在地图上添加一个大头针就会执行该方法（类似tableview）
 */

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation *)annotation
{
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        static NSString *ID = @"myAnnoView";
        MKAnnotationView *myAnnoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (myAnnoView == nil) {
            myAnnoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        }
        myAnnoView.draggable = YES;
        UIImage *image = [UIImage imageNamed:annotation.icon];
//        NSLog(@"qian:%f,%f",image.size.width,image.size.height);
        myAnnoView.image = [UIImage imageNamed:annotation.icon];
        if ([annotation.icon isEqualToString:@"car"]) {
//            myAnnoView.image = [image flipHorizontal];
//            NSLog(@"hou:%f,%f",image.size.width,image.size.height);
        }
//        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
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



//#pragma mark - 代理方法
//- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    MKPolylineRenderer *redender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
//    redender.lineWidth = 6;
//    redender.strokeColor = [UIColor redColor];
//    return redender;
//}


#pragma mark - 响应方法
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.draggable) {
        //JYLog(@"%f-%f",self.annotationView.frame.origin.x,self.annotationView.frame.origin.y);
        CGPoint point;
        point.x = self.annotationView.frame.origin.x+6;
        point.y = self.annotationView.frame.origin.y + 37;
        [self dealCoordinate:[self.mapView convertPoint:point toCoordinateFromView:self.mapView]];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"endmove");
}
- (void)my{
    MyViewController *pay = [[MyViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}
- (void)search{
    SearchCarViewController *pay = [[SearchCarViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}
- (void)note{
    NoteViewController *pay = [[NoteViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}
- (void)clickMe
{
    KYViewController *pay = [[KYViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)clickMeR
{
    NSLog(@"sele:%@",_seleheaderview.radiuslab.text);
    Addpointrntity *add = [[Addpointrntity alloc]initWithReqType:AddcarpointPost];
    add.token = [OAuthAccountTool account].token;
    add.userid = [OAuthAccountTool account].userid;
    add.Radius = _seleheaderview.radiuslab.text;
    CLLocationCoordinate2D coor = _pointcoordinate;
    if (![Tools isLocationOutOfChina:coor]) {
        coor = [Tools transformFromGCJToWGS:coor];
    }
    add.Gpslng = [NSString stringWithFormat:@"%f",coor.longitude];
    add.Gpslat = [NSString stringWithFormat:@"%f",coor.latitude];
    [JYNetworkTools requestWithEntity:add needHud:YES needDismiss:YES success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *code = [responseObject safeObjectForKey:@"code"];
        NSInteger codeI = [code integerValue];
        NSString *msg = [responseObject safeObjectForKey:@"msg"];
        if (codeI == 1) {
            [OAuthAccountTool account].pointcoordinate = _pointcoordinate;
            [OAuthAccountTool account].pointAddress = _detaillab.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failed:^(NSError *error) {
        
    }];
}
- (void)setc{
    HomeController *pay = [[HomeController alloc] init];
    pay.issetCar = YES;
    [self.navigationController pushViewController:pay animated:YES];
//    KYViewController *pay = [[KYViewController alloc] init];
//    [self.navigationController pushViewController:pay animated:YES];
}
- (void)userl{
    [self.mgr startUpdatingLocation];
}
- (void)KScrollerViewScrollToIndex:(NSInteger)index{
    NSLog(@"scroll:%ld",(long)index);
    NSMutableDictionary *dic = self.Cararray[index];
    [self requestwithcarnumberDic:dic];
}
- (void)KScrollerViewDidClicked:(NSInteger)index{
    NSLog(@"scroll:%ld",(long)index);
}
- (void)requestwithcarnumberDic:(NSMutableDictionary *)dic{
    if ([[dic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]) {
        CarListentity *listentity = [[CarListentity alloc]initWithReqType:SelectCarPost];
        listentity.token = [OAuthAccountTool account].token;
        listentity.chepaino = [dic safeObjectForKey:@"chepaino"];
        [JYNetworkTools requestWithEntity:listentity needHud:NO needDismiss:YES success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            NSNumber *code = [responseObject safeObjectForKey:@"code"];
            NSInteger codeI = [code integerValue];
            NSString *msg = [responseObject safeObjectForKey:@"msg"];
            if (codeI == 1) {
                NSMutableArray *arr = [[responseObject safeObjectForKey:@"data"] mutableCopy];
                NSMutableDictionary *arrdic = [[arr firstObject] mutableCopy];
                if ([[arrdic safeObjectForKey:@"currentstatus"] isEqualToString:@"1"]) {
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([arrdic[@"currentlocationy"] doubleValue], [arrdic[@"currentlocationx"] doubleValue]);
                    [OAuthAccountTool account].pointcoordinate = coor;
                    if (![Tools isLocationOutOfChina:coor]) {
                        coor = [Tools transformFromWGSToGCJ:coor];
                    }
                    MapAnnotation *annot = [[MapAnnotation alloc] init];
                    annot.coordinate = coor;
                    annot.icon = @"car";
                    _pointanno = annot;
                    [self.mapView addAnnotation:_pointanno];
                    CLLocation *locNow = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
                    [self.locArray addObject:locNow];
                    [self zoomToMapPoints:_mapView];
                }
            }
            else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}
// 两个经纬度之间的距离
- (double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
    
}


#pragma mark - 自定义
- (void)dealCoordinate:(CLLocationCoordinate2D)coordinate
{
    JYLog(@"经度:%f-纬度:%f",coordinate.latitude,coordinate.longitude);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.locationArray addObject:location];
    if (self.locationArray.count > 2) {
        CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(2*sizeof(CLLocationCoordinate2D));
        for (NSInteger i = 0; i < 2; i++) {
            if (i == 0) {
                CLLocation *location = [_locationArray objectAtIndex:_locationArray.count - 2];
                coordinateArray[0] = [location coordinate];
            }
            else if (i == 1)
            {
                CLLocation *location = _locationArray.lastObject;
                coordinateArray[1] = [location coordinate];
            }
        }
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        [self.mapView addOverlay:routeLine];
        [self.polylines addObject:routeLine];
        free(coordinateArray);
        coordinateArray = NULL;
    }
    else
    {
        CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(self.locationArray.count * sizeof(CLLocationCoordinate2D));
        for (NSInteger i = 0; i < self.locationArray.count; ++i) {
            CLLocation *location = [_locationArray objectAtIndex:i];
            coordinateArray[i] = [location coordinate];
        }
        MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:1];
        [self.mapView addOverlay:routeLine];
        [self.polylines addObject:routeLine];
        free(coordinateArray);
        coordinateArray = NULL;
    }
}


#pragma  mark - lazyLoad
- (CLLocationManager *)mgr
{
    if (_mgr == nil) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.desiredAccuracy = 1;
        _mgr.delegate = self;
    }
    return _mgr;
}


- (NSMutableArray *)locationArray
{
    if (_locationArray == nil) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}

- (NSMutableArray *)polylines
{
    if (_polylines == nil) {
        _polylines = [NSMutableArray array];
    }
    return _polylines;
}
//- (UIView *)headerview
//{
//    if (_headerview == nil) {
//        _headerview = [[UIView alloc]init];
//        _headerview.frame = CGRectMake(8, SIphoneX?20:44, Screen_width-16, 44);
//        _headerview.backgroundColor = [UIColor redColor];
//    }
//
//    return _headerview;
//}

@end

