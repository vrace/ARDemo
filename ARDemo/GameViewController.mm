#import "GameViewController.h"
#import "ARScene.h"
#import "FakeCameraReader.h"
#import "DeviceCameraReader.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <iostream>

int ScreenWidth = 0;
int ScreenHeight = 0;

@interface GameViewController () {
    ARScene *scene;
    DeviceCameraReader cameraReader;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.opaque = NO;
    view.layer.opaque = NO;
    view.alpha = 1;
    view.backgroundColor = [UIColor clearColor];
    
    [self setupGL];
    
    scene = new ARScene(cameraReader);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize size = self.view.frame.size;
    ScreenWidth = size.width;
    ScreenHeight = size.height;
    
    scene->StartTracking(cameraReader);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    scene->StopTracking();
}

- (void)dealloc
{
    delete scene;
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    
    glShadeModel(GL_SMOOTH);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    scene->Update(self.timeSinceLastUpdate);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    GLKMatrix4 projection = GLKMatrix4MakePerspective(M_PI_4, (float)ScreenWidth / MAX(1, ScreenHeight), 0.1f, 1000.0f);
    glLoadMatrixf(projection.m);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    scene->Render();
}

- (void)updateCameraData:(void *)address bytesPerRow:(size_t)bytesPerRow width:(size_t)width height:(size_t)height
{
    cameraReader.FeedCameraData((unsigned char*)address, (int)width, (int)height, (int)(bytesPerRow / width));
}

@end
