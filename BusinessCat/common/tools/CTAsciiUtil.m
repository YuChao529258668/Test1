//
//  CTAsciiUtil.m
//  CSALeaningSys
//
//  Created by Calon Mo on 16/2/27.
//
//

#import "CTAsciiUtil.h"

@implementation CTAsciiUtil

+(NSString *)numberToLetter:(int)number{
    char c = number + 65;
    return [NSString stringWithFormat:@"%c",c];
}

@end
