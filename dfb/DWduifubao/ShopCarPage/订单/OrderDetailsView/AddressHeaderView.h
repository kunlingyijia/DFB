//
//  AddressHeaderView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;

@interface AddressHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
///地址
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *AddAddressBtn;

-(void)cellGetData:(AddressModel*)model;

@end
