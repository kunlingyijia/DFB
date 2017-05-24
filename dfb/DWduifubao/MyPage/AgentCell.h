//
//  AgentCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AgentModel;
@interface AgentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *region_name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *ID;
-(void)cellGetData:(AgentModel*)model;
@end
