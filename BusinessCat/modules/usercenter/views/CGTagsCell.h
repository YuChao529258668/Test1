//
//  CGTagsCell.h
//  CGSays
//
//  Created by zhu on 2016/11/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGTagCollectionViewFlowLayout.h"

@class CGTagAttribute;

@interface CGTagsCell : UITableViewCell

@property (nonatomic,strong) NSArray *tags;//传入的标签数组 字符串数组
@property (nonatomic,strong) NSMutableArray *selectedTags; //选择的标签数组
@property (nonatomic,strong) CGTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) CGTagAttribute *tagAttribute;//按钮样式对象
@property (nonatomic,assign) BOOL isMultiSelect;//是否可以多选 默认:NO 单选
@property (nonatomic,copy) NSString *key;//搜索关键词

@property (nonatomic,copy) void (^completion)(NSArray *selectTags,NSInteger currentIndex);//选中的标签数组,当前点击的index

//刷新界面
- (void)reloadData;

/**
 *  计算Cell的高度
 *
 *  @param tags         标签数组
 *  @param layout       布局样式 默认则传nil
 *  @param tagAttribute 标签样式 默认传nil 涉及到计算的主要是titleSize
 *  @param width        计算的最大范围
 */
+ (CGFloat)getCellHeightWithTags:(NSArray *)tags layout:(CGTagCollectionViewFlowLayout *)layout tagAttribute:(CGTagAttribute *)tagAttribute width:(CGFloat)width;

@end
