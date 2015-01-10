//
// Created by Krzysztof Kaczor on 1/6/15.
//

#import <Foundation/Foundation.h>


@interface DebugService : NSObject
+ (DebugService *)instance;

@property NSMutableArray *constantPoints;
@property NSMutableArray *constantHelperPoints; //displayed on helper cameras
@property NSMutableArray *constantLines;
@property NSMutableArray *constantHelperLines; //displayed on helper cameras

@property NSMutableArray *dynamicHelperPoints;

- (void)clearDynamicData;

- (NSArray *)getAllPoints;
@end