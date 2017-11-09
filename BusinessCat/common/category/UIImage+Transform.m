//
//  UIImage+Transform.m
//  CGSays
//
//  Created by mochenyang on 2016/11/4.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "UIImage+Transform.h"

@implementation UIImage (Transform)

-(NSData *)toData{
    return UIImageJPEGRepresentation(self, 0.6);
}

@end
