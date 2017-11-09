//
//  CGUserAttestationCollectionViewCell.m
//  CGSays
//
//  Created by zhu on 2017/3/24.
//  Copyright © 2017年 cgsyas. All rights reserved.
//

#import "CGUserAttestationCollectionViewCell.h"
#import "CGUserNameTextFieldCell.h"
#import "CGUserAttestationImageTableViewCell.h"
#import "VerificationCodeTableViewCell.h"
#import "CGUserDao.h"

@interface CGUserAttestationCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) CGHorrolEntity *entity;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *verifycodeTextField;
@property (nonatomic, strong) UITextField *legalnameTextField;
@property (nonatomic, copy) CGUserAttestationCollectionBlock block;
@end

@implementation CGUserAttestationCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = NO;
}

-(void)didSelectButtonBlock:(CGUserAttestationCollectionBlock)block{
  self.block = block;
}

-(void)update:(CGHorrolEntity *)entity{
  self.entity = entity;
  [self.tableView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  [self allResignFirst];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
  if (textField.tag == 0) {
    self.entity.entity.name = textField.text;
  }else if (textField.tag == 1){
    self.entity.entity.verifycode = textField.text;
  }else if (textField.tag == 2){
    self.entity.entity.legalname = textField.text;
  }
}

-(void)allResignFirst{
  [self.nameTextField resignFirstResponder];
  [self.verifycodeTextField resignFirstResponder];
  [self.legalnameTextField resignFirstResponder];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.entity.rolType.integerValue == 2) {
    if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
      if (indexPath.row == 1) {
        return 110;
      }
    }else{
      if (indexPath.row == 2) {
        return 110;
      }
    }
  }else{
    if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
      if (indexPath.row == 2) {
        return 110;
      }
    }else{
      if (indexPath.row == 3) {
        return 110;
      }
    }
  }
  return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.entity.rolType.integerValue == 2) {
    if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
      return 2;
    }
    return 3;
  }
  if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
    return 3;
  }
  return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([CTStringUtil stringNotBlank:[ObjectShareTool sharedInstance].currentUser.username]) {
  if (self.entity.rolType.integerValue == 2) {
      if (indexPath.row == 1) {
        static NSString*identifier = @"CGUserAttestationImageTableViewCell";
        CGUserAttestationImageTableViewCell *cell = (CGUserAttestationImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAttestationImageTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
          
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"学生证";
        [cell.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.entity.image) {
          [cell.icon setBackgroundImage:self.entity.entity.image forState:UIControlStateNormal];
        }
        return cell;
    }else if (indexPath.row == 0){
      static NSString*identifier = @"VerificationCodeTableViewCell";
      VerificationCodeTableViewCell *cell = (VerificationCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VerificationCodeTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.textField.text = self.entity.entity.verifycode;
      cell.textField.delegate = self;
      cell.textField.tag = 1;
      self.verifycodeTextField = cell.textField;
      return cell;
    }
  }else{
    if (indexPath.row == 2) {
      static NSString*identifier = @"CGUserAttestationImageTableViewCell";
      CGUserAttestationImageTableViewCell *cell = (CGUserAttestationImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAttestationImageTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        
      }
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.titleLabel.text = @"营业证";
      [cell.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
      if (self.entity.entity.image) {
        [cell.icon setBackgroundImage:self.entity.entity.image forState:UIControlStateNormal];
      }
      return cell;
    }else if(indexPath.row == 0){
      static NSString*identifier = @"CGUserNameTextFieldCell";
      CGUserNameTextFieldCell *cell = (CGUserNameTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserNameTextFieldCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.titleLabel.text = @"企业法人";
      cell.textField.placeholder = @"请输入法人名字";
      cell.textField.text = self.entity.entity.legalname;
      cell.textField.delegate = self;
      cell.textField.tag = 2;
      self.legalnameTextField = cell.textField;
      return cell;
    }else if (indexPath.row == 1){
      static NSString*identifier = @"VerificationCodeTableViewCell";
      VerificationCodeTableViewCell *cell = (VerificationCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VerificationCodeTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
      }
      cell.textField.text = self.entity.entity.verifycode;
      cell.textField.delegate = self;
      cell.textField.tag = 1;
      self.verifycodeTextField = cell.textField;
      return cell;
    }
  }
  }else{
    if (self.entity.rolType.integerValue == 2) {
      if (indexPath.row == 2) {
        static NSString*identifier = @"CGUserAttestationImageTableViewCell";
        CGUserAttestationImageTableViewCell *cell = (CGUserAttestationImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAttestationImageTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
          
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"学生证";
        [cell.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.entity.image) {
          [cell.icon setBackgroundImage:self.entity.entity.image forState:UIControlStateNormal];
        }
        return cell;
      }else if (indexPath.row == 0){
        static NSString*identifier = @"CGUserNameTextFieldCell";
        CGUserNameTextFieldCell *cell = (CGUserNameTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserNameTextFieldCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.titleLabel.text = @"姓名";
        cell.textField.placeholder = @"请输入你的名字";
        cell.textField.text = self.entity.entity.name;
        cell.textField.delegate = self;
        cell.textField.tag = 0;
        self.nameTextField = cell.textField;
        return cell;
      }else if (indexPath.row == 1){
        static NSString*identifier = @"VerificationCodeTableViewCell";
        VerificationCodeTableViewCell *cell = (VerificationCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VerificationCodeTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.textField.text = self.entity.entity.verifycode;
        cell.textField.delegate = self;
        cell.textField.tag = 1;
        self.verifycodeTextField = cell.textField;
        return cell;
      }
    }else{
      if (indexPath.row == 3) {
        static NSString*identifier = @"CGUserAttestationImageTableViewCell";
        CGUserAttestationImageTableViewCell *cell = (CGUserAttestationImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserAttestationImageTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
          
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"营业证";
        [cell.icon addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.entity.entity.image) {
          [cell.icon setBackgroundImage:self.entity.entity.image forState:UIControlStateNormal];
        }
        return cell;
      }else if(indexPath.row == 0){
        static NSString*identifier = @"CGUserNameTextFieldCell";
        CGUserNameTextFieldCell *cell = (CGUserNameTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserNameTextFieldCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.titleLabel.text = @"姓名";
        cell.textField.placeholder = @"请输入你的名字";
        cell.textField.text = self.entity.entity.name;
        cell.textField.delegate = self;
        cell.textField.tag = 0;
        self.nameTextField = cell.textField;
        return cell;
      }else if (indexPath.row == 1){
        static NSString*identifier = @"CGUserNameTextFieldCell";
        CGUserNameTextFieldCell *cell = (CGUserNameTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CGUserNameTextFieldCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.titleLabel.text = @"企业法人";
        cell.textField.placeholder = @"请输入法人名字";
        cell.textField.text = self.entity.entity.legalname;
        cell.textField.delegate = self;
        cell.textField.tag = 2;
        self.legalnameTextField = cell.textField;
        return cell;
      }else if (indexPath.row == 2){
        static NSString*identifier = @"VerificationCodeTableViewCell";
        VerificationCodeTableViewCell *cell = (VerificationCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
          NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VerificationCodeTableViewCell" owner:self options:nil];
          cell = [array objectAtIndex:0];
        }
        cell.textField.text = self.entity.entity.verifycode;
        cell.textField.delegate = self;
        cell.textField.tag = 1;
        self.verifycodeTextField  = cell.textField;
        return cell;
      }
    }
  }

  return nil;
}

-(void)iconClick:(UIButton *)sender{
  self.block(sender);
}
@end
