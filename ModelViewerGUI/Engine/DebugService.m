//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import "DebugService.h"
#import "DoublePoint.h"
#import "Color.h"
#import "Vector.h"
#import "Line.h"


@implementation DebugService {

}
+ (DebugService *)instance {
    static DebugService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _constantHelperLines = [NSMutableArray array];
        _constantHelperPoints = [NSMutableArray array];
        _constantLines = [NSMutableArray array];
        _constantPoints = [NSMutableArray array];
        _dynamicHelperPoints = [NSMutableArray array];
    }

    return self;
}

- (void)clearDynamicData {
    [self.dynamicHelperPoints removeAllObjects];
}

- (NSArray*)getAllPoints {
    NSArray* ret = [self.constantPoints arrayByAddingObjectsFromArray:[self.constantHelperPoints arrayByAddingObjectsFromArray:self.dynamicHelperPoints]];
    return ret;
}
@end