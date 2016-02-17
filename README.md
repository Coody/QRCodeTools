# QRCodeTools for iOS with Objective-C #

### 說明 ###

* 原作者：ralph li(adad184)
* 將 [GitHub 的 code](https://github.com/adad184/DemoQRCode) 的原生代碼再包一層、方便使用的工具

### 如何使用 ###

* 將 QRCodeTools.h 以及 .m 拉入專案內
 1. 使用 Camera 拍照取得 QRCode 內容。

 			QRCodeTools *qrcodeTools = [[QRCodeTools alloc]]initWithDelegate:self];
			[self.view addSubview:[qrcodeTools createViewWithScanQRCode]];
			[qrcodeTools start];
		
		
 2. 使用 Photos 內建相簿取得 QRCode 照片並取得內容。


 			QRCodeTools *qrcodeTools = [[QRCodeTools alloc]]initWithDelegate:self];
			[qrcodeTools createReadQRCodeWithImage:image]; 
			
 3. 最後記得要去實作 QRCodeTools 的 Delegate

 			// 成功
			-(void)getResultSuccessWithMsg:(NSString *)tempResultMsg{
				// tempResultMsg 就是掃完 QRCode 所取得的字串。
			}
	
			// 失敗
			-(void)getResultFail{
				// show QRCode Error message alert or anything what you want.
			}

### 版權 ###

* 此版權由原作者 [ralph li's GitHub](https://github.com/adad184/DemoQRCode) 所有，如要使用還是要聯絡原作者同意，此為使用參考範例。