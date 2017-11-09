//
//  HeadlineBiz.m
//  CGSays
//
//  Created by mochenyang on 2016/9/28.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "HeadlineBiz.h"
#import "CGHorrolEntity.h"
#import "CGInfoHeadEntity.h"
#import "HeadLineDao.h"
#import "CGCommentEntity.h"
#import "CGSearchSourceCircleEntity.h"
#import "CGSearchKeyWordEntity.h"

@implementation HeadlineBiz

//查询大类

//查询头条列表
-(void)queryRemoteHeadlineDataByLabel:(NSString *)label time:(long)time mode:(int)mode success:(void(^)(NSMutableArray *bigTypeData))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:label,@"label",[NSNumber numberWithLong:time],@"time",[NSNumber numberWithInt:mode],@"mode", nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_LIST param:param success:^(id data) {
        [CGInfoHeadEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"relevantInfoList" : @"CGRelevantInformationEntity",
                     };
        }];
        NSArray *headlineArray = data;
        NSMutableArray *result = [NSMutableArray array];
        long startTime = mode == 0 ? [[NSDate date] timeIntervalSince1970]*1000 : time;
        CGInfoHeadEntity *info;
        for(NSDictionary *dict in headlineArray){
            info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
            if(mode == 0){
                startTime -= 1;
            }else if (mode == 1){
                startTime += 1;
            }
            info.bigtype = label;
            info.localtime = startTime;
            if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                info.imglistJson = json;
            }
            
            if (info.relevant && ![info.relevant isKindOfClass:[NSNull class]] && info.relevant.count > 0) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict[@"relevantInfoList"] options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                info.relevantJson = json;
            }
            info.read = 0;
            
            [result addObject:info];
        }
        
        [[[HeadLineDao alloc]init]saveInfoDataToDB:result];
        success(result);
    } fail:^(NSError *error){
        fail(error);
    }];
}

//查询资讯详情
-(void)queryRemoteInfoDetailById:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGInfoDetailEntity *infoDetail))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"id",[NSNumber numberWithUnsignedInteger:type],@"type", nil];
  [CGInfoDetailEntity mj_setupObjectClassInArray:^NSDictionary *{
    return @{
             @"appList" : @"CGAppListEntity",
             };
  }];
    [self.component sendPostRequestWithURL:URL_HEADLINE_INFO_DETAIL param:param success:^(id data) {
        CGInfoDetailEntity *detail = [CGInfoDetailEntity mj_objectWithKeyValues:data];
        if ([CTStringUtil stringNotBlank:detail.html]) {
            detail.html = [CTStringUtil clearHtmlImgWithAndHeight:detail.html];//剔除图片标签的高和宽的约束
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[HeadLineDao alloc]init]saveInfoDetailToDB:detail];//保存详情到本地
        });
        success(detail);
    }fail:^(NSError *error){
        fail(error);
    }];
}

//查询详情状态
-(void)queryInfoDetailStateById:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGTopicEntity *detailState))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"id",[NSNumber numberWithUnsignedInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_INFO_DETAIL_STATE param:param success:^(id data) {
        CGTopicEntity *state = [CGTopicEntity mj_objectWithKeyValues:data];
        state.jing = 98;
        success(state);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//关闭不感兴趣的内容
-(void)closeInfoWithId:(NSString *)infoId type:(int)type closeType:(int)closeType success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"id",[NSNumber numberWithInt:type],@"type",[NSNumber numberWithInt:closeType],@"closeType", nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_CLOSE param:param success:^(id data) {
        success();
    } fail:^(NSError *error){
        fail(error);
    }];
}

//发表话题评论接口
-(void)postTopicCommentWithContent:(NSString *)content infoId:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGCommentEntity *coment))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"infoId",content,@"content",[NSNumber numberWithInteger:type],@"type", nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_TOPIC_ADDCOMMENT param:param success:^(id data) {
        CGCommentEntity *comment = [CGCommentEntity mj_objectWithKeyValues:data];
        comment.infoId = infoId;
        if([CTStringUtil stringNotBlank:comment.commentId]){
            success(comment);
        }else{
            success(nil);
        }
        
    } fail:^(NSError *error){
        fail(error);
    }];
}

//话题讨论回复接口
-(void)postCommentToCommentWithParentComment:(CGCommentEntity *)parentComment toComment:(CGCommentEntity *)toComment content:(NSString *)content type:(NSInteger)type success:(void(^)(CGCommentEntity *comment))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:parentComment.infoId,@"infoId",content,@"content",[NSNumber numberWithInteger:type],@"type",parentComment.commentId,@"commentId",toComment?toComment.uid:nil,@"toUid",toComment?toComment.commentId:nil,@"toCommentId", nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_COMMENT_REPLY param:param success:^(id data) {
        CGCommentEntity *comment = [CGCommentEntity mj_objectWithKeyValues:data];
        comment.infoId = parentComment.infoId;
        //        comment.topicId = parentComment.topicId;
        
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

//更新大类排序
-(void)updateHeadlineBigtypeSortWithArray:(NSMutableArray *)array success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:array,@"data",[NSNumber numberWithInt:12],@"type",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_NAV_UPDATE param:param success:^(id data) {
        NSArray *bigTypeArray = data;
        NSMutableArray *result = [NSMutableArray array];
        CGHorrolEntity *entity;
        for(int i=0;i<bigTypeArray.count;i++){
            NSDictionary *dict = bigTypeArray[i];
            entity = [[CGHorrolEntity alloc]initWithRolId:[dict objectForKey:@"typeId"] rolName:[dict objectForKey:@"typeName"] sort:i];
            [result addObject:entity];
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//收藏/取消收藏接口 collect:1收藏 0取消收藏
-(void)collectWithId:(NSString *)infoId type:(int)type collect:(int)collect success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"id",[NSNumber numberWithInt:type],@"type",nil];
    NSString *url = collect == 0 ? URL_HEADLINE_UNCOLLECT : URL_HEADLINE_COLLECT;
    [self.component sendPostRequestWithURL:url param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//用户分享获取连接接口
-(void)userShareGetUrlWithUrl:(NSString *)url success:(void(^)(NSString *url))success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",nil];
  [self.component sendPostRequestWithURL:URL_USER_SHARE_URL param:param success:^(id data) {
    NSDictionary *dic = data;
    NSString *url = dic[@"url"];
    success(url);
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//获取资讯话题列表
-(void)queryHeadlineTopicListWithInfoId:(NSString *)infoId mode:(int)mode type:(NSInteger)type time:(long)time success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mode],@"mode",[NSNumber numberWithLong:time],@"time",infoId,@"infoId",[NSNumber numberWithInteger:type],@"type",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_TOPIC_LIST param:param success:^(id data) {
        NSMutableArray *result = [NSMutableArray array];
        NSMutableArray *array = data;
        if(array && array.count > 0){
            CGCommentEntity *comment;
            for(NSDictionary *dict in array){
                comment = [CGCommentEntity mj_objectWithKeyValues:dict];
                comment.infoId = infoId;
                [result addObject:comment];
            }
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//获取话题回复列表
-(void)queryHeadlineTopicReplyListWithCommentId:(NSString *)commentId mode:(int)mode time:(long)time success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"commentId",[NSNumber numberWithInt:mode],@"mode",[NSNumber numberWithLong:time],@"time",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_TOPIC_REPLY_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        if(array && array.count > 0){
            NSMutableArray *result = [NSMutableArray array];
            CGCommentEntity *comment;
            for(NSDictionary *dict in array){
                comment = [CGCommentEntity mj_objectWithKeyValues:dict];
                [result addObject:comment];
            }
            success(result);
        }else{
            fail(nil);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//话题讨论点赞接口
-(void)topicCommentPraiseWithInfoId:(NSString *)infoId commentId:(NSString *)commentId type:(NSInteger)type success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"infoId",commentId,@"commentId",[NSNumber numberWithInteger:type],@"type",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_TOPIC_PRAISE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//根据话题id删除话题
-(void)delTopicById:(NSString *)topicId success:(void(^)(void))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:topicId,@"topicId",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_TOPIC_DELETE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//全局搜索
- (void)commonSearchWithKeyword:(NSString *)keyword pageNo:(NSInteger)pageNo type:(NSInteger)type action:(NSString *)action ID:(NSString *)ID subType:(NSString *)subType success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:pageNo],@"pageNo",[NSNumber numberWithInteger:type],@"type",nil];
    if (action.length>0) {
        [param setObject:action forKey:@"action"];
    }
    
    if (subType.length>0) {
        [param setObject:subType forKey:@"subType"];
    }
    
    if (ID.length>0) {
        [param setObject:ID forKey:@"id"];
    }
    
    [self.component sendPostRequestWithURL:URL_COMMON_SEARCH param:param success:^(id data) {
        if (type == 16) {
            [CGSearchSourceCircleEntity mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"imglist" : @"SearchSourceCircImgList",
                         };
            }];
            NSMutableArray *array = data;
            CGSearchSourceCircleEntity *comment;
            NSMutableArray *result = [NSMutableArray array];
            for(NSDictionary *dict in array){
                comment = [CGSearchSourceCircleEntity mj_objectWithKeyValues:dict];
                comment.createTime = [dict[@"createtime"] integerValue];
                [result addObject:comment];
            }
            success(result);
        }else{
            NSArray *headlineArray = data;
            NSMutableArray *result = [NSMutableArray array];
            CGInfoHeadEntity *info;
            for(NSDictionary *dict in headlineArray){
                info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
              if (info.width<=0) {
                info.width = SCREEN_WIDTH/2;
              }
              if (info.height<=0) {
                info.height = 300;
              }
              info.cover = [info.cover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    info.imglistJson = json;
                }
                [result addObject:info];
            }
            success(result);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//头条知识搜索接口
- (void)commonSearchInfoWithKeyword:(NSString *)keyword pageNo:(NSInteger)pageNo level:(NSInteger)level action:(NSInteger)action ID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:pageNo],@"pageNo",[NSNumber numberWithInteger:action],@"action",[NSNumber numberWithInteger:level],@"level",nil];
    if ([CTStringUtil stringNotBlank:ID]) {
        [param setObject:ID forKey:@"id"];
    }
    
    [self.component sendPostRequestWithURL:URL_COMMON_SEARCH_INFO param:param success:^(id data) {
        NSArray *headlineArray = data;
        NSMutableArray *result = [NSMutableArray array];
        CGInfoHeadEntity *info;
        for(NSDictionary *dict in headlineArray){
            info = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
            if(info.imglist && ![info.imglist isKindOfClass:[NSNull class]] && info.imglist.count > 0){
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info.imglist options:NSJSONWritingPrettyPrinted error:nil];
                NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                info.imglistJson = json;
            }
            [result addObject:info];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//竞品主题搜索关键字
- (void)discoverSubjectSearchKeyword:(NSString *)keyword ID:(NSString *)ID success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",ID,@"id",nil];
    [self.component sendPostRequestWithURL:URL_KEYWORD_SEARCH param:param success:^(id data) {
        NSMutableArray *result = data;
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *dict in result){
            CGSearchKeyWordEntity *info = [CGSearchKeyWordEntity mj_objectWithKeyValues:dict];
            [array addObject:info];
        }
        success(array);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//查询百度关键字
- (void)jpSearchWithKeyword:(NSString *)keyword success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",nil];
    [self.component sendPostRequestWithURL:URL_JP_SEARCH param:param success:^(id data) {
        NSMutableArray *result = data;
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//分类校正接口
- (void)headlinesCorrectingNavTypeWithID:(NSString *)consultingID navType:(NSString *)navType success:(void(^)())success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:consultingID,@"id",navType,@"navType",nil];
    [self.component sendPostRequestWithURL:URL_CORRECTING_NAVTYPE param:param success:^(id data) {
        success();
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//资讯类详情大数据
-(void)headlinesDetailsBigdataWithID:(NSString *)infoId type:(NSInteger)type success:(void(^)(CGBigdataEntity *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:infoId,@"id",[NSNumber numberWithInteger:type],@"type",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_DETAIL_BIGDATA param:param success:^(id data) {
        [CGInfoHeadEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"relevantInfoList" : @"CGRelevantInformationEntity",
                     };
        }];
        [CGBigdataEntity mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"cateList" : @"cate",
                     };
        }];
        NSDictionary *dic = data;
        CGBigdataEntity *comment = [CGBigdataEntity mj_objectWithKeyValues:dic];
        NSMutableArray *array = dic[@"dataList"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSArray *array1 in array) {
            NSMutableArray *array3 = [NSMutableArray array];
            for (NSDictionary *dict in array1) {
                CGInfoHeadEntity *entity = [CGInfoHeadEntity mj_objectWithKeyValues:dict];
                [array3 addObject:entity];
            }
            [dataList addObject:array3];
        }
        comment.dataList = dataList;
        success(comment);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//头条首页热搜数据接口
- (void)headlinesHotsearchListWithPage:(NSInteger)page action:(NSInteger)action type:(NSInteger)type success:(void(^)(NSMutableArray *result))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:page],@"page",[NSNumber numberWithInteger:type],@"type",[NSNumber numberWithInteger:action],@"action",nil];
    [self.component sendPostRequestWithURL:URL_HEADLINE_HOTSEARCH_LIST param:param success:^(id data) {
        NSMutableArray *array = data;
        CGHotSearchEntity *comment;
        NSMutableArray *result = [NSMutableArray array];
        for(NSDictionary *dict in array){
            comment = [CGHotSearchEntity mj_objectWithKeyValues:dict];
            [result addObject:comment];
        }
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//资讯详情状态接口
-(void)headlinesInfoDetailStateWithID:(NSString *)ID type:(NSInteger)type success:(void(^)(NSInteger isFollow,NSInteger commentCount))success fail:(void (^)(NSError *error))fail{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",ID,@"id",nil];
    [self.component sendPostRequestWithURL:URL_INFO_DETAIL_STATE param:param success:^(id data) {
        NSDictionary *dic = data;
        NSString *isFollow = dic[@"isFollow"];
        NSString *commentCount = dic[@"commentCount"];
        success(isFollow.integerValue,commentCount.integerValue);
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//详情积分购买报告
-(void)headlinesInfoDetailsIntegralPurchaseWithType:(NSInteger)type ID:(NSString *)ID integral:(NSInteger)integral success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type],@"type",ID,@"id",[NSNumber numberWithInteger:integral],@"integral",nil];
  [self.component sendPostRequestWithURL:URL_HEADLINES_INFO_DETAILS_INTEGRAL param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//评论删除接口
-(void)authHeadlinesTopicCommentDeleteWithCommentId:(NSString *)commentId success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"commentId",nil];
  [self.component sendPostRequestWithURL:URL_HEADLINES_TOPIC_COMMENT_DELETE param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//校正管理
-(void)headlinesManagerUpdateByAdminWithInfoId:(NSString *)infoId time:(NSInteger)time title:(NSString *)title navtype:(NSString *)navtype navtype2:(NSString *)navtype2 choice:(NSInteger )choice state:(NSInteger)state success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:choice],@"choice",[NSNumber numberWithInteger:state],@"state",infoId,@"infoId", nil];
  if ([CTStringUtil stringNotBlank:navtype]) {
    [param setObject:navtype forKey:@"navtype"];
  }
  if ([CTStringUtil stringNotBlank:navtype2]) {
    [param setObject:navtype2 forKey:@"navtype2"];
  }
  if (time>0) {
    [param setObject:[NSNumber numberWithInteger:time] forKey:@"time"];
  }
  if ([CTStringUtil stringNotBlank:title]) {
    [param setObject:title forKey:@"title"];
  }
  [self.component sendPostRequestWithURL:URL_HEADLINES_MANAGER_UPDATEBYADMIN param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//素材校正
-(void)interfaceManagerUpdateByAdminWithID:(NSString *)ID title:(NSString *)title tagId:(NSString *)tagId state:(NSInteger)state success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:state],@"state",ID,@"id", nil];
  if ([CTStringUtil stringNotBlank:title]) {
    [param setObject:title forKey:@"title"];
  }
  if ([CTStringUtil stringNotBlank:tagId]) {
    [param setObject:tagId forKey:@"tagId"];
  }
  [self.component sendPostRequestWithURL:URL_INTERFACE_MANAGER_UPDATEBYADMIN param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//文库校正
-(void)kengpoManagerUpdateByAdminWithID:(NSString *)ID title:(NSString *)title tagId:(NSString *)tagId choice:(NSInteger)choice state:(NSInteger)state time:(NSInteger)time success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:choice],@"choice",[NSNumber numberWithInteger:state],@"state",ID,@"id", nil];
  if ([CTStringUtil stringNotBlank:title]) {
    [param setObject:title forKey:@"title"];
  }
  if ([CTStringUtil stringNotBlank:tagId]) {
    [param setObject:tagId forKey:@"tagid"];
  }
  if (time>0) {
    [param setObject:[NSNumber numberWithInteger:time] forKey:@"time"];
  }
  [self.component sendPostRequestWithURL:URL_KENGPO_MANAGER_UPDATEBYADMIN param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}

//采集接口
-(void)toutiaoSpiderWithurl:(NSString *)url channel:(NSInteger)channel navtype:(NSString *)navtype navtype2:(NSString *)navtype2 selected:(NSInteger)selected success:(void(^)())success fail:(void (^)(NSError *error))fail{
  NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",[NSNumber numberWithInteger:channel],@"channel",navtype,@"navtype",navtype2,@"navtype2",[NSNumber numberWithInteger:selected],@"selected", nil];
  [self.component sendPostRequestWithURL:URL_TOUTIAO_SPIDER param:param success:^(id data) {
    success();
  } fail:^(NSError *error) {
    fail(error);
  }];
}
@end
