//
//  AddressManageCell.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicBtn.h"
@class AddressModel;
@interface AddressManageCell : UITableViewCell
///名字
@property (weak, nonatomic) IBOutlet UILabel *name;
///手机号1
@property (weak, nonatomic) IBOutlet UILabel *phone;
///地址
@property (weak, nonatomic) IBOutlet UILabel *address;
///默认地址
@property (weak, nonatomic) IBOutlet PublicBtn *defaultAddressBtn;

@property (weak, nonatomic) IBOutlet PublicBtn *editBtn;      //"编辑"按钮
@property (weak, nonatomic) IBOutlet PublicBtn *deleteBtn;    //"删除"按钮

- (IBAction)defaultAddressBtnAction:(PublicBtn*)sender;   //"勾选默认地址"按钮的事件
- (IBAction)editBtnAction:(PublicBtn*)sender;             //"编辑"按钮的事件
- (IBAction)deleteBtnAction:(PublicBtn*)sender;           //"删除"按钮的事件
-(void)cellGetData:(AddressModel*)model;
@end
