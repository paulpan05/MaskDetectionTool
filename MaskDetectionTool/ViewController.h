//
//  ViewController.h
//  MaskDetectionTool
//
//  Created by Paul Pan on 21/09/26.
//

#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : NSViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)setupCaptureSession;

@end

