//
//  CTJsonUtil.m
//  VieProd
//
//  Created by Calon Mo on 16/3/21.
//  Copyright © 2016年 VieProd. All rights reserved.
//

#import "CTJsonUtil.h"

@implementation CTJsonUtil

//字典转json
+(NSString *)jsonFromDictionary:(NSDictionary *)dictionary{
    if(!dictionary)return nil;
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//字符串转字典
+(NSDictionary *)dictFromJson:(NSString *)jsonString{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//对象转json
+(NSString *)objectToJson:(id)theObject{
    NSString *className = NSStringFromClass([theObject class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
    for (i = 0; i < outCount; i++){
        objc_property_t property = properties[i];
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyNames addObject:propertyNameString];
    }
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    for(NSString *key in propertyNames){
        id value = [theObject valueForKey:key];//这是修改过的
        if (value == nil){
            value = [NSNull null];
        }
        [finalDict setObject:value forKey:key];
    }
    NSString *retString = [CTJsonUtil jsonFromDictionary:finalDict];
    return retString;
}


+(NSDictionary*)getObjectData:(id)obj{
    NSMutableDictionary
    *dic = [NSMutableDictionary dictionary];
    unsigned
    int propsCount;
    objc_property_t
    *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++){
        objc_property_t
        prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil){
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+(id)getObjectInternal:(id)obj{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
@end
