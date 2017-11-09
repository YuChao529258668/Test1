//
//  JCDoodleAction.h
//  涂鸦数据的定义，发送和接收的接口定义。
//
//  Created by young on 17/1/5.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 涂鸦动作相关类型
 */
typedef NS_ENUM(NSInteger, JCDoodleActionType) {
    JCDoodleActionUnknown = 50,
    JCDoodleActionStart,         //开始涂鸦
    JCDoodleActionStop,          //结束涂鸦
    JCDoodleActionDraw,          //画曲线
    JCDoodleActionClean,         //清除涂鸦的轨迹
    JCDoodleActionUndo,          //撤销最后一笔的涂鸦轨迹
    JCDoodleActionErase,         //橡皮檫
    JCDoodleActionSelectPage,    //翻页
    JCDoodleActionFetch,         //获取当前画的所有 action
    JCDoodleActionCourseware     //课件url改变
};

@interface JCDoodleAction : NSObject

//设置涂鸦动作的类型，默认为JCDoodleActionUnknown。可自定义类型（值的范围100~254），比如画矩形定义为101。
@property (nonatomic) JCDoodleActionType actionType;

//设置涂鸦动作的发起者，默认为nil
@property (nonatomic, copy) NSString *userId;

//设置自定义的数据，默认为nil
@property (nonatomic, copy) NSString *userDefined;

//当多页涂鸦的情况下，可以设置涂鸦动作发生在具体哪一页上，默认为0
@property (nonatomic) NSUInteger pageNumber;

//当画涂鸦轨迹时，设置轨迹的宽，默认为0
@property (nonatomic) CGFloat brushWidth;

//当画涂鸦轨迹时，设置轨迹的颜色，默认为nil
@property (nonatomic, copy) UIColor *brushColor;

//当画涂鸦轨迹时，获取轨迹的点的集合，默认为nil。数组内的每一个对象都是NSArray，表示一个点。
//一个点(NSArray)内包含了3个值，第一个值是和上一个点的时间间隔(毫秒, int型)，第二个值是点的x坐标(CGFloat型)，第三个值是点的y坐标(CGFloat型)。
@property (nonatomic, readonly, strong) NSArray<NSArray<NSNumber *> *> *pathPoints;

//当画涂鸦轨迹时，添加轨迹的每一个点
- (void)addPointWithPositionX:(CGFloat)x positionY:(CGFloat)y;

@end




@protocol JCDoodleDelegate <NSObject>

//接收涂鸦数据，必现在会议中才能收到。JCDoodleActionType是涂鸦动作的类型，JCDoodleAction是具体的涂鸦数据对象，userId是本次涂鸦的发送者
- (void)receiveActionType:(JCDoodleActionType)type doodle:(JCDoodleAction *)doodle fromSender:(NSString *)userId;

@end

@interface JCDoodleManager : NSObject

//必须在加入会议前设置
+ (void)setDelegate:(id<JCDoodleDelegate>)delegate;

//以下发送的接口都必须在会议中才有用

//把发起涂鸦的动作发送给会议中的所有成员（自己除外）
+ (int)startDoodle;

//把结束涂鸦的动作发送给会议中的所有成员（自己除外）
+ (int)stopDoodle;

//把清除涂鸦的动作发送给会议中的所有成员（自己除外）
+ (int)cleanDoodleWithPageNumber:(NSUInteger)page;

//把撤销的动作发送给会议中的所有成员（自己除外）
+ (int)undoWithPageNumber:(NSUInteger)page;

+ (int)eraseWithPageNumber:(NSUInteger)page;

//翻页
+ (int)selectPage:(NSUInteger)page;

//新加入的成员，获取当前画的所有 action
+ (int)fetchAllDrawAction;

//群发给会议中的所有成员（自己除外）
+ (int)sendDoodleAction:(JCDoodleAction *)doodle;

//单独发给一个成员，userId传想要发送的成员
+ (int)sendDoodleAction:(JCDoodleAction *)doodle toAnother:(NSString *)userId;

+ (NSString *)getUserIdOfDoodleOnwer;

+ (int)sendCoursewareUrl:(NSString *)url;

+ (NSString *)getCoursewareUrl;

@end
