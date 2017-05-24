//
//  UpLoadImageVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^UploadImageBlock)(NSArray *UrlArr);

@interface UpLoadImageVC : BaseViewController
@property (nonatomic, copy) UploadImageBlock  uploadImageBlock ;

-(void)UploadImageBlock:(UploadImageBlock)block;

@end
