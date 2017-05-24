//
//  MyLoanOrCardModel.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/20.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLoanOrCardModel : NSObject
///	类型  1-我要办卡 2-我要贷款
@property (nonatomic, strong) NSString  *type	 ;
///	id
@property (nonatomic, strong) NSString  *service_id ;
///标题
@property (nonatomic, strong) NSString  *title;
///图片url
@property (nonatomic, strong) NSString  *image_url;
///链接地址
@property (nonatomic, strong) NSString  *url	;
///顶部图片url
@property (nonatomic, strong) NSString  *top_image;





@end
