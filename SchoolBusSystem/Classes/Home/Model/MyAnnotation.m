#import "MyAnnotation.h"
@implementation MyAnnotation
- (id)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        _coordinate = coordinate;
    }
    return self;
}
- (NSString *)title
{
    return _myTitle;
}
- (NSString *)subtitle
{
    return _mySubtitle;
}
@end
