//
//  CalcTableViewCell.h
//  ListCalc
//
//  Created by K.N on 2013/11/26.
//  Copyright (c) 2013年 K.N. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalcModel;

@interface CalcTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (weak, nonatomic) IBOutlet UITextField *invisibleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *operatorImageView;

- (void)setCellInfo:(CalcModel *)calcModel;
- (void)setCellinfoNone;
- (void)setCellDefault;

@end
