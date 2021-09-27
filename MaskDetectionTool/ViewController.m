//
//  ViewController.m
//  MaskDetectionTool
//
//  Created by Paul Pan on 21/09/26.
//

#import "ViewController.h"

@implementation ViewController

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVMetalTextureCacheRef textureCache = nil;
    CVReturn status = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, MTLCreateSystemDefaultDevice(), nil, &textureCache);
    if (status != kCVReturnSuccess) {
    }
    
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CVMetalTextureRef texture = nil;
    CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, imageBuffer, nil, MTLPixelFormatBGRA8Unorm, width, height, 0, &texture);
    
    if (texture == nil) {}
    
    id<MTLTexture> metalTexture = CVMetalTextureGetTexture(texture);
    
    MPSImage *image = [[MPSImage alloc] initWithTexture:metalTexture featureChannels:3];
    printf("Hello\n");
}

- (void)setupCaptureSession {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error != nil) {}
    
    [session beginConfiguration];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    
    if(![session canAddInput:input]) {
    }
    
    [session addInput:input];
    
    dispatch_queue_t queue = dispatch_queue_create("Video Queue", DISPATCH_QUEUE_CONCURRENT);
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    
    if (![session canAddOutput:output]) {}
    
    [session addOutput:output];
    output.alwaysDiscardsLateVideoFrames = true;
    output.videoSettings = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]] forKeys:@[(__bridge NSString *) kCVPixelBufferPixelFormatTypeKey]];
    [output setSampleBufferDelegate:self queue:queue];
    
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    
    connection.enabled = true;
    [session commitConfiguration];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [session startRunning];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CALayer *rootLayer = self.view.layer;
        layer.frame = rootLayer.bounds;
        [rootLayer addSublayer:layer];
    });
}

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, NSScreen.mainScreen.frame.size.width / 4, NSScreen.mainScreen.frame.size.height / 4)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    NSView *subView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, NSScreen.mainScreen.frame.size.width / 4, NSScreen.mainScreen.frame.size.height / 4)];
    
    [self.view addSubview:subView];
    
    subView.wantsLayer = true;
    subView.layer.backgroundColor = NSColor.redColor.CGColor;
    switch([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusDenied:
            break;
        case AVAuthorizationStatusRestricted:
            break;
        case AVAuthorizationStatusAuthorized: {
            [self setupCaptureSession];
            break;
        }
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                if (granted) {
                    [self setupCaptureSession];
                }
            }];
            break;
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
