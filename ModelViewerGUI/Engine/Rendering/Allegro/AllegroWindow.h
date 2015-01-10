//
// Created by Krzysztof Kaczor on 12/28/14.
//

#import <Foundation/Foundation.h>
#import <allegro5/display.h>


@interface AllegroWindow : NSObject
@property int width;
@property int height;
@property (nonatomic) ALLEGRO_DISPLAY* display;


- (instancetype)initWithWidth:(int)width height:(int)height;

+ (instancetype)windowWithWidth:(int)width height:(int)height;


@end