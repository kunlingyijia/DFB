//
//  Good_CommentsCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "Good_CommentsCell.h"
#import "CommentsModel.h"
@implementation Good_CommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)cellGetDAta:(CommentsModel*)model{
    [DWHelper SD_WebImage:_avatar_url imageUrlStr:model.avatar_url placeholderImage:nil];
    [_nick_name setTitle:model.nick_name forState:(UIControlStateNormal)];
    _content.text = model.content;
    _create_time.text = model.create_time;
}
@end
