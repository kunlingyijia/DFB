//
//  Good_CommentsCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class CommentsModel;
@interface Good_CommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar_url;
@property (weak, nonatomic) IBOutlet PublicBtn *nick_name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *create_time;
-(void)cellGetDAta:(CommentsModel*)model;
@end
