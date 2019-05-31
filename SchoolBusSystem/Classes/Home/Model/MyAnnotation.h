//建一个model类
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
@property (nonatomic ,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy)NSString *myTitle;
@property (nonatomic,copy)NSString *mySubtitle;

- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate;
@end
