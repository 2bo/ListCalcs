//
//  CalcTableViewCell.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2013/11/26.
//  Copyright (c) 2013年 Kota_Nakatsubo. All rights reserved.
//

#import "CalcTableViewCell.h"
#import "CalcModel.h"

@implementation CalcTableViewCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIImageView* cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
    UIImageView* selectedCellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_cell.png"]];
    self.backgroundView = cellImage;
    self.selectedBackgroundView = selectedCellImage;

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    UIImageView* cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
    UIImageView* selectedCellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_cell.png"]];
    self.backgroundView = cellImage;
    self.selectedBackgroundView = selectedCellImage;
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //memo無効時
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"isMemoSwitchOn"]){
        self.memoTextField.enabled = YES;
        self.memoTextField.placeholder = @"memo";
        self.memoTextField.textColor = [UIColor blackColor];
    }else{
        self.memoTextField.enabled = NO;
        self.memoTextField.placeholder = nil;
        self.memoTextField.textColor =  [UIColor clearColor];
    }
    
}

- (void)setCellInfo:(CalcModel *)calcModel {
	
    self.numberLabel.text = [calcModel requestDisplayString];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"isMemoSwitchOn"]){
        self.memoTextField.text = calcModel.memo;
    }

    UIImage *operatorImage;
    switch ([calcModel requestDisplayOperator]) {
        case OperatorAddition:
            operatorImage = [UIImage imageNamed:@"Add_icon.png"];
            [self.operatorImageView setImage:operatorImage];
            break;
        case OperatorSubtraction:
            operatorImage = [UIImage imageNamed:@"Sub_icon.png"];
            [self.operatorImageView setImage:operatorImage];
            break;
        case OperatorMultiplication:
            operatorImage = [UIImage imageNamed:@"Mul_icon.png"];
            [self.operatorImageView setImage:operatorImage];
            break;
        case OperatorDivision:
            operatorImage = [UIImage imageNamed:@"Div_icon.png"];
            [self.operatorImageView setImage:operatorImage];
            break;
        case OperatorNone:
            self.operatorImageView.image = nil;
            break;
        default:
            self.operatorImageView.image = nil;
            break;
    }
    
}

- (void)setCellinfoNone{
    self.numberLabel.textColor = [UIColor clearColor];
    self.memoTextField.textColor =  [UIColor clearColor];
    self.memoTextField.placeholder = nil;

    self.backgroundView = nil;
    UIView *view = [[UIView alloc]initWithFrame:self.frame];
    //TableViewと同じ背景色に設定
    view.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.0];
    self.backgroundView = view;
    self.selectedBackgroundView = nil;
}

- (void)setCellDefault{
    
    self.numberLabel.textColor = [UIColor blackColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"isMemoSwitchOn"]){
        self.memoTextField.textColor = [UIColor blackColor];
        self.memoTextField.enabled = YES;
        self.memoTextField.placeholder = @"memo";
    }else{
        self.memoTextField.textColor = [UIColor clearColor];
        self.memoTextField.enabled = NO;
        self.memoTextField.placeholder = nil;
    }
   
    UIImageView* cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
    UIImageView* selectedCellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_cell.png"]];
    self.backgroundView = cellImage;
    self.selectedBackgroundView = selectedCellImage;
}



@end
