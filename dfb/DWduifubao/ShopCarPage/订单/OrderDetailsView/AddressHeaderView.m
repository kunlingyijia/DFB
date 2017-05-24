//
//  AddressHeaderView.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "AddressHeaderView.h"
#import "AddressModel.h"
@implementation AddressHeaderView
///赋值
-(void)cellGetData:(AddressModel*)model{
    self.name.text = model.name;
    NSString *tel = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.mobile.text = tel;
    self.address.text = [NSString stringWithFormat:@"%@%@",model.zone,model.address];
}
-(void)layoutSubviews{
    CGRect  Frame= self.frame;
    Frame.size.height =0.18*Width;
    self.frame= Frame;
}


@end
