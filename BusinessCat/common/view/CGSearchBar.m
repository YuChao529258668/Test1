//
//  CGSearchBar.m
//  CGSays
//
//  Created by mochenyang on 2017/3/29.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGSearchBar.h"

@interface CGSearchBar(){
    
}

@property(nonatomic,copy)CGSearchBarBlock block;
@property(nonatomic,copy)CGSearchBarCalncel cancel;

@end

@implementation CGSearchBar

-(instancetype)initWithFrame:(CGRect)frame block:(CGSearchBarBlock)block cancel:(CGSearchBarCalncel)cancel{
    self = [super initWithFrame:frame];
    if(self){
        self.block = block;
        self.cancel = cancel;
        self.delegate = self;
        self.backgroundImage = [CTCommonUtil generateImageWithColor:CTCommonViewControllerBg size:CGSizeMake(1, 1)];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(self.block){
        self.block(searchBar.text);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(self.cancel){
        self.cancel();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
