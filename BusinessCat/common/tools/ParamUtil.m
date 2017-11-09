//
//  ParamUtil.m
//  CSALeaningSys
//
//  Created by Calon Mo on 15-6-30.
//
//

#import "ParamUtil.h"

@implementation ParamUtil

+(NSString *)dictionaryToParamString:(NSDictionary *)dictionary{
    NSMutableString *result = [[NSMutableString alloc]init];
    NSArray *keys = [dictionary allKeys];
    for(int i=0;i<[keys count];i++){
        NSString *key = [keys objectAtIndex:i];
        [result appendString:key];
        [result appendString:@"="];
        [result appendFormat:@"%@",[dictionary valueForKey:key]];
        
        if(i!= keys.count-1) [result appendString:@"&"];
    }
    return result;
}

@end
