//
//  CalcModel.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2013/11/30.
//  Copyright (c) 2013年 Kota_Nakatsubo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*演算子*/
typedef NS_ENUM (NSInteger, CalcOperator) {
	OperatorNone,           //none
	OperatorAddition,       // +
	OperatorSubtraction,     // -
	OperatorMultiplication,  // X
	OperatorDivision,    // /
};

/*入力状態*/
typedef NS_ENUM (NSInteger, CalcStatus) {
	StatusNumberInput, //数値入力状態
	StatusOpereterInput, //演算子入力状態
	StatusResultDisplayed, //結果表示状態(「=」が押された後の状態)
};

@interface CalcModel : NSObject

- (void)inputOperand:(NSDecimalNumber *)operand;
- (void)inputOperandWithString:(NSString *)string;
- (void)inputOperatorAdd;
- (void)inputOperatorSubtract;
- (void)inputOperatorMultiply;
- (void)inputoperatorDivide;
- (void)inputDecimalPoint;
- (void)inputEqual;
- (void)inputPercent;
- (void)inputPlusMinus;
- (void)clear;
- (void)del;

- (NSString *)requestDisplayString;
- (NSDecimalNumber *)requestDisplayNumber;
- (NSInteger )requestDisplayOperator;
+ (NSDecimalNumber *)abs:(NSDecimalNumber *)num;

@property (retain, nonatomic) NSDecimalNumber *displayNumber;
@property (retain, nonatomic) NSMutableString *displayString;
@property (retain, nonatomic) NSString *memo;
@property (assign, nonatomic, readonly) BOOL isClear;
@property (assign, nonatomic, readonly) CalcStatus calcStatus;

@end
