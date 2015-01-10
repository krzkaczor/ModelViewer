//
// Created by Krzysztof Kaczor on 1/3/15.
//

#import <allegro5/allegro_primitives.h>
#import "AllegroSimpleTriangleRenderer.h"
#import "Triangle.h"
#import "Vector.h"
#import "DoublePoint.h"
#import "Vertex.h"


@implementation AllegroSimpleTriangleRenderer {

}
- (void)renderTriangle:(Triangle *)triangle {
    al_draw_line((float) triangle.v1.position.x, (float) triangle.v1.position.y, (float) triangle.v2.position.x, (float) triangle.v2.position.y, al_map_rgb_f(1, 1, 1), 0);
    al_draw_line((float) triangle.v2.position.x, (float) triangle.v2.position.y, (float) triangle.v3.position.x, (float) triangle.v3.position.y, al_map_rgb_f(1, 1, 1), 0);
    al_draw_line((float) triangle.v3.position.x, (float) triangle.v3.position.y, (float) triangle.v1.position.x, (float) triangle.v1.position.y, al_map_rgb_f(1, 1, 1), 0);
}

- (void)startRenderCycle {

}


@end