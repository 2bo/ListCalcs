//
//  CalcKeyboardView.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/06/30.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalcKeyboardDelegate <NSObject>
- (void)pushNumberButton:(id)sender;
- (void)pushDecimalPointButton:(id)sender;
- (void)pushAddButton:(id)sender;
- (void)pushSubtractionButton:(id)sender;
- (void)pushMultiplicationButton:(id)sender;
- (void)pushDivisionButton:(id)sender;
- (void)pushEqualButton:(id)sender;
- (void)pushClearButton:(id)sender;
- (void)pushDeleteButton:(id)sender;
- (void)pushPlusMinusButton:(id)sender;
- (void)pushPercentButton:(id)sender;
@end


@interface CalcKeyboardView : UIView <UIInputViewAudioFeedback>

@property (nonatomic, assign) id <CalcKeyboardDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *decimalSeparatorButton;

- (IBAction)pushNumberButton:(id)sender;
- (IBAction)pushDecimalPointButton:(id)sender;
- (IBAction)pushAddButton:(id)sender;
- (IBAction)pushSubtractionButton:(id)sender;
- (IBAction)pushMultiplicationButton:(id)sender;
- (IBAction)pushDivisionButton:(id)sender;
- (IBAction)pushEqualButton:(id)sender;
- (IBAction)pushClearButton:(id)sender;
- (IBAction)pushDeleteButton:(id)sender;
- (IBAction)pushPlusMinusButton:(id)sender;
- (IBAction)pushPercentButton:(id)sender;

- (void)setClearButtonAllClear;
- (void)setClearButtonClear;
@end
