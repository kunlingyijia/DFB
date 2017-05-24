//
//  MoreNemberViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreNemberViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
