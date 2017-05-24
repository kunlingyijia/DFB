//
//  Bank_Region_Bank_Branch.h
//  Bank_Region_Bank_branch
//
//  Created by 席亚坤 on 16/12/6.
//  Copyright © 2016年 席亚坤. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Bank_Region_Bank_BranchModel : NSObject
///银行
@property (nonatomic, strong) NSString *bank_name;
///银行id
@property (nonatomic, strong) NSString *bank_no;
///支行
@property (nonatomic, strong) NSString *bank_branch;
///支行id
@property (nonatomic, strong) NSString *bank_branch_no;
///省
@property (nonatomic, strong) NSString *province_name;
///省id
@property (nonatomic, strong) NSString *province_id;
///市
@property (nonatomic, strong) NSString *city_name;
///市id
@property (nonatomic, strong) NSString *city_id;




@end

typedef void(^ReturnData)(NSMutableArray * arr);
@class FMDatabase;
@interface Bank_Region_Bank_Branch : NSObject
///
@property (nonatomic, strong) FMDatabase *db;//存储数据库操作对象
///ReturnData
//@property (nonatomic, copy) ReturnData  ReturnArr ;



+(Bank_Region_Bank_Branch*)shareBank_Region_Bank_Branch;
//1.创建数据库
-(void)creatDataBase;
//获取银行
-(void)selectDataFromBack:(ReturnData)ReturnArr;
//获取省
-(void)selectDataFromProvince:(ReturnData)ReturnArr;
//获取市
-(void)selectDataFromCityWithProvince_id:(NSString*)province_id ReturnArr :(ReturnData)ReturnArr;
//获取支行
-(void)selectDataFromBack_branchWithBack_no:(NSString *)back_no city_id:(NSString*)city_id ReturnArr :(ReturnData)ReturnArr;
//模糊搜索支行
-(void)selectDataFromBack_branchWithBack_no:(NSString *)back_no city_id:(NSString*)city_id Str:(NSString*)str ReturnArr :(ReturnData)ReturnArr;

@end
