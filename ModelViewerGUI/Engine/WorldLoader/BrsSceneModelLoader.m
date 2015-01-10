//
// Created by Krzysztof Kaczor on 1/10/15.
// Copyright (c) 2015 kaczor. All rights reserved.
//

#import "BrsSceneModelLoader.h"
#import "Triangle.h"
#import "Color.h"
#import "YCMatrix+Affine3D.h"
#import "SceneModel.h"
#import "Model.h"


@implementation BrsSceneModelLoader {

}

- (SceneModel *)loadModelFromFile:(NSString *)path {
    NSString *brsFileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSScanner *brsScanner = [NSScanner scannerWithString:brsFileContents];

    NSMutableArray* vertices = [self parseVerticesListUsingScanner:brsScanner];

    NSMutableArray* triangles = [self parseTriangleListUsingScanner:brsScanner andVertices:vertices];

    Model* model = [Model modelWithVertices:vertices triangles:triangles pointInside:[Vector vectorWithX:0 y:0 z:0]];

    return [SceneModel modelOnSceneWithModel:model modelToWorldMatrix:[YCMatrix identityOfRows:4 Columns:4]];
}

- (NSMutableArray*)parseVerticesListUsingScanner:(NSScanner *)brsScanner {
    NSMutableArray *verticesArray = [NSMutableArray array];

    int verticesNo;
    [brsScanner scanInt:&verticesNo];
    for(int i = 0;i < verticesNo;i++) {
        double x, y, z;
        [brsScanner scanDouble:&x];
        [brsScanner scanDouble:&y];
        [brsScanner scanDouble:&z];

        Vertex* vertex = [Vertex vertexWithPosition:[Vector vectorWithX:x y:y z:z] color:Color.red];
        [verticesArray addObject:vertex];
    }

    return verticesArray;
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