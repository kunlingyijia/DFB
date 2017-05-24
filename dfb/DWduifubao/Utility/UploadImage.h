//
//  UploadImage.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^UploadImageBlock)(NSArray *UrlArr);
@interface UploadImage : NSObject

///UploadImageBlock
@property (nonatomic, copy) UploadImageBlock  uploadImageBlock ;
@property(nonatomic,weak)BaseViewController *baseVC;


-(void)UploadImage:(BaseViewController*) VC UploadImageBlock:(UploadImageBlock)block;
@end
