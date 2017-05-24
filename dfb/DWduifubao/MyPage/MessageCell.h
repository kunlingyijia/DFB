//
//  MessageCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/3.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *content;
-(void)cellGetData:(MessageModel*)model;

@end
