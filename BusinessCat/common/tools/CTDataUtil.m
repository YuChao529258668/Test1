//
//  DataUtil.m
//  CSALeaningSys
//
//  Created by Calon Mo on 15-5-12.
//
//

#import "CTDataUtil.h"

@implementation CTDataUtil

/** 流量换算 */
+(NSString *)transDataWithFlowLong:(double)longData{
    NSString *returnValue = @"";
    if(longData >= 1024){
        double kb = longData / 1024;
        if(kb >= 1024){
            double mb = kb / 1024;
            if(mb >= 1024){
                double gb = mb / 1024;
                returnValue = [NSString stringWithFormat:@"%.2fGB",gb];
            }else{
                returnValue = [NSString stringWithFormat:@"%.2fMB",mb];
            }
        }else{
            returnValue = [NSString stringWithFormat:@"%.2fKB",kb];
        }
    }else{
        returnValue = [NSString stringWithFormat:@"%.0fB",longData];
    }
    return returnValue;
}

+ (NSString *)uuidString{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

@end
