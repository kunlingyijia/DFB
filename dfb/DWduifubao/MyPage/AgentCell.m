//
//  AgentCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AgentCell.h"
#import "AgentModel.h"
@implementation AgentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(AgentModel*)model{
    if ([model.status isEqualToString:@"1"]) {
        self.status.text  = @"待审核";
        
    }else if ([model.status isEqualToString:@"2"]){
        self.status.text  = @"审核通过";
        
    }else{
        self.status.text  = @"审核失败";
        
    }
    self.region_name.text = model.region_name;
    self.create_time.text =[NSString stringWithFormat:@"申请时间:%@" ,model.create_time];
    self.ID.text =[NSString stringWithFormat:@"ID:%@", model.ID];

}
@end
