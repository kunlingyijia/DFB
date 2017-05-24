//
//  ReceiveAddressController.h
//  RiXin
//
//  Created by 月美 刘 on 16/9/30.
//  Copyright © 2016年 月美 刘. All rights reserved.
//

#import "BaseViewController.h"
@class AddressModel;
@interface ReceiveAddressController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *name;         //收货人姓名
@property (weak, nonatomic) IBOutlet UITextField *phone;        //手机号码
@property (weak, nonatomic) IBOutlet UITextField *plateNo;      //邮政编码
@property (weak, nonatomic) IBOutlet UIButton *chooseAreaBtn;   //省、市、区
@property (weak, nonatomic) IBOutlet UITextField *street;       //街道
@property (weak, nonatomic) IBOutlet UITextField *detail;       //详细资料

- (IBAction)chooseAreaBtnAction:(UIButton *)sender;  //“选择省、市、区”的按钮事件
- (IBAction)saveBtnAction:(UIButton *)sender;        //“保存”的按钮事件
@property (weak, nonatomic) IBOutlet UISwitch *MorenSwitch;
//属性传值
///model
@property (nonatomic, strong) AddressModel *addressModel ;
///标志
@property (nonatomic, strong) NSString *Type ;




@end
