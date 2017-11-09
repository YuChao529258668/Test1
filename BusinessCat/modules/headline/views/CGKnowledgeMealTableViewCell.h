//
//  CGKnowledgeMealTableViewCell.h
//  CGKnowledge
//
//  Created by zhu on 2017/5/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KnowledgeHeaderEntity.h"
#import "KnowledgeAlbumEntity.h"

@interface CGKnowledgeMealTableViewCell : UITableViewCell

-(void)updateItem:(KnowledgeHeaderEntity *)mode header:(KnowledgeAlbumEntity *)header;

@end
