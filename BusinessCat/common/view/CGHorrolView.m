//
//  CGHorrolView.m
//  CGSays
//
//  Created by mochenyang on 2016/9/26.
//  Copyright © 2016年 cgsyas. All rights reserved.
//

#import "CGHorrolView.h"

@interface CGHorrolView(){
    CGHorrolViewBlock block;
}


@property(nonatomic,retain)NSMutableArray *buttonArray;

@property(nonatomic,retain)UIView *line;

@property(nonatomic,retain)UIView *selectLine;

@property (nonatomic, strong) UIButton *lastItemBtn;

@property (nonatomic, assign) BOOL ischange;

@end

@implementation CGHorrolView

-(UIView *)selectLine{
    if(!_selectLine){
        _selectLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollview.frame.size.height-2, 0, 2)];
//        _selectLine.backgroundColor = CTThemeMainColor;
        _selectLine.backgroundColor = [UIColor blackColor];
    }
    return _selectLine;
}

-(NSMutableArray *)buttonArray{
    if(!_buttonArray){
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(instancetype)initWithFrame:(CGRect)frame array:(NSMutableArray *)array finish:(CGHorrolViewBlock)finish{
    self = [super initWithFrame:frame];
    if(self){
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationDiscoverHasLastData:) name:NotificationDiscoverHasLastData object:nil];
        self.backgroundColor = CTCommonViewControllerBg;
        block = finish;
        self.array = array;
        self.scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:self.scrollview];
        [self.scrollview setShowsHorizontalScrollIndicator:NO];
        [self.buttonArray removeAllObjects];
        UIButton *itemBtn;
        UIButton *firstBtn;
        self.ischange = YES;
        for(int i=0;i<self.array.count;i++){
            CGHorrolEntity *entity = self.array[i];
            itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(itemBtn.frame)+20, 0, 0, 40)];
            itemBtn.tag = i;
            itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [itemBtn setTitle:entity.rolName forState:UIControlStateNormal];
            [itemBtn sizeToFit];
            [itemBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            [itemBtn setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
            [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [itemBtn setFrame:CGRectMake(itemBtn.frame.origin.x, 0, itemBtn.frame.size.width, self.frame.size.height)];
            [self.scrollview addSubview:itemBtn];
            [self.buttonArray addObject:itemBtn];
            [itemBtn addTarget:self action:@selector(bigTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if(i == 0){
                itemBtn.selected = YES;
                firstBtn = itemBtn;
            }
            NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName ,nil];
            CGSize titleSize = [entity.rolName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            if (titleSize.width>frame.size.width/self.array.count) {
                self.ischange = NO;
            }
        }
        self.lastItemBtn = itemBtn;
        
        if (CGRectGetMaxX(itemBtn.frame)+20<frame.size.width&&self.ischange == YES) {
            for (UIView *view  in self.scrollview.subviews) {
                [view removeFromSuperview];
            }
            self.buttonArray = [NSMutableArray array];
            for(int i=0;i<self.array.count;i++){
                CGHorrolEntity *entity = self.array[i];
                itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/self.array.count*i, 0, frame.size.width/self.array.count, 40)];
                itemBtn.tag = i;
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [itemBtn setTitle:entity.rolName forState:UIControlStateNormal];
                [itemBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//                [itemBtn setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
                [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
                [self.scrollview addSubview:itemBtn];
                [self.buttonArray addObject:itemBtn];
                [itemBtn addTarget:self action:@selector(bigTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                if(i == 0){
                    itemBtn.selected = YES;
                    firstBtn = itemBtn;
                }
            }
            if (self.array.count>0) {
                CGHorrolEntity *entity = self.array[0];
                NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName ,nil];
                CGSize titleSize = [entity.rolName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                self.selectLine.frame = CGRectMake((firstBtn.frame.size.width-titleSize.width-10)/2, self.selectLine.frame.origin.y, titleSize.width+10, self.selectLine.frame.size.height);
            }
            [self.scrollview addSubview:self.selectLine];
        }else{
            self.selectLine.frame = CGRectMake(firstBtn.frame.origin.x, self.selectLine.frame.origin.y, firstBtn.frame.size.width, self.selectLine.frame.size.height);
            [self.scrollview addSubview:self.selectLine];
            self.scrollview.contentSize = CGSizeMake(CGRectGetMaxX(itemBtn.frame)+20, 0);
        }
        
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5f, frame.size.width, 0.5f)];
        self.line.backgroundColor = CTCommonLineBg;
        [self addSubview:self.line];
    }
    return self;
}

-(void)setButtonState:(TeamCircleLastStateEntity *)entity{
    for(TeamCircleCompanyState *state in entity.list){
//        if(state.count > 0){
            for(int i=0;i<self.array.count;i++){
                CGHorrolEntity *type = self.array[i];
                if([state.companyId isEqualToString:type.rolId] && state.companyType == [type.rolType intValue]){
                    for(UIButton *button in self.scrollview.subviews){
                        if(button.tag == i && [button isKindOfClass:[UIButton class]] && !button.selected){
                            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                        }
                    }
                }
            }
//        }
    }
}

-(void)notificationDiscoverHasLastDataWith:(TeamCircleLastStateEntity *)entity{
  [self setButtonState:entity];
}
//-(void)notificationDiscoverHasLastData:(NSNotification *)notification{
//    TeamCircleLastStateEntity *entity = notification.object;
//    [self setButtonState:entity];
//}

-(void)bigTypeBtnAction:(UIButton *)button{
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [button setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    int tag = (int)button.tag;
    UIButton *itemBtn = self.buttonArray[tag];
    if(block){
        block(tag,self.array[tag],itemBtn.selected);
    }
    if(!itemBtn.selected){
        [self setSelectIndex:tag];
    }
}


-(void)setSelectIndex:(int)index{
    __weak typeof(self) weakSelf = self;
    if (CGRectGetMaxX(self.lastItemBtn.frame)+20<self.frame.size.width&&self.ischange == YES) {
        UIButton *selectBtn;
        for(int i=0;i<self.buttonArray.count;i++){
            UIButton *itemBtn = self.buttonArray[i];
            if(i == index){
                selectBtn = itemBtn;
                itemBtn.selected = YES;
                CGHorrolEntity *entity = self.array[index];
                NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName ,nil];
                CGSize titleSize = [entity.rolName boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.selectLine.frame = CGRectMake((itemBtn.frame.size.width-titleSize.width-10)/2+i*itemBtn.frame.size.width, weakSelf.selectLine.frame.origin.y, titleSize.width+10, weakSelf.selectLine.frame.size.height);
                }];
            }else{
                itemBtn.selected = NO;
            }
        }
    }else{
        UIButton *selectBtn;
        for(int i=0;i<self.buttonArray.count;i++){
            UIButton *itemBtn = self.buttonArray[i];
            if(i == index){
                selectBtn = itemBtn;
                itemBtn.selected = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.selectLine.frame = CGRectMake(itemBtn.frame.origin.x, weakSelf.selectLine.frame.origin.y, itemBtn.frame.size.width, weakSelf.selectLine.frame.size.height);
                }];
            }else{
                itemBtn.selected = NO;
            }
        }
        float selectMinX = CGRectGetMinX(selectBtn.frame);
        float selectMaxX = CGRectGetMaxX(selectBtn.frame);
        float offSet = self.scrollview.contentOffset.x;
        float width = self.frame.size.width;
        [UIView animateWithDuration:0.3 animations:^{
            if(offSet >= selectMinX){
                if(index >= 1){
                    UIButton *lastBtn = weakSelf.buttonArray[index - 1];
                    weakSelf.scrollview.contentOffset = CGPointMake(CGRectGetMinX(lastBtn.frame) - 20, 0);
                }else{
                    weakSelf.scrollview.contentOffset = CGPointMake(selectMinX - 20, 0);
                }
            }else if(selectMaxX >= width - 20){
                if(index <= weakSelf.buttonArray.count - 2){
                    UIButton *nextBtn = weakSelf.buttonArray[index+1];
                    weakSelf.scrollview.contentOffset = CGPointMake(CGRectGetMaxX(nextBtn.frame)-width + 20, 0);
                }else{
                    weakSelf.scrollview.contentOffset = CGPointMake(selectMaxX - width + 20, 0);
                }
            }else{
                if(index >= 1){
                    UIButton *lastBtn = weakSelf.buttonArray[index - 1];
                    if(CGRectGetMinX(lastBtn.frame) - 20 <= offSet){
                        weakSelf.scrollview.contentOffset = CGPointMake(CGRectGetMinX(lastBtn.frame) - 20, 0);
                    }
                }else{
                    weakSelf.scrollview.contentOffset = CGPointMake(0, 0);
                }
            }
        }];
    }
}

//动态改变名字
-(void)setNameByIndex:(int)index name:(NSString *)name{
    for(int i=0;i<self.buttonArray.count;i++){
        UIButton *button = self.buttonArray[i];
        CGHorrolEntity *entity = self.array[i];
        if(button.tag == index){
            [button setTitle:name forState:UIControlStateNormal];
        }else{
            [button setTitle:entity.rolId forState:UIControlStateNormal];
        }
    }
}

-(void)insertEntity:(CGHorrolEntity *)entity{
//    [self.array insertObject:entity atIndex:0];
    UIButton *itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,0,40)];
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [itemBtn setTitle:entity.rolName forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [itemBtn setTitleColor:CTThemeMainColor forState:UIControlStateSelected];
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    [self.buttonArray insertObject:itemBtn atIndex:0];
    [self.scrollview addSubview:itemBtn];
    [self setRect];
}

-(void)replaceEntity:(CGHorrolEntity *)entity{
    [self.array replaceObjectAtIndex:0 withObject:entity];
    [self setRect];
}

-(void)setRect{
    UIButton *lastBtn = nil;
    for(int i=0;i<self.buttonArray.count;i++){
        CGHorrolEntity *entity = self.array[i];
        UIButton *itemBtn = self.buttonArray[i];
        [itemBtn setTitle:entity.rolName forState:UIControlStateNormal];
        itemBtn.tag = i;
        [itemBtn addTarget:self action:@selector(bigTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn sizeToFit];
        [itemBtn setFrame:CGRectMake(CGRectGetMaxX(lastBtn.frame)+20, 0, itemBtn.frame.size.width, self.frame.size.height)];
        lastBtn = itemBtn;
    }
    self.scrollview.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame)+20, 0);
}

@end
