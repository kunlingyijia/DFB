//
//  IndianaMyThreeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"
#import "YHWorkGroupPhotoContainer.h"
@interface IndianaMyThreeCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>
///HotHomeCellBlock
@property (nonatomic, copy) void(^IndianaMyThreeCellBlock)(NSInteger tag) ;
///
@property (nonatomic, strong) UICollectionView  *collectionView ;
-(void)CellGetData:(NSMutableArray*)Arr;
///
@property (nonatomic, assign) NSInteger count;


@property (nonatomic,strong)YHWorkGroupPhotoContainer *picContainerView;
@end
