//
//  IndianaShopDetailsThreeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaShopModel;
@interface IndianaShopDetailsThreeCell : UITableViewCell
///model
@property (nonatomic, strong) IndianaShopModel *model ;
@property (nonatomic, copy) void(^IndianaShopDetailsNumberCellBlock)(NSString *number);
@property (nonatomic, copy) void(^IndianaShopDetailsThreeCellBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIView *AddAndDelView;
@property (weak, nonatomic) IBOutlet PublicTF *textTf;
@property (weak, nonatomic) IBOutlet PublicBtn *deleteBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyBtn;

@property (weak, nonatomic) IBOutlet UILabel *announce;
@property (weak, nonatomic) IBOutlet UILabel *start_time;



@end
