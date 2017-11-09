//
//  CGUserStatistics.m
//  CGSays
//
//  Created by mochenyang on 2016/10/11.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGUserStatistics.h"

@implementation CGUserStatistics

//归档的实现
//MJCodingImplementation

-(void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:[NSNumber numberWithInt:self.integralNum]      forKey:@"integralNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.subjectNum]      forKey:@"subjectNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.subscribeNum]      forKey:@"subscribeNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.advicesNum]      forKey:@"advicesNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.shareNum]      forKey:@"shareNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.fansNum]      forKey:@"fansNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.expNum]      forKey:@"expNum"];
  [aCoder encodeObject:[NSNumber numberWithInt:self.browseNum]      forKey:@"browseNum"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if((self = [super init])) {
    self.integralNum       = [[aDecoder decodeObjectForKey:@"integralNum"] intValue];
    self.subjectNum       = [[aDecoder decodeObjectForKey:@"subjectNum"] intValue];
    self.subscribeNum       = [[aDecoder decodeObjectForKey:@"subscribeNum"] intValue];
    self.advicesNum       = [[aDecoder decodeObjectForKey:@"advicesNum"] intValue];
    self.shareNum       = [[aDecoder decodeObjectForKey:@"shareNum"] intValue];
    self.fansNum       = [[aDecoder decodeObjectForKey:@"fansNum"] intValue];
    self.expNum       = [[aDecoder decodeObjectForKey:@"expNum"] intValue];
    self.browseNum       = [[aDecoder decodeObjectForKey:@"browseNum"] intValue];
  }
  
  return self;
}

@end
