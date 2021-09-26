//
//  ViewController.m
//  MaskDetectionTool
//
//  Created by Paul Pan on 21/09/26.
//

#import "ViewController.h"

@implementation ViewController

- (AVCaptureSession *) setupCaptureSession {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [session beginConfiguration];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if([session canAddInput:input]) {
        [session addInput:input];
    }
    dispatch_queue_t queue = dispatch_queue_create("Video Queue", DISPATCH_QUEUE_CONCURRENT);
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    if([session canAddOutput:output]) {
        [session addOutput:output];
        output.alwaysDiscardsLateVideoFrames = true;
        output.videoSettings = (NSDictionary<NSString *, id> *) kCVPixelBufferPixelFormatTypeKey;
        [output setSampleBufferDelegate:self queue:queue];
    }
    [session commitConfiguration];
    return session;
}

- (void)loadView {
    self.view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, NSScreen.mainScreen.frame.size.width / 4, NSScreen.mainScreen.frame.size.height / 4)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    switch([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusDenied:
            break;
        case AVAuthorizationStatusRestricted:
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                if (granted) {
                    
                }
            }];
            break;
        case AVAuthorizationStatusAuthorized:
            break;
    }
    NSView *subView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, NSScreen.mainScreen.frame.size.width / 4, NSScreen.mainScreen.frame.size.height / 4)];
    
    [self.view addSubview:subView];
    
    subView.wantsLayer = true;
    subView.layer.backgroundColor = NSColor.redColor.CGColor;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
