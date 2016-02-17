//
//  ViewController.m
//  QRCodeTestProject
//
//  Created by CoodyChou on 2016/2/8.
//  Copyright © 2016年 CoodyChou. All rights reserved.
//

#import "ViewController.h"

#import "QRCodeTools.h"

#import <UIKit/UIKit.h>

@interface ViewController () <QRCodeToolsProtocol ,
                              UINavigationControllerDelegate,
                              UIImagePickerControllerDelegate>
@property (nonatomic , strong) QRCodeTools *qrcodeTools;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        UIButton *qrcodeCameraButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [qrcodeCameraButton setTitle:@"使用 Camera" forState:(UIControlStateNormal)];
        [qrcodeCameraButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [qrcodeCameraButton setFrame:CGRectMake(self.view.frame.size.width*0.5 - 60,
                                                CGRectGetMaxY([UIScreen mainScreen].bounds)*0.5- 80,
                                                120,
                                                40)];
        [self.view addSubview:qrcodeCameraButton];
        [qrcodeCameraButton addTarget:self action:@selector(pressedQrcodeCameraButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    {
        UIButton *pickImageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [pickImageButton setTitle:@"使用 Photos" forState:(UIControlStateNormal)];
        [pickImageButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [pickImageButton setFrame:CGRectMake(self.view.frame.size.width*0.5 - 60,
                                             CGRectGetMaxY([UIScreen mainScreen].bounds)*0.5,
                                             120,
                                             40)];
        [self.view addSubview:pickImageButton];
        [pickImageButton addTarget:self action:@selector(pressedPickImageButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}

-(void)pressedQrcodeCameraButton{
    
    if ( _qrcodeTools == nil ) {
        _qrcodeTools = [[QRCodeTools alloc] initWithDelegate:self];
    }
    
    [_qrcodeTools setScanRectWithBorderColor:[UIColor whiteColor]
                             withBorderWidth:3.0f
                            withCornerRadius:10.0f];
    [self.view addSubview:[_qrcodeTools createViewWithScanQRCode]];
    [_qrcodeTools start];
}

-(void)pressedPickImageButton{
    
    if ( _qrcodeTools == nil ) {
        _qrcodeTools = [[QRCodeTools alloc] initWithDelegate:self];
    }
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

#pragma mark - QRCodeTools 的 Delegate
-(void)getResultSuccessWithMsg:(NSString *)tempResultMsg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode 查詢結果"
                                                                   message:tempResultMsg
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定"
                                                            style:(UIAlertActionStyleDefault)
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [_qrcodeTools start];
                                                          }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

-(void)getResultFail{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QRCode 查詢有誤！"
                                                                   message:@"Error!!!"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:(UIAlertActionStyleCancel)
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark - PickerView 的 Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [_qrcodeTools createReadQRCodeWithImage:srcImage];
}


@end
