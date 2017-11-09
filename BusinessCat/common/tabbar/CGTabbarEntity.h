//
//  CGTabbarEntity.h
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGTabbarEntity : NSObject

@property(nonatomic,assign)int index;//下标
@property(nonatomic,retain)NSString *title;//标题
@property(nonatomic,retain)NSString *normalImage;//未选中背景图片
@property(nonatomic,retain)NSString *selectedName;//选中背景图片
@property(nonatomic,assign)BOOL selected;//是否被选中

@end
