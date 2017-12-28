//
//  ParamUtil.h
//  CSALeaningSys
//
//  Created by Calon Mo on 15-6-30.
//
//

#import <Foundation/Foundation.h>

@interface ParamUtil : NSObject

/**
 *  把字典转a=x&b=x&c=x...
 */
+(NSString *)dictionaryToParamString:(NSDictionary *)dictionary;

@end
