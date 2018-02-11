//
//  QRCodeTools.h
//  DemoQRCode
//
//  Created by CoodyChou on 2016/2/10.
//  Copyright © 2016年 LJC. All rights reserved.
//

#import <Foundation/Foundation.h>

// for UIKit
#import <UIKit/UIKit.h>

#pragma mark - QRCodeToolsProtocol
@protocol QRCodeToolsProtocol <NSObject>
@required
-(void)getResultSuccessWithMsg:(NSString *)tempResultMsg;
-(void)getResultFail;
@end


#pragma mark - QRCodeTools Object
/**
 * @brief   - 包裝好處理 QRCode 的三種功能
 * @details - 1. 裝置掃描 QRCode
 * @details - 2. 讀取 Image 的 QRCode
 * @details - 3. 建立 QRCode
 *
 * @sa      - 參考資料：http://adad184.com/2015/09/30/goodbye-zxing/
 *                    https://github.com/adad184/DemoQRCode
 * @sa      - 原理：http://bydshine.iteye.com/blog/1849520
 */
@interface QRCodeTools : NSObject
@property (nonatomic, strong) UIView *scanRectView;

/** 初始化 */
-(instancetype)initWithDelegate:(id < QRCodeToolsProtocol >)tempDelegate;

/** 
 * @brief  - Camera 掃描 QRCode 的時候的框框細節設置
 * @params - tempBorderColor : 邊框顏色
 * @params - tempBorderWidth : 邊框粗細
 * @params - temopCornerRadius : 邊框角角的圓弧角度
 */
-(void)setScanRectWithBorderColor:(UIColor *)tempBorderColor
                  withBorderWidth:(CGFloat)tempBorderWidth
                 withCornerRadius:(CGFloat)tempCornerRadius;

#pragma mark : 1. 裝置掃描 QRCode
/**
 * @brief   - 建立 QRCode 掃描 View;
 */
-(UIView *)createViewWithScanQRCode;

/**
 * @brief   - 建立 QRCode 掃描的 View 並且使用客製化 frame（非全螢幕）
 */
-(UIView *)createViewWithScanQRCodeWithFrame:(CGRect)frame;

/**
 * @brief   - 啟動掃描
 */
-(void)start;

#pragma mark : 2. 讀取 Image 的 QRCode
/**
 * @brief   - 讀取 Image 的 QRCode
 */
-(void)createReadQRCodeWithImage:(UIImage *)tempImage;

#pragma mark : 3. 從字串產生 QRCode Image
/**
 * @brief   - 從字串產生 QRCode Image
 */
+(UIImage *)createQRForString:(NSString *)qrString;

@end
