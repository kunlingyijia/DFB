//
//  SubmitAddressCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/28.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@interface SubmitAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
///地址
@property (weak, nonatomic) IBOutlet UILabel *address;
-(void)cellGetData:(AddressModel*)model;
@end
