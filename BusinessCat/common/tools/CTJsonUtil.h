//
//  CTJsonUtil.h
//  VieProd
//
//  Created by Calon Mo on 16/3/21.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface CTJsonUtil : NSObject

//字典转json
+(NSString *)jsonFromDictionary:(NSDictionary *)dictionary;

//字符串转字典
+(NSDictionary *)dictFromJson:(NSString *)jsonString;

//对象转json
+(NSString *)objectToJson:(id)theObject;

@end
