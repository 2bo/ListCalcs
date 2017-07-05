//
//  CalcKeyboardView.m
//  ListCalc
//
//  Created by K.N on 2014/06/30.
//  Copyright (c) 2014年 K.N. All rights reserved.
//

#import "CalcKeyboardView.h"

@implementation CalcKeyboardView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		// make self from nib file
		CGRect screenSize = [UIScreen mainScreen].bounds;
		UINib *nib;
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        //NSLog(@"decimal Separator: %@",[formatter decimalSeparator]);
        
		//画面サイズの判定
		if (screenSize.size.height <= 480) {
			nib = [UINib nibWithNibName:@"CalcKeyboard_3_5" bundle:nil];
            self = [nib instantiateWithOwner:nil options:nil][0];
			//小数点ボタンのローカライズ
			if ([[formatter decimalSeparator] isEqualToString:@","]) {
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button_@3_5.png"]  forState:UIControlStateNormal];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button_selected_@3_5.png"]  forState:UIControlStateSelected];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button_selected_@3_5.png"]  forState:UIControlStateHighlighted];
			}
			else {
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button_@3_5.png"]  forState:UIControlStateNormal];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button_selected_@3_5.png"]  forState:UIControlStateSelected];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button_selected_@3_5.png"]  forState:UIControlStateHighlighted];
			}
		}
		else {
			nib = [UINib nibWithNibName:@"CalcKeyboard" bundle:nil];
            self = [nib instantiateWithOwner:nil options:nil][0];
			//小数点ボタンのローカライズ
			if ([[formatter decimalSeparator] isEqualToString:@","]) {
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button.png"]  forState:UIControlStateNormal];
                
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button_selected.png"]  forState:UIControlStateSelected];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalComma_button_selected.png"]  forState:UIControlStateHighlighted];
			}
			else {
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button.png"]  forState:UIControlStateNormal];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button_selected.png"]  forState:UIControlStateSelected];
				[self.decimalSeparatorButton setBackgroundImage:[UIImage imageNamed:@"DecimalPoint_button_selected.png"]  forState:UIControlStateHighlighted];
			}
		}
		
	}

	self.frame = frame;
	return self;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */



- (IBAction)pushDecimalPointButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushDecimalPointButton:sender];
}

- (IBAction)pushNumberButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushNumberButton:sender];
}

- (IBAction)pushAddButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushAddButton:sender];
}

- (IBAction)pushSubtractionButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushSubtractionButton:sender];
}

- (IBAction)pushMultiplicationButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushMultiplicationButton:sender];
}

- (IBAction)pushDivisionButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushDivisionButton:sender];
}

- (IBAction)pushEqualButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushEqualButton:sender];
}

- (IBAction)pushClearButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushClearButton:sender];
}

- (IBAction)pushDeleteButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushDeleteButton:sender];
}

- (IBAction)pushPlusMinusButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushPlusMinusButton:sender];
}

- (IBAction)pushPercentButton:(id)sender {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	if ([userDefaults boolForKey:@"isClickSoundSwitchOn"]) {
		[[UIDevice currentDevice] playInputClick];
	}
	[self.delegate pushPercentButton:sender];
}

- (void)setClearButtonAllClear {
	CGRect screenSize = [UIScreen mainScreen].bounds;
	//画面サイズの判定
	if (screenSize.size.height <= 480) {
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button_@3_5.png"]  forState:UIControlStateNormal];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button_selected_@3_5.png"]  forState:UIControlStateSelected];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button_selected_@3_5.png"]  forState:UIControlStateHighlighted];
	}
	else {
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button.png"]  forState:UIControlStateNormal];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button_selected.png"]  forState:UIControlStateSelected];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"AC_button_selected.png"]  forState:UIControlStateHighlighted];
	}
}

- (void)setClearButtonClear {
	CGRect screenSize = [UIScreen mainScreen].bounds;
	//画面サイズの判定
	if (screenSize.size.height <= 480) {
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button_@3_5.png"]  forState:UIControlStateNormal];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button_selected_@3_5.png"]  forState:UIControlStateSelected];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button_selected_@3_5.png"]  forState:UIControlStateHighlighted];
	}
	else {
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button.png"]  forState:UIControlStateNormal];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button_selected.png"]  forState:UIControlStateSelected];
		[self.clearButton setBackgroundImage:[UIImage imageNamed:@"C_button_selected.png"]  forState:UIControlStateHighlighted];
	}
}

- (BOOL)enableInputClicksWhenVisible {
	return YES;
}

@end
