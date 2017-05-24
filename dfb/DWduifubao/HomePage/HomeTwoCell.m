//
//  HomeTwoCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "HomeTwoCell.h"
#import "PublicBtn.h"
#import "GoodsModel.h"
@implementation HomeTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)cellGetData:(NSMutableArray*)arr{
    if (arr.count==1) {
        for (int i =0; i <arr.count; i++) {
            if (i==0) {
                GoodsModel*oneModel= arr[0];
                [DWHelper SD_WebImage:_Onegoods_logo imageUrlStr:oneModel.goods_logo placeholderImage:nil];
                
            }
        }
    }else if(arr.count==2){
        for (int i =0; i <arr.count; i++) {
            if (i==0) {
                GoodsModel*oneModel= arr[0];
                [DWHelper SD_WebImage:_Onegoods_logo imageUrlStr:oneModel.goods_logo placeholderImage:nil];
                
            }else if (i==1){
                GoodsModel*twoModel= arr[1];
                [DWHelper SD_WebImage:_Twogoods_logo imageUrlStr:twoModel.goods_logo placeholderImage:nil];
            }
        }
    }else if(arr.count==3){
        for (int i =0; i <arr.count; i++) {
            if (i==0) {
                GoodsModel*oneModel= arr[0];
                [DWHelper SD_WebImage:_Onegoods_logo imageUrlStr:oneModel.goods_logo placeholderImage:nil];
                
            }else if (i==1){
                GoodsModel*twoModel= arr[1];
                [DWHelper SD_WebImage:_Twogoods_logo imageUrlStr:twoModel.goods_logo placeholderImage:nil];
            }else if (i==2){
                GoodsModel*threemodel= arr[2];
                [DWHelper SD_WebImage:_Threegoods_logo imageUrlStr:threemodel.goods_logo placeholderImage:nil];
            }
        }
    }else if(arr.count==4){
        for (int i =0; i <arr.count; i++) {
            if (i==0) {
                GoodsModel*oneModel= arr[0];
                [DWHelper SD_WebImage:_Onegoods_logo imageUrlStr:oneModel.goods_logo placeholderImage:nil];
                
            }else if (i==1){
                GoodsModel*twoModel= arr[1];
                [DWHelper SD_WebImage:_Twogoods_logo imageUrlStr:twoModel.goods_logo placeholderImage:nil];
            }else if (i==2){
                GoodsModel*threemodel= arr[2];
                [DWHelper SD_WebImage:_Threegoods_logo imageUrlStr:threemodel.goods_logo placeholderImage:nil];
            }else if (i==3){
                GoodsModel*fourmodel= arr[3];
                [DWHelper SD_WebImage:_Fourgoods_logoFour imageUrlStr:fourmodel.goods_logo placeholderImage:nil];
            }
        }
    }else if(arr.count ==5){
        for (int i =0; i <arr.count; i++) {
            if (i==0) {
                GoodsModel*oneModel= arr[0];
                [DWHelper SD_WebImage:_Onegoods_logo imageUrlStr:oneModel.goods_logo placeholderImage:nil];
                
            }else if (i==1){
                GoodsModel*twoModel= arr[1];
                [DWHelper SD_WebImage:_Twogoods_logo imageUrlStr:twoModel.goods_logo placeholderImage:nil];
            }else if (i==2){
                GoodsModel*threemodel= arr[2];
                [DWHelper SD_WebImage:_Threegoods_logo imageUrlStr:threemodel.goods_logo placeholderImage:nil];
            }else if (i==3){
                GoodsModel*fourmodel= arr[3];
                [DWHelper SD_WebImage:_Fourgoods_logoFour imageUrlStr:fourmodel.goods_logo placeholderImage:nil];
            }else if (i==4){
                GoodsModel*fivemodel= arr[4];
                [DWHelper SD_WebImage:_Fivegoods_logo imageUrlStr:fivemodel.goods_logo placeholderImage:nil];
            }else{
                
            }

    }
    



    }
    
//
//    GoodsModel*threeModel=arr[2];
//    GoodsModel*fourModel= arr[3];
//    GoodsModel*fiveModel= arr[4];
//
//    //
//    [DWHelper SD_WebImage:_Threegoods_logo imageUrlStr:threeModel.goods_logo placeholderImage:nil];
//    [DWHelper SD_WebImage:_Fourgoods_logoFour imageUrlStr:fourModel.goods_logo placeholderImage:nil];
//    [DWHelper SD_WebImage:_Fivegoods_logo imageUrlStr:fiveModel.goods_logo placeholderImage:nil];
}
@end
