//
// Created by Krzysztof Kaczor on 1/1/15.
//

#import <allegro5/color.h>
#import <allegro5/drawing.h>
#import <allegro5/display.h>
#import <allegro5/allegro_primitives.h>
#import "AllegroRenderer.h"
#import "AllegroTriangleRenderer.h"
#import "Scene.h"
#import "SceneModel.h"
#import "Model.h"
#import "Triangle.h"
#import "Vector.h"
#import "YCMatrix+Affine3D.h"
#import "Camera.h"
#import "AllegroWindow.h"
#import "Projection.h"
#import "OrthographicProjection.h"
#import "YCMatrix+Advanced.h"
#import "AllegroSimpleTriangleRenderer.h"
#import "DoublePoint.h"
#import "Color.h"
#import "PerspectiveProjection.h"
#import "LightSource.h"
#import "Line.h"
#import "DebugService.h"
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>

@implementation AllegroRenderer {
    AllegroWindow* window;
    BOOL debug;
}

- (instancetype)initWithSize:(CGSize)size triangleRenderer:(id <AllegroTriangleRenderer>)triangleRenderer debug:(BOOL)theDebug {
    self = [super init];
    if (self) {
        al_init();
        al_init_font_addon(); // initialize the font addon
        al_init_ttf_addon();// initialize the ttf (True Type Font) addon

        self.helperCameras = [NSMutableArray array];

        debug = theDebug;
        if (debug) {
            size = CGSizeMake(size.width * 2, size.height * 2);
            [self initHelperCameras];
        }

        window = [AllegroWindow windowWithWidth:(int) size.width height:(int) size.height];
        self.triangleRenderer=triangleRenderer;
    }

    return self;
}

- (void)initHelperCameras {
    double size = 30;
    id<Projection> projection = [OrthographicProjection projectionWithRight:size left:-size top:size bottom:-size far:1 near:10];

    Camera* frontCamera = [Camera cameraWithHeight:640 width:480 projection:projection];
    {
        YCMatrix *offset = [YCMatrix translationX:640 Y:0 Z:0];
        frontCamera.viewportMatrix = [offset matrixByMultiplyingWithRight:frontCamera.viewportMatrix];
    }

    Camera* topCamera = [Camera cameraWithHeight:640 width:480 projection:projection];
    {
        topCamera.worldToViewMatrix = [YCMatrix rotateXWithAngle:M_PI / 2];
        YCMatrix *offset = [YCMatrix translationX:0 Y:480 Z:0];
        topCamera.viewportMatrix = [offset matrixByMultiplyingWithRight:topCamera.viewportMatrix];
    }

    Camera* sideCamera = [Camera cameraWithHeight:640 width:480 projection:projection];
    {
        sideCamera.worldToViewMatrix = [YCMatrix rotateYWithAngle:M_PI / 2];
        YCMatrix *offset = [YCMatrix translationX:640 Y:480 Z:0];
        sideCamera.viewportMatrix = [offset matrixByMultiplyingWithRight:sideCamera.viewportMatrix];
    }

    self.helperCameras = [@[frontCamera, topCamera, sideCamera] mutableCopy];
}


- (void)render {
    al_clear_to_color(al_map_rgb_f(0, 0, 0));
    [self.triangleRenderer startRenderCycle];

    [self renderSceneUsingCamera: self.camera];

    [self.helperCameras enumerateObjectsUsingBlock:^(Camera*helperCamera, NSUInteger idx, BOOL *stop) {
        [self renderSceneUsingCamera: helperCamera];
    }];

    [self renderDebugData];

    al_flip_display();
}

- (void)renderDebugData {

    [self renderPoints:DebugService.instance.constantPoints usingCamera:self.camera];
    [self renderLines:DebugService.instance.constantLines usingCamera:self.camera];

    [self.helperCameras enumerateObjectsUsingBlock:^(Camera*helperCamera, NSUInteger idx, BOOL *stop) {
        [self renderPoints:DebugService.instance.constantPoints usingCamera:helperCamera];
        [self renderLines:DebugService.instance.constantLines usingCamera:helperCamera];

        [self renderPoints:DebugService.instance.constantHelperPoints usingCamera:helperCamera];
        [self renderLines:DebugService.instance.constantHelperLines usingCamera:helperCamera];

        [self renderPoints:DebugService.instance.dynamicHelperPoints usingCamera:helperCamera];
    }];
}

- (void)renderLines:(NSMutableArray *)lines usingCamera:(Camera *)camera {
    YCMatrix *transform = [YCMatrix assembleFromRightToLeft:@[
            camera.viewportMatrix,
            camera.projection.projectionMatrix,
            camera.worldToViewMatrix,
    ]];

    [lines enumerateObjectsUsingBlock:^(Line* line, NSUInteger idx, BOOL *stop) {
        Line* transformedLine = [line applyTransformation:transform];
        al_draw_line(transformedLine.a.x, transformedLine.a.y, transformedLine.b.x, transformedLine.b.y, al_map_rgb_f(transformedLine.color.r, transformedLine.color.g, transformedLine.color.b), 1);
    }];
}

//- (void)putDebugInfo {
//    DoublePoint *cameraPosition = [DoublePoint pointWithPos:[origin.position applyTransformation:[self.camera.worldToViewMatrix pseudoInverse]] color:[Color colorWithR:0 g:1 b:0]];
//
//    [self renderPoints:@[origin] usingCamera:self.camera];
//    [self renderVectorsA:vectorsA vectorsB:vectorsB usingCamera:self.camera];
//
//    [self.helperCameras enumerateObjectsUsingBlock:^(Camera*helperCamera, NSUInteger idx, BOOL *stop) {
//        [self renderSceneUsingCamera:helperCamera];
//        [self renderPoints:points usingCamera:helperCamera];
//        [self renderVectorsA:vectorsA vectorsB:vectorsB usingCamera:helperCamera];
//    }];
//
//    ALLEGRO_FONT* font = al_load_font("/Library/Fonts/Tahoma.ttf", 20, NULL);
//    al_draw_text(font,al_map_rgb(255,255,255), 0,0,0,"HelloWorld!");
//}

- (void)renderPoints:(NSArray*)points usingCamera:(Camera*)camera {
    YCMatrix *transform = [YCMatrix assembleFromRightToLeft:@[
            camera.viewportMatrix,
            camera.projection.projectionMatrix,
            camera.worldToViewMatrix,
    ]];

    [points enumerateObjectsUsingBlock:^(DoublePoint* vec, NSUInteger idx, BOOL *stop) {
        DoublePoint *point = [vec applyTransformation:transform];

        int halfSize = 4;
        al_draw_filled_rectangle(point.position.x - halfSize, point.position.y - halfSize, point.position.x + halfSize, point.position.y + halfSize, al_map_rgb_f(point.color.r, point.color.g, point.color.b));
    }];
}

- (void)renderSceneUsingCamera:(Camera*)camera {
    [self.scene.sceneModels enumerateObjectsUsingBlock:^(SceneModel *sceneObject, NSUInteger idx, BOOL *stop) {
        [self renderModel:sceneObject usingCamera:camera];
    }];
}

- (void)renderModel:(SceneModel *)sceneModel usingCamera:(Camera *) camera {
    YCMatrix *modelViewProjectionMatrix = [YCMatrix assembleFromRightToLeft:@[
            camera.viewportMatrix,
            camera.projection.projectionMatrix,
            camera.worldToViewMatrix,
            sceneModel.modelToWorldMatrix,
    ]];

    NSLog(@"%@", modelViewProjectionMatrix);

    [sceneModel.model.triangles enumerateObjectsUsingBlock:^(Triangle *triangle, NSUInteger idx, BOOL *stop) {
        [self renderTriangle:triangle withModelViewProjectionMatrix:modelViewProjectionMatrix];
    }];
//    [self renderTriangle:sceneModel.model.triangles[2] withModelViewProjectionMatrix:modelViewProjectionMatrix];
}

- (void)renderTriangle:(Triangle *)triangle withModelViewProjectionMatrix:(YCMatrix*) modelViewProjectionMatrix {
    Triangle* transformedTriangle = [triangle applyTransformation:modelViewProjectionMatrix];

//    [self.triangleRenderer renderTriangle:transformedTriangle];
    AllegroSimpleTriangleRenderer *simpleTriangleRenderer = [[AllegroSimpleTriangleRenderer alloc]init];
    [simpleTriangleRenderer renderTriangle:transformedTriangle];
}
@end