//
//  AdModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject
///广告类型
@property (nonatomic, assign) int position;
///区域id
@property (nonatomic, assign) int region_id;
///广告类型type 1-店铺首页  2-url
@property (nonatomic, assign) NSInteger type;
///外部链接
@property (nonatomic, strong) NSString *link_url ;
///原图
@property (nonatomic, strong) NSString *image_url ;

///店铺id
@property (nonatomic, assign) NSInteger merchant_id;








@end
