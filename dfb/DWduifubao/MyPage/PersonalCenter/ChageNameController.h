//
//  ChageNameController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/25.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
@protocol ChageNameControllerDelegate <NSObject>

-(void)changenick_name:(NSString*)nick_name;

@end


@interface ChageNameController : BaseViewController
///nick_name
@property (nonatomic, strong) NSString *nick_name ;
///delgate
@property (nonatomic, assign) id<ChageNameControllerDelegate> delegate;





@end
