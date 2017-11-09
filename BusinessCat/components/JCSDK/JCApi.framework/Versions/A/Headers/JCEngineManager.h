//
//  JCEngine.h
//  JCApi
//
//  Created by 沈世达 on 17/4/24.
//  Copyright © 2017年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^JCRenderCompletionBlock)(void);

/**
 *  @brief 原因值
 */
typedef NS_ENUM(NSInteger, ErrorReason) {
    /** 默认值 */
    ErrorNone = 0,
    /** 其他错误 */
    ErrorOther,
    /** 其他错误 */
    ErrorRoomOther,
    /** 与服务器断开连接，主动断开 */
    DisconnectReasonActive,
    /** 与服务器断开连接，相同 userId 在别的设备登录 */
    DisconnectReasonDeacted,
    /** 与服务器断开连接，其他原因 */
    DisconnectReasonOther,
    /** 发起连接服务器失败，鉴权错误。只有当开发者将鉴权模式设置为 RSA 鉴权时才会通知此错误 */
    ErrorConnectFailAuth,
    /** 发起连接服务端失败，原因为无效的网络 */
    ErrorCodeErrLoginNetUnavailable,
    /** 发起连接服务端失败，原因为密码错误 */
    ErrorCodeErrLoginAuthFailed,
    /** 发起连接服务端失败，原因为超时 */
    ErrorCodeErrLoginTimeout,
    /** 加入房间失败，原因会议不存在 */
    ErrorJoinFailNotExist,
    /** 加入房间失败，原因房间已满 */
    ErrorJoinFailFull,
    /** 加入房间失败，原因密码错误 */
    ErrorJoinFailInvalidPassword,
    /** 加入房间失败，连接到服务器时失败 */
    ErrorJoinFailConnect,
    /** 加入房间失败，原因会议加入超时 */
    ErrorJoinFailTimeout,
    /** 加入房间失败，roomid不可用 */
    ErrorJoinFailRInvalidRoomID,
    /** 加入房间失败，当前网络异常 */
    ErrorJoinFailNetUnavailabile,
    /** 加入房间失败，当前已经在一个房间中 */
    ErrorJoinFailBusy,
    /** 媒体操作失败 */
    ErrorMediaChangeFail,
    /** 离开房间的原因，主动退出（调用离开房间的接口）*/
    ErrorEndQuit,
    /** 离开房间的原因，掉线 */
    ErrorEndOffline,
    /** 离开房间的原因，房间已关闭 */
    ErrorEndOver,
    /** 离开房间原因，被移出 */
    ErrorEndKicked,
    /** 离开房间的原因，其他原因 */
    ErrorEndOther,
    /** 日志打印级别，打印调试信息 */
    LogLevelDebug,
    /** 日志打印级别，仅打印必要信息 */
    LogLevelInfo,
    /** 日志打印级别，关闭 */
    LogLeaveOff,
    /** 日志类型，调试信息 */
    LogTypeDebug,
    /** 日志类型，错误信息 */
    LogTypeError,
    /** 日志类型，必要信息 */
    LogTypeInfo,
    /** 房间模式，直播模式 */
    RoomModeBroadcast,
    /** 房间模式，通信模式 */
    RoomModeCommunication,
    /** 房间状态，闲置 */
    RoomStateIdle,
    /** 房间状态，正在进入房间 */
    RoomStateJoining,
    /** 房间状态，正在离开房间 */
    RoomStateLeaving,
    /** 房间状态，已进入房间 */
    RoomStateOnAir,
    /** 房间状态，已就绪，正在等待连接至服务器的通知 */
    RoomStateReady,
    /** 自己发起屏幕共享失败（iOS 暂不支持发起屏幕共享）*/
    ScreenShareFailed,
    /** 有成员发起屏幕共享 */
    ScreenShareStart,
    /** 发起的成员取消了屏幕共享 */
    ScreenShareStop,
    /** 自己修改房间主题失败 */
    TitleFailed,
    /** 房间主题被修改（自己或其他成员修改）*/
    TitleChanged,
};

/**
 *  @brief 请求视频流的分辨率
 */
typedef NS_ENUM(NSUInteger, VideoPictureSize) {
    /** 停止请求视频流 */
    VideoPictureSizeOff = 0,
    /** 160x90 */
    VideoPictureSizeMin,
    /** 320x180 */
    VideoPictureSizeSmall,
    /** 640x360 */
    VideoPictureSizeLarge,
    /** 1280x720（会议的分辨率和摄像头的分辨率必须要1280x720，一般情况这一档的分辨率也为640x360）*/
    VideoPictureSizeMax
};


/**
 *  @brief 视频流渲染的模式
 */
typedef NS_ENUM(NSUInteger, RenderMode) {
    /** 自动 */
    RenderAuto = 0,
    /** 视频图像按比例填充整个渲染区域（裁剪掉超出渲染区域的部分区域）*/
    RenderFullScreen,
    /** 视频图像的内容完全呈现到渲染区域（可能会出现黑边，类似放电影的荧幕）*/
    RenderFullContent
};


/**
 *  @brief 加入房间的模式
 */
typedef NS_ENUM(NSUInteger, JoinMode) {
    /** 视频的方式加入 */
    JoinModeVideo = 0,
    /** 音频的方式加入 */
    JoinModeAudio,
    /** relay的方式加入 */
    JoinModeViewer
};


/**
 *  @brief 摄像头采集的分辨率
 */
typedef NS_ENUM(NSUInteger, Resolution) {
    /** 160x90 */
    Resolution90 = 0,
    /** 320x180 */
    Resolution180,
    /** 640x360 */
    Resolution360,
    /** 1280x720 */
    Resolution720
};

@class JCRoomModel;
@class JCParticipantModel;

@protocol JCEngineDelegate <NSObject>
@optional


/**
 * @brief 已连接至服务器回调
 *   SDK 与服务器发起业务交互前，需要与服务器建立连接。开发者可以自行调用
 *   - (int)loginWithUserId:(NSString *)userId password:(NSString *)password
 *   来与服务器建立连接。也可以仅调用功能操作，如 - (int)joinWithRoomId:(NSString *)roomId
 *   displayName:(NSString *)displayName，SDK 会自动与服务器建立连接。
 */
- (void)onConnected;


/**
 * @brief 与服务器连接断开回调
 *   已于服务器断开连接。开发者可以调用 - (int)logout 断开与服务器的连接。操作成功后 SDK 会触发此回调。
 *   当相同的 userId 在另一台设备登录时，SDK 也会触发此回调。
 *
 * @param  errorReason 具体原因值 @ref ErrorReason
 */
- (void)onDisConnected:(ErrorReason)eventReason;


/**
 * @brief 重连回调
 *   当网络发生异常或切换时，SDK 可能会与服务器连接断开，此时 SDK 会自动发起重连，并触发此回调。 开发者可以利用这个回调，在界面上显示重连提示信息。若对重连信息没有需求，则忽略此回调。
 *
 */
- (void)onReconnecting;


/**
 * @brief  错误回调
 *   SDK 运行中发生错误时就会触发此互调。如调用 - (int)joinWithRoomId:(NSString *)roomId
 *   displayName:(NSString *)displayName 时操作失败等
 *
 * @param  errorReason 具体原因值 @ref ErrorReason
 */
- (void)onError:(ErrorReason)errorReason;


/**
 * @brief 加入房间成功回调
 *   开发者调用 - (int)joinWithRoomId:(NSString *)roomId
 *   displayName:(NSString *)displayName 后，若加入成功 SDK 会触发此回调。
 */
- (void)onJoinRoomSuccess;


/**
 * @brief  已离开房间回调
 *   开发者调用 - (void)leave 后，若操作成功，SDK 会触发此回调。若终端因为掉线或被管理员移除等原因离开
 *   房间，SDK 也会触发此回调。
 *
 * @param  eventReason 原因值 @ref ErrorReason
 */
- (void)onLeftRoom:(ErrorReason)eventReason;


/**
 * @brief  成员加入到房间回调
 *   当新成员加入到房间时，SDK 会触发此回调。
 *
 * @param  userId  对应的成员userId
 */
- (void)onParticipantJoin:(NSString *)userId;


/**
 * @brief  成员离开房间的回调
 *       当其他成员离开房间时，SDK 会触发此回调。
 *
 * @param  eventReason  具体事件结果和原因值 @ref EventReason
 * @param  userId  对应的成员userId
 */
- (void)onParticipantLeft:(ErrorReason)errorReason userId:(NSString *)userId;


/**
 * @brief  成员信息变更回调
 * 当成员状态、角色或者信息发生变化时，SDK 会触发此回调。
 *
 * @param  errorReason  具体事件结果和原因值 @ref EventReason
 * @param  userId  对应的成员userId
 */
- (void)onParticipantUpdated:(NSString *)userId;


/**
 * @brief  房间属性变更回调
 *   开发者调用 - (int)setCustomProperty: forKey: 后，若设置成功，SDK 会触发此回调。所有成员都会受到此回调。开发者可以调用 - (NSString *)getCustomPropertyForKey: 获取对应的属性。
 */
- (void)onRoomPropertyUpdated;

/**
 * @brief  房间标题变更回调
 *    开发者调用 - (int)changeTitle: 后，若修改成功 SDK 会触发此回调。所有成员会收到此回调。
 */
- (void)onRoomTitleUpdated;


/**
 * @brief  屏幕共享状态变更回调
 * 当有成员发起或关闭屏幕共享时，SDK 会触发此回调。
 */
- (void)onRoomSceenShareStateChanged:(ErrorReason)errorReason;


/**
 *  接收数据的回调
 *
 *  @param key 发送数据的类型
 *  @param content 发送数据的具体内容
 *  @param userId 发送者的userId
 */
- (void)onDataReceive:(NSString *)key content:(NSString *)content fromSender:(NSString *)userId;

@end


@interface JCEngineManager : NSObject

/**
 * @brief   获取JCEngineManager对象
 *
 * @return  返回JCEngineManager对象
 */
+ (JCEngineManager *)sharedManager;


/**
 *  @brief 初始化接口，初始化sdk相关。
 *  注：在调用以下接口前，请务必先完成初始化
 *
 *  @param appkey 用户在JusTalk Cloud官网申请来获取appkey
 *  @return 初始化成功返回JCOK，失败返回JCFAILED。
 */
- (int)initializeWithAppkey:(NSString *)appkey;


/**
 *  @brief 销毁接口，销毁 SDK 相关
 *
 */
- (void)destroy;


/**
 *  @brief 设置代理，用于接收登录和登出相关的事件回调函数，可设置多个不同对象的代理。
 *
 *  @param delegate 实现JCEngineDelegate协议的对象
 */
- (void)setDelegate:(id<JCEngineDelegate>)delegate;

- (void)removeDelegate:(id<JCEngineDelegate>)delegate;

/**
 *  @brief 设置是否自动登录，默认为自动。
 *
 *  @param isAuto 
 */
- (void)setAutoLogin:(BOOL)isAuto;

/**
 *  @brief 登录接口，为异步接口。
 *
 *  @param userId 用户名
 *  @param password 密码
 *
 *  @return 返回JCOK表示发起登录请求。返回JCFAILED表示没有发起登录请求，原因大致为未初始化，或当前无网络，或重复调用登录接口。
 */
- (int)loginWithUserId:(NSString *)userId password:(NSString *)password;


/**
 *  @brief 登出接口，为异步接口，登出的结果通过JCApiDelegate的回调函数来通知。当回调函数的参数JCApiState为JCApiStateInit，表示登出成功（回到初始化状态）。
 *
 *
 *  @return 返回JCOK表示发起登出请求，返回JCFAILED表示没有发起登出请求。
 */
- (int)logout;


/**
 *  @brief 判断终端当前是否已经登录
 *
 *  @return 返回YES为已登录，返回NO为未登录
 */
- (BOOL)isOnline;


/**
 *  @brief 获取终端当前的状态
 *
 *  @return 返回JCApiState的枚举值
 */
- (JCApiState)getState;


/**
 *  @brief 获取终端当前登录的userId
 *
 *  @return 返回userId的字符串
 */
- (NSString *)getOwnUserId;

/**
 *  @brief 日志提交
 *
 *  @param memo 提交日志的原因
 *  @return 提交成功返回JCOK，失败返回JCFAILED。
 */
- (int)commitLogWithMemo:(NSString *)memo;


/**
 *  @brief 设置登录服务器地址，默认为JusTalk Cloud公有云的服务器地址（公有云的用户不需要调用该接口）。
 *
 *  如有私有云的用户，则需设置私有云的服务器地址。
 *
 *  @param server 服务器地址由JusTalk Cloud分配指定
 */
- (void)setServerAddress:(NSString *)server;


/**
 *  @brief 获取当前的服务器地址
 *
 *  @return 返回服务器地址的字符串
 */
- (NSString *)getServerAddress;


/**
 * @brief  加入房间，为异步接口
 *
 * @param  roomId  房间的标识，在同一个Appkey下，多个终端设备输入同一个roomId，这些设备会加入到同一个房间中。
 * @param  displayName 自己的昵称
 *
 * @return 返回JCOK表示向服务器发起加入会议的请求，返回JCFAILED表示失败
 */
- (int)joinWithRoomId:(NSString *)roomId displayName:(NSString *)displayName;


/**
 * @brief  退出当前已加入成功的房间，为异步接口
 *
 * @return 返回JCOK表示向服务器发起退出会议的请求，返回JCFAILED表示失败
 */
- (int)leave;

/**
 *  @brief  加入房间成功后，获取房间信息
 *
 *  @return 返回JCRoomModel对象
 */
- (JCRoomModel *)getRoomInfo;


/**
 *  @brief  加入房间后，获取房间中的成员信息
 *
 *  @param  userId 成员userId
 *
 *  @return 返回JCParticipantModel对象
 */
- (JCParticipantModel *)getParticipantWithUserId:(NSString *)userId;


/**
 * @brief  开关语音，默认为关闭状态
 *
 * @param  enable YES是开启语音，NO是关闭语音
 *
 * @return 返回JCOK表示向服务器发起请求，其他表示失败
 */
- (int)enableLocalAudioStream:(BOOL)enable;


/**
 * @brief  开关视频，默认为开启状态，开启视频后能被房间中其他成员看到，为异步接口。
 *
 * @param  enable YES是开启视频,NO是关闭视频
 *
 * @return 返回JCOK表示向服务器发起请求，其他表示失败
 */
- (int)enableLocalVideoStream:(BOOL)enable;


/**
 * @brief  本地静音，静音后听不到房间中其他成员的语音，默认关闭。
 *
 * @param  enable YES是静音,NO是不静音
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)enableAudioOutput:(BOOL)enable;


/**
 * @brief  开关音频输入设备
 *
 * @param  enable YES是打开, NO是关闭
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)enableAudioInput:(BOOL)enable;

/**
 * @brief  切换扬声器和听筒模式
 *
 * @param  enable YES是扬声器, NO是听筒
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)switchSpeaker:(BOOL)speaker;

/**
 * @brief  设置是否接收音量变化的状态更新，默认 NO 不接受。
 *
 * @param  enable YES是接收, NO是不接收
 *
 */
- (void)enableVolumeNotification:(BOOL)enable;

/**
 * @brief  请求成员的视频。分别请求不同大小的分辨率，最终只显示最大分辨率的视频。
 *
 * @param  userId  成员userId
 * @param  pictureSize  视频流的分辨率 @ref VideoPictureSize
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)requestVideoWithUserId:(NSString *)userId pictureSize:(VideoPictureSize)pictureSize;

/**
 * @brief  取消成员视频的请求。
 *
 * @param  userId  成员userId
 * @param  pictureSize  视频流的分辨率 @ref VideoPictureSize
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)cancelVideoRequestWithUserId:(NSString *)userId pictureSize:(VideoPictureSize)pictureSize;


/**
 * @brief  请求屏幕共享的视频。分别请求不同大小的分辨率，最终只显示最大分辨率的视频。
 *
 * @param  pictureSize 视频流的分辨率  @ref VideoPictureSize
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)requestScreenVideoWithPictureSize:(VideoPictureSize)pictureSize;


/**
 * @brief  取消屏幕共享视的请求。
 *
 * @param  pictureSize 视频流的分辨率  @ref VideoPictureSize
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)cancelScreenVideoRequestWithPictureSize:(VideoPictureSize)pictureSize;


/**
 * @brief  修改房间主题，为异步接口
 *
 * @param title 字符串类型
 * @return 返回JCOK表示向服务器发起请求，其他表示失败
 */
- (int)changeTitle:(NSString *)title;

/**
 * @brief  设置自定义房间属性。调用此接口来设置来设置自定义房间属性。
 *
 * @param key 属性 key
 * @param value 属性值
 * @return 返回JCOK表示向服务器发起请求，其他表示失败。
 */
- (int)setCustomProperty:(NSString *)value forKey:(NSString *)key;


/**
 * @brief  获取自定义房间属性，调用此接口来获取自定义房间属性。
 *
 * @param key 属性 key
 * @return 返回JCOK表示向服务器发起请求，其他表示失败
 */
- (NSString *)getCustomPropertyForKey:(NSString *)key;



/**
 *  发送数据的接口
 *
 *  @param key 发送数据的类型，可用于区分发送的数据
 *  @param content 发送数据的具体内容
 *  @param userId 传nil则以广播的形式发送
 *
 *  @retval int JCOK表示发送成功, JCFAILED表示发送失败
 */
- (int)sendData:(NSString *)key content:(NSString *)content toReceiver:(NSString *)userId;


/**
 *  @brief  开启本地摄像头，默认打开前置摄像头。视频房间在调用加入房间接口前或后调用该接口，否则别人无法看到你的视频
 *
 *  @return 返回JCOK表示成功,其他表示失败
 */
- (int)startCamera;


/**
 *  @brief  关闭本地摄像头，如果已经打开了摄像头，会议结束前关闭摄像头
 */
- (void)stopCamera;


/**
 *  @brief  切换前后摄像头
 *
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)switchCamera;


/**
 * @brief 开始渲染视频，视频显示出来后回调completedBlock。
 *        注：渲染前必须先调用请求订阅成员视频流的接口  @ref - (int)requestVideoWithUserId:(NSString *)userId pictureSize:(VideoPictureSize)pictureSize;
 *
 * @param view    显示视频的view
 * @param userId  要视频渲染的会议成员
 * @param mode    渲染模式，@ref ZmfRenderMode
 * @param completedBlock  开始显示图像的回调
 *
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)startRender:(UIView *)view userId:(NSString *)userId mode:(RenderMode)mode completed:(JCRenderCompletionBlock)completedBlock;


/**
 * @brief 开始渲染屏幕共享的视频，视频显示出来后回调completedBlock
 *        注：渲染前必须先调用请求订阅屏幕共享视频流的接口  @ref - (int)requestScreenVideoWithPictureSize:(JCVideoPictureSize)pictureSize;
 *
 * @param view  显示视频的view
 * @param mode  渲染模式，@ref ZmfRenderMode
 * @param completedBlock  开始显示图像的回调调
 *
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)startScreenRender:(UIView *)view mode:(RenderMode)mode completed:(JCRenderCompletionBlock)completedBlock;


/**
 *  @brief 停止视频渲染，并释放资源
 *  注：会议结束时，界面必须调用该接口释放正在渲染的view
 *
 *  @param view  已经开始渲染视频的view
 *
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)stopRender:(UIView *)view;


/**
 *  @brief  设置摄像头的属性，必须在开启摄像头前调用
 *
 *  @param isFront  YES为前置摄像头，NO为后置摄像头
 *  @param resolution  摄像头采集图像的分辨率
 */
- (void)setupCapture:(BOOL)isFront resolution:(Resolution)resolution;


/**
 *  @brief  设置主持人角色
 *
 *  @param userid   成员userId
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)setRoleHostWithUserId:(NSString *)userId;


/**
 *  @brief  设置参与人数(4~16)，默认6人
 *
 *  @return 返回JCOK表示成功，其他表示失败
 */
- (int)setMaxCapacity:(NSUInteger)maxCapacity;


/**
 *  @brief  获取参与人数
 *
 *  @return 返回4~16
 */
- (NSUInteger)getMaxCapacity;


/**
 *  @brief  获取会议号
 *
 *  @return 返回一个八位数的会议号
 */
- (NSUInteger)getConfNumber;

/**
 * @brief 设置加入方式（音频、视频、relay），默认为视频
 *
 * @param mode  提供这些方式，@ref JoinMode
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)setJoinMode:(JoinMode)mode;


/**
 * @brief 获取加入方式（音频、视频、relay）
 *
 * @return 提供这些方式，@ref JoinMode
 */
- (JoinMode)getJoinMode;


/**
 * @brief 设置是否开启直播，默认关闭
 *
 * @param enbale 设置YES/NO
 */
- (void)setLiveEnable:(BOOL)enable;


/**
 * @brief 获取直播状态
 *
 * @return YES表示直播，NO表示不直播
 */
- (BOOL)getLiveEnable;


/* @brief 设置推流地址
*
* @param cdnUrl 推流地址
*/
- (void)setCdnUrl:(NSString *)cdnUrl;


/**
 * @brief 获取推流地址
 *
 */
- (NSString *)getCdnUrl;


/**
 * @brief 设置分辨率，默认Resolution360
 *
 * @param resolution 分辨率的值 @ref Resolution
 *
 * @return 返回JCOK表示成功，其他表示失败
 */
- (int)setResolution:(Resolution)resolution;


/**
 * @brief 设置默认是否打开音频发送
 *  此接口需在加入房间前调用，用于预设下次进入房间后是否默认开启音频发送。该房间退出后会被重置。
 *  默认情况下，音频发送为关闭状态。
 *
 *  @parm enable YES 表示开启发送，NO 表示不开启。
 */
- (void)setDefaultAudio:(BOOL)enable;


/**
 * @brief 设置默认是否打开视频发送
 *  此接口需在加入房间前调用，用于预设下次进入房间后是否默认开启视频发送。该房间结束后会被重置。
 *  默认情况下，视频发送为打开状态。
 *
 *  @param enable YES 表示开启发送，NO 表示不开启
 */
- (void)setDefaultVideo:(BOOL)enable;

/**
 * @brief 获取分辨率
 *
 * @return 提供这些方式，@ref Resolution
 */
- (Resolution)getResolution;

- (NSString *)getStsParticipant;

- (NSString *)getStsConfig;

- (NSString *)getStsNet;

- (NSString *)getStsTransport;

@end
