//
// Created by Krzysztof Kaczor on 1/12/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "ObjSceneModelLoader.h"
#import "SceneModel.h"
#import "Vector.h"
#import "YCMatrix+Affine3D.h"
#import "Model.h"
#import "Vertex.h"
#import "Color.h"
#import "Triangle.h"


@implementation ObjSceneModelLoader {

}
- (SceneModel *)loadModelFromFile:(NSString *)path {
    NSString *objFileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSMutableArray* vertices = [NSMutableArray array];
    NSMutableArray* triangles = [NSMutableArray array];


    NSArray* splitted = [objFileContents componentsSeparatedByString:@"\n"];
    [splitted enumerateObjectsUsingBlock:^(NSString* line, NSUInteger idx, BOOL *stop) {
        if ([line hasPrefix:@"v"]) {
            [self parseVertex:line into:vertices];
        }
        if([line hasPrefix:@"f"]) {
            [self parseTriangle:line using:vertices into:triangles];
        }
    }];

    Model* model = [Model modelWithVertices:vertices triangles:triangles pointInside:[Vector vectorWithX:0 y:0 z:0]];

    return [SceneModel modelOnSceneWithModel:model modelToWorldMatrix:[YCMatrix identityOfRows:4 Columns:4]];
}

- (void)parseTriangle:(NSString *)line using:(NSMutableArray *)vertices into:(NSMutableArray*)triangles {
    int index1, index2, index3;
    NSScanner* scanner = [[NSScanner alloc] initWithString:line];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanInt:&index1];
    [scanner scanInt:&index2];
    [scanner scanInt:&index3];
    Triangle* t = [Triangle triangleWithP1:vertices[index1-1] p2:vertices[index2-1] p3:vertices[index3-1]];

    [triangles addObject:t];
}

- (void)parseVertex:(NSString*) string into:(NSMutableArray *)vertices {
    double x, y, z;
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    [scanner scanUpToString:@" " intoString:nil];
    [scanner scanDouble:&x];
    [scanner scanDouble:&y];
    [scanner scanDouble:&z];

    Vertex* vertex = [Vertex vertexWithPosition:[Vector vectorWithX:x y:y z:z] color:Color.red];

    [vertices addObject:vertex];
}

- (NSMutableArray *)parseTriangleListUsingScanner:(NSScanner *)brsScanner andVertices:(NSMutableArray *)vertices {
    NSMutableArray *trianglesArray = [NSMutableArray array];

    int trianglesNo;
    [brsScanner scanInt:&trianglesNo];
    for(int i = 0;i < trianglesNo;i++) {
        int v1, v2, v3;
        [brsScanner scanInt:&v1];
        [brsScanner scanInt:&v2];
        [brsScanner scanInt:&v3];

        Triangle *triangle = [Triangle triangleWithP1:vertices[v1] p2:vertices[v2] p3:vertices[v3]];
        [trianglesArray addObject:triangle];
    }

    return trianglesArray;
}
@end