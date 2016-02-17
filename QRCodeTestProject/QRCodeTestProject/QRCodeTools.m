//
//  QRCodeTools.m
//  DemoQRCode
//
//  Created by CoodyChou on 2016/2/10.
//  Copyright © 2016年 LJC. All rights reserved.
//

#import "QRCodeTools.h"

// for AVCapture
#import <AVFoundation/AVFoundation.h>

@interface QRCodeTools() < AVCaptureMetadataOutputObjectsDelegate >
@property (nonatomic, weak) id <QRCodeToolsProtocol> delegate;

@property (nonatomic, strong) UIView *mainView;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@end

@implementation QRCodeTools
-(id)init{
    NSLog(@"請使用 initWithDelegate: !!");
    return nil;
};

-(instancetype)initWithDelegate:(id < QRCodeToolsProtocol >)tempDelegate{
    self = [super init];
    if ( self ) {
        _delegate = tempDelegate;
        _scanRectView = [UIView new];
    }
    return self;
}

#pragma mark : 1. 裝置掃描 QRCode
-(UIView *)createViewWithScanQRCode{
    
    if ( _mainView == nil ) {
        // Do any additional setup after loading the view.
        
        CGSize windowSize = [UIScreen mainScreen].bounds.size;
        _mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        CGSize scanSize = CGSizeMake(windowSize.width*3/4,
                                     windowSize.width*3/4);
        CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2,
                                     (windowSize.height-scanSize.height)/2,
                                     scanSize.width,
                                     scanSize.height);
        
        scanRect = CGRectMake(scanRect.origin.y/windowSize.height,
                              scanRect.origin.x/windowSize.width,
                              scanRect.size.height/windowSize.height,
                              scanRect.size.width/windowSize.width);
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
        
        _output = [[AVCaptureMetadataOutput alloc]init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
        [_session addInput:_input];
        [_session addOutput:_output];
        _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
        _output.rectOfInterest = scanRect;
        
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = [UIScreen mainScreen].bounds;
        [_mainView.layer insertSublayer:_preview atIndex:0];
        
        [_mainView addSubview:_scanRectView];
        _scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
        _scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
        
        
    }
    return _mainView;
}

-(void)start{
    //开始捕获
    if ( self.session ) {
        [self.session startRunning];
    }
}

-(void)setScanRectWithBorderColor:(UIColor *)tempBorderColor
                  withBorderWidth:(CGFloat)tempBorderWidth
                 withCornerRadius:(CGFloat)tempCornerRadius
{
    self.scanRectView.layer.borderColor = tempBorderColor.CGColor;
    self.scanRectView.layer.borderWidth = tempBorderWidth;
    self.scanRectView.layer.cornerRadius = tempCornerRadius;
    self.scanRectView.layer.masksToBounds = YES;
}

#pragma mark : 2. 讀取 Image 的 QRCode
-(void)createReadQRCodeWithImage:(UIImage *)tempImage{
    
    if ( tempImage == nil ) {
        [_delegate getResultFail];
    }
    else{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *image = [CIImage imageWithCGImage:tempImage.CGImage];
        NSArray *features = [detector featuresInImage:image];
        CIQRCodeFeature *feature = [features firstObject];
        
        NSString *resultMsg = feature.messageString;
        
        [_delegate getResultSuccessWithMsg:resultMsg];
    }
    
}

#pragma mark - 內部方法
#pragma mark : for AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count==0) )
    {
        [_delegate getResultFail];
        return;
    }
    
    if (metadataObjects.count>0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        [_delegate getResultSuccessWithMsg:metadataObject.stringValue];
        
    }
}

#pragma mark : for 

@end
