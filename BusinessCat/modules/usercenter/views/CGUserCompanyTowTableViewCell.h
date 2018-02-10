//
//  CGUserCompanyTowTableViewCell.h
//  CGSays
//
//  Created by zhu on 2016/12/15.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, OrganisationSelectType) {
  OrganisationSelectTypeClaim            = 0,  //认领组织
  OrganisationSelectTypeJoinAudit        = 1,  //加入审核
  OrganisationSelectTypeManagement       = 2,  //组织架构
  OrganisationSelectTypeAddressbook      = 3,  //通讯录
  OrganisationSelectTypeNviteMembers     = 4,  //邀请成员
  OrganisationSelectTypePrivilege        = 5,  //团队特权
  OrganisationSelectTypeEnterpriseCircle = 6,  //企业圈
  OrganisationSelectTypeEnterpriseFire   = 7,  //企业文档
  OrganisationSelectTypeHousekeeper      = 8,  //企业管家
  OrganisationSelectTypeToSearch         = 9,  //跳搜索功能的
  OrganisationSelectTypeIsLogOut         = 10, //未登录
    OrganisationSelectTypeShareProfit         = 11 //共享收益

};

typedef void(^SelectedButtonIndex)(NSInteger type);
@interface CGUserCompanyTowTableViewCell : UITableViewCell
@property (strong, nonatomic) SelectedButtonIndex block;
- (void)didSelectedButtonIndex:(SelectedButtonIndex)block;
- (void)info:(NSMutableArray *)array;
@end
