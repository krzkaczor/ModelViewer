//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import "AllegroWindow.h"


@implementation AllegroWindow

- (instancetype)initWithWidth:(int)width height:(int)height {
    self = [super init];
    if (self) {
        self.width = width;
        self.height = height;
    }
    self.display = al_create_display(width, height);

    return self;
}

+ (instancetype)windowWithWidth:(int)width height:(int)height {
    return [[self alloc] initWithWidth:width height:height];
}

@end