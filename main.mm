#include <QApplication>
#include <QPushButton>
#include <Metal/Metal.h>
#include <MetalPerformanceShaders/MetalPerformanceShaders.h>
#include <AVFoundation/AVFoundation.h>
#include <iostream>

AVCaptureSession* setupCaptureSession() {
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *captureDeviceInputSetupError;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&captureDeviceInputSetupError];
    if (captureDeviceInputSetupError != nullptr) {
        throw std::runtime_error(captureDeviceInputSetupError.description.UTF8String);
    }
    if ([captureSession canAddInput:input]) {
        [captureSession addInput:input];
    }
    return captureSession;
}

int main(int argc, char *argv[]) {
    // id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    // std::cout << device.description.UTF8String << std::endl;
    // std::cout << MPSSupportsMTLDevice(device) << std::endl;
    // std::cout << [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] << std::endl;
    // std::cout << AVAuthorizationStatusNotDetermined;
    AVCaptureSession *session;
    switch([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusDenied:
            return EXIT_FAILURE;
        case AVAuthorizationStatusRestricted:
            return EXIT_FAILURE;
        case AVAuthorizationStatusAuthorized:
            try {
                setupCaptureSession();
            } catch (std::runtime_error& error) {
                return EXIT_FAILURE;
            }
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                if (granted) {
                    setupCaptureSession();
                }
            }];
            break;
    }

    QApplication a(argc, argv);
    QPushButton button("Hello world!", nullptr);
    button.resize(200, 100);
    button.show();
    return QApplication::exec();
}
