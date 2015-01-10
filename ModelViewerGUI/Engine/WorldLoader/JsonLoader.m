//
// Created by Krzysztof Kaczor on 1/2/15.
//

#import "JsonLoader.h"
#import "SceneModel.h"
#import "Vector.h"
#import "Triangle.h"
#import "Model.h"
#import "YCMatrix+Affine3D.h"
#import "Color.h"
#import "LightSource.h"

@implementation JsonLoader {

}
- (SceneModel *)loadModelFromFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    NSDictionary *modelJson = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];

    Model *model = [self getModelFrom:modelJson];

    YCMatrix * modelToWorldMatrix = [self getModelToWorldMatrixFrom:modelJson];

    return [SceneModel modelOnSceneWithModel:model modelToWorldMatrix:modelToWorldMatrix];
}

- (LightSource *)loadLightSourceFromFile:(NSString *)path {
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream open];
    NSDictionary *lightSourceJson = [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];

    Vector *position = [self getPointFromJson:lightSourceJson[@"position"]];
    Color *color = [self getColorFromJson:lightSourceJson[@"color"]];

    LightSource *lightSource = [LightSource sourceWithPosition:position color:color];
    lightSource.c2 = [lightSourceJson[@"options"][@"c2"] doubleValue];
    lightSource.c1 = [lightSourceJson[@"options"][@"c1"] doubleValue];
    lightSource.c0 = [lightSourceJson[@"options"][@"c0"] doubleValue];
    return lightSource;
}


- (YCMatrix *)getModelToWorldMatrixFrom:(NSDictionary *)dictionary {
    BOOL flip = [dictionary[@"flip"] boolValue];
    Vector *point = [self getPointFromJson:dictionary[@"position"]];

    YCMatrix* scal = [YCMatrix scaleY:flip? -1 : 1];
    YCMatrix* tran = [YCMatrix translationX:point.x Y:point.y Z:point.z];
    YCMatrix* modelToWorldMatrix = [YCMatrix assembleFromRightToLeft:@[
            tran,
            scal,
    ]];

    return modelToWorldMatrix;
}

- (Model *)getModelFrom:(NSDictionary *)modelJson {
    NSMutableArray *verticles = [NSMutableArray array];

    [modelJson[@"verticles"] enumerateObjectsUsingBlock:^(NSDictionary *verticlesJson, NSUInteger idx, BOOL *stop) {
        Vector* position = [self getPointFromJson:verticlesJson[@"position"]];
        Color* color = [self getColorFromJson:verticlesJson[@"color"]];
        Vertex* vertex = [Vertex vertexWithPosition:position color:color];
        [verticles addObject:vertex];
    }];

    NSMutableArray *triangles = [NSMutableArray array];

    [modelJson[@"triangles"] enumerateObjectsUsingBlock:^(NSDictionary *triangleJson, NSUInteger idx, BOOL *stop) {
        int point1Index = [triangleJson[@"v1"] intValue];
        int point2Index = [triangleJson[@"v2"] intValue];
        int point3Index = [triangleJson[@"v3"] intValue];

        Triangle *triangle = [Triangle triangleWithP1: verticles[point1Index] p2: verticles[point2Index] p3: verticles[point3Index] ];
        [triangles addObject:triangle];
    }];

    Vector* pointInside = [self getPointFromJson:modelJson[@"pointInside"]];

    Model* model = [Model modelWithVertices:verticles triangles:triangles pointInside:pointInside];
    return model;
}

- (Vector *)getPointFromJson:(NSDictionary *)json {
    double x = [json[@"x"] doubleValue];
    double y = [json[@"y"] doubleValue];
    double z = [json[@"z"] doubleValue];

    return [Vector vectorWithX:x y:y z:z];
}

- (Color *)getColorFromJson:(NSDictionary *)json {
    if (json == nil)
        return nil;

    double r = [json[@"r"] doubleValue];
    double g = [json[@"g"] doubleValue];
    double b = [json[@"b"] doubleValue];

    return [Color colorWithR:r g:g b:b];
}

@end