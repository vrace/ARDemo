#import "MainViewController.h"
#import "GameViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>

@interface MainViewController() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) GameViewController *gamevc;
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *captureOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *capturePreview;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCamera];
    
    self.gamevc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameView"];
    [self.view addSubview:self.gamevc.view];
    [self addChildViewController:self.gamevc];
    [self.gamevc didMoveToParentViewController:self];
    
    self.gamevc.view.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.captureSession startRunning];
    self.capturePreview.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.captureSession stopRunning];
}

- (void)setupCamera
{
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    
    if (self.captureInput)
    {
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:self.captureInput];
        
        self.capturePreview = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.capturePreview.frame = self.view.bounds;
        
        [self.view.layer addSublayer:self.capturePreview];
        [self setupOutput];
    }
    else
    {
        NSLog(@"Can't open camera");
    }
}

- (void)setupOutput
{
    if (self.captureSession)
    {
        self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        NSDictionary *settings = @{ (NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA) };
        self.captureOutput.videoSettings = settings;
        self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
        
        dispatch_queue_t outputQueue = dispatch_queue_create("CaptureOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.captureOutput setSampleBufferDelegate:self queue:outputQueue];
        
        if ([self.captureSession canAddOutput:self.captureOutput])
            [self.captureSession addOutput:self.captureOutput];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    [self.gamevc updateCameraData:baseAddress bytesPerRow:bytesPerRow width:width height:height];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

@end