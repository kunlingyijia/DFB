//
//  MessageCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetData:(MessageModel*)model{
    self.title.text = model.title;
    self.content.text = model.content;
    self.create_time.text = model.create_time;
}

@end
