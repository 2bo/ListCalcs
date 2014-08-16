//
//  CalcModel.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2013/11/30.
//  Copyright (c) 2013年 Kota_Nakatsubo. All rights reserved.
//

#import "CalcModel.h"
#import "NSMutableArray+StackAndQueueAdditions.h"

@interface CalcModel ()
//- (void)resetCalc;
@property (assign, nonatomic, readwrite) BOOL isClear; //クラス内からは読み書き可能
@property (assign, nonatomic, readwrite) CalcStatus calcStatus;
@end

@implementation CalcModel

#define ERROR_MESSAGE @"ERROR"
#define DECIMAL_SEPARATOR @"."

{
	NSMutableArray *queue;
	CalcOperator konstantCalcOperator; //定数計算用の演算子格納用
	NSDecimalNumber *konstant; //定数計算の定数格納用
    NSString *decimalSeparator; //小数点
}

- (id)init {
	if (self = [super init]) {
		/*self.calcStatus = StatusNumberInput;
		self.isClear = YES;
		konstant = nil;
		konstantCalcOperator = OperatorNone;*/
		[self resetCalc];
        /*NSNumberFormatter *formatter =  [[NSNumberFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];*/
        decimalSeparator = DECIMAL_SEPARATOR;
	}
	return self;
}

/**
   数値入力を処理する
 */
- (void)inputOperand:(NSDecimalNumber *)inputedNumber {
	switch (self.calcStatus) {
		case StatusNumberInput:

			//13桁以上、もしくは少数点第12位以下の数値入力は受け付けない
			if (12 <= [self.displayString length]) { //FIXME:数字直打ち
				NSRange searchResult = [self.displayString rangeOfString:decimalSeparator]; //小数点を検索
				if (searchResult.location == NSNotFound) {
					break;
				}
				else if (13 <= [self.displayString length]) {  //FIXME:数字直打ち
					break;
				}
			}

			//値が0の状態で、0が入力された場合は何もしない
			if (![self.displayString isEqualToString:@"0"] || [inputedNumber compare:[NSDecimalNumber zero]] != NSOrderedSame) {
				if ([self.displayString isEqualToString:@"0"]) { //1桁目は、入力された数字をそのまま文字列に変換
					self.displayString = [NSMutableString stringWithFormat:@"%@", inputedNumber];
				}
				else { //2桁目以降は、入力された数字を末尾に追加
					[self.displayString appendFormat:@"%@", inputedNumber];
				}
			}
			break;

		case StatusOpereterInput:
			self.displayString = [NSMutableString stringWithFormat:@"%@", inputedNumber]; //一桁目になるので、入力された数字をそのまま文字列に変換
			break;

		case StatusResultDisplayed:
			queue = [[NSMutableArray alloc] init];
			self.displayString = [NSMutableString stringWithFormat:@"%@", inputedNumber]; //一桁目になるので、入力された数字をそのまま文字列に変換

		default:
			break;
	}
	//self.operand = [NSDecimalNumber decimalNumberWithString:self.displayString]; //文字列を10進数に変換
	//self.displayString = operandString;
	//self.displayNumber = self.operand;

	self.calcStatus = StatusNumberInput; //数値入力状態へ遷移
	self.isClear = NO;
}

/**
   数値入力(クリップボードからのペーストによる数値入力用)
 */
- (void)inputOperandWithString:(NSString *)string {
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;

	NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithDecimal:[[formatter numberFromString:string] decimalValue]];

	if (self.calcStatus == StatusNumberInput) {
		self.displayString = [NSMutableString stringWithFormat:@"%@", number];
	}
	else {
		[self inputOperand:number];
	}
}

/**
   小数点入力を処理する
 */
- (void)inputDecimalPoint {
	switch (self.calcStatus) {
		case StatusNumberInput:
		{
			NSRange searchResult = [self.displayString rangeOfString:decimalSeparator]; //小数点を検索
			if (searchResult.location == NSNotFound) {
				[self.displayString appendString:decimalSeparator]; //小数点が入力されていないなら、小数点を追加
			}
		}
		break;

		case StatusOpereterInput:
		{
			self.displayString = [NSMutableString stringWithString:@"0"];//一桁目になるので、入力された数字をそのまま文字列に変換
            [self.displayString appendString:decimalSeparator];
		}

		break;

		case StatusResultDisplayed:
		{
			[self resetCalc];
			self.displayString = [NSMutableString stringWithString:@"0"]; //一桁目になるので、入力された数字をそのまま文字列に変換
            [self.displayString appendString:decimalSeparator];
		}
		break;

		default:
			break;
	}
	//self.displayString = operandString;
	self.calcStatus = StatusNumberInput; //数値入力状態へ遷移
	self.isClear = NO;
}

/**
   演算子が入力された時の共通処理
 */
- (void)inputOperator:(CalcOperator)inputedOperator {
	switch (self.calcStatus) {
		case StatusNumberInput: {
			//[queue enqueue:self.operand]; //スタックに被演算子をenqueue

			/*if ([self.displayString hasSuffix:decimalSeparator]) { //少数点以下が入力されていないなら、小数点を削除する
				[self.displayString deleteCharactersInRange:NSMakeRange([self.displayString length] - 1, 1)];
			}*/
            
            /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            NSString *groupingSeparator = [formatter groupingSeparator];
            
            [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];

			NSDecimalNumber *operand = [NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]];*/
            NSDecimalNumber *operand = [self requestDisplayNumber];
			[queue enqueue:operand];

			//演算子の入力が2回目以降の場合
			if ([queue count] >= 3) {
				NSMutableArray *copyStack = [queue mutableCopy]; //キューのコピー
				id obj;

				while ([copyStack count] > 0) {
					obj = [copyStack pop];
					if (![obj isMemberOfClass:[NSDecimalNumber class]] && [obj isKindOfClass:[NSNumber class]]) { //前回入力された演算子を取り出す
						break;
					}
				}
				if ([self comparePriorityOperatorA:[NSNumber numberWithInteger:inputedOperator] toOperatorB:obj] < 1) {
                    
                    //演算子が×,÷の場合
					if (inputedOperator == OperatorMultiplication || inputedOperator == OperatorDivision) {
                        
                        copyStack = [queue mutableCopy];
                        id obj;
                        NSInteger i = 0;
                        
                        //入力された式の演算子が+,-になるまでさかのぼる
                        for(i = [copyStack count]; i > 0 ; i--){
                            obj = [copyStack objectAtIndex:i - 1];
                            if(![obj isMemberOfClass:[NSDecimalNumber class]] && [obj isKindOfClass:[NSNumber class]]){
                                if([self comparePriorityOperatorA:[NSNumber numberWithInteger:inputedOperator] toOperatorB:obj] != 0){
                                    break;
                                }
                            }
                        }
                        
                        [copyStack removeObjectsInRange:NSMakeRange(0, i)];
                        NSMutableArray *reversPolish = [self convertInfixToReversePolish:copyStack];
                        NSDecimalNumber *result = [self calculateFromReversePolish:reversPolish];
                        
						if ([result isEqual:[NSDecimalNumber notANumber]]) {
							[self.displayString setString:ERROR_MESSAGE];
						}
						else {
                            [self.displayString setString:[result stringValue]];
						}
					}
					else {
						NSMutableArray *revershPolish = [self convertInfixToReversePolish:queue];
						NSDecimalNumber *result = [self calculateFromReversePolish:revershPolish];
						if ([result isEqual:[NSDecimalNumber notANumber]]) {
							[self.displayString setString:ERROR_MESSAGE];
						}
						else {
                            [self.displayString setString:[result stringValue]];
						}
					}
				}
			}
		}
		break;

		case StatusOpereterInput:
			[queue pop]; //スタックから演算子をPOP
			break;

		case StatusResultDisplayed:
        {
			queue = [[NSMutableArray alloc] init];
			//[queue enqueue:self.displayNumber]; //スタックに被演算子をenqueue
			if ([self.displayString isEqualToString:ERROR_MESSAGE]) {
				[self.displayString setString:@"0"];
			}
            /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            NSString *groupingSeparator = [formatter groupingSeparator];
            [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];
            
			[queue enqueue:[NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]]];*/
            [queue enqueue:[self requestDisplayNumber]];
        }
			break;

		default:
			break;
	}
	if ([self.displayString isEqualToString:ERROR_MESSAGE]) {
		self.calcStatus = StatusResultDisplayed;
	}
	else {
		konstantCalcOperator = inputedOperator;
		[queue enqueue:[NSNumber numberWithInteger:inputedOperator]]; //スタックに演算子をenqueue
		self.calcStatus = StatusOpereterInput; //演算子入力状態へ遷移
	}
	self.isClear = YES;
}

/**
   「=」が入力された時の処理
 */
- (void)inputEqual {
	//[queue enqueue:self.operand]; //スタックに被演算子をenqueue
	/*if ([self.displayString hasSuffix:decimalSeparator]) { //少数点以下が入力されていないなら、小数点を削除する
		[self.displayString deleteCharactersInRange:NSMakeRange([self.displayString length] - 1, 1)];
	}*/

	switch (self.calcStatus) {
		case StatusNumberInput:
		{
			if ([queue count] == 0) {
				if (konstant == nil || konstantCalcOperator == OperatorNone) {
					break;
				}
				else {
					//定数計算
                    /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    [formatter setLocale:[NSLocale currentLocale]];
                    NSString *groupingSeparator = [formatter groupingSeparator];
                    [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];
					[queue enqueue:[NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]]];*/
                    [queue enqueue:[self requestDisplayNumber]];
					[queue enqueue:[NSNumber numberWithInteger:konstantCalcOperator]];
					[queue enqueue:konstant];
				}
			}
			else {
				//定数を保持
				konstant = [self requestDisplayNumber];
                
                /*[NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]];*/
				
                //通常の計算
                /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setLocale:[NSLocale currentLocale]];
                NSString *groupingSeparator = [formatter groupingSeparator];
                [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];
                
				NSDecimalNumber *operand = [NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]];*/
                NSDecimalNumber *operand = [self requestDisplayNumber];
				[queue enqueue:operand];
			}

			NSMutableArray *revershPolish = [self convertInfixToReversePolish:queue];
			NSDecimalNumber *result = [self calculateFromReversePolish:revershPolish];

			if ([result isEqual:[NSDecimalNumber notANumber]]) {
				[self.displayString setString:ERROR_MESSAGE];
			}
			else {
				/*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterNoStyle];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                [formatter setLocale:[NSLocale currentLocale]];
                [formatter setMaximumFractionDigits:12];*/
				[self.displayString setString:[result stringValue]];
			}
			break;
		}

		case StatusOpereterInput:
		{
            /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            NSString *groupingSeparator = [formatter groupingSeparator];
			
             [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];
            
            //定数を保持
			konstant = [NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]];*/
            konstant = [self requestDisplayNumber];
            
			[queue enqueue:konstant];
			NSMutableArray *revershPolish = [self convertInfixToReversePolish:queue];
			NSDecimalNumber *result = [self calculateFromReversePolish:revershPolish];
			if ([result isEqual:[NSDecimalNumber notANumber]]) {
				[self.displayString setString:ERROR_MESSAGE];
			}
			else {
				[self.displayString setString:[result stringValue]];
			}
		}

		break;

		case StatusResultDisplayed:
		{
			if (konstant == nil || konstantCalcOperator == OperatorNone) {
				break;
			}

			queue = [[NSMutableArray alloc] init];
           /* NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            NSString *groupingSeparator = [formatter groupingSeparator];
            [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];
			[queue enqueue:[NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]]];*/
            [queue enqueue:[self requestDisplayNumber]];
			[queue enqueue:[NSNumber numberWithInteger:konstantCalcOperator]];
			[queue enqueue:konstant];

			NSMutableArray *revershPolish = [self convertInfixToReversePolish:queue];
			NSDecimalNumber *result = [self calculateFromReversePolish:revershPolish];

			if ([result isEqual:[NSDecimalNumber notANumber]]) {
				[self.displayString setString:ERROR_MESSAGE];
			}
			else {
				[self.displayString setString:[result stringValue]];
			}
		}
		break;

		default:
			break;
	}
	self.calcStatus = StatusResultDisplayed;
    self.isClear = NO;
}

/***
   「+」が入力された時の処理
 */
- (void)inputOperatorAdd {
	[self inputOperator:OperatorAddition];
}

/***
   「-」が入力された時の処理
 */
- (void)inputOperatorSubtract {
	[self inputOperator:OperatorSubtraction];
}

/***
   「×」が入力された時の処理
 */
- (void)inputOperatorMultiply {
	[self inputOperator:OperatorMultiplication];
}

/***
   「÷」が入力された時の処理
 */
- (void)inputoperatorDivide {
	[self inputOperator:OperatorDivision];
}

/***
   「%」が入力された時の処理
 */
- (void)inputPercent {
	switch (self.calcStatus) {
		case StatusNumberInput:
		case StatusResultDisplayed:
		{
			NSDecimalNumber *number = [self requestDisplayNumber];
			NSDecimalNumber *oneHundred = [NSDecimalNumber decimalNumberWithMantissa:100 exponent:0 isNegative:NO];
			//100で割った値にする
            NSDecimalNumber *result = [number decimalNumberByDividingBy:oneHundred];
            [self.displayString setString:[result stringValue]];
		}
		break;

		default:
			break;
	}
}

/***
   「±」が入力された時の処理
 */
- (void)inputPlusMinus {
	switch (self.calcStatus) {
		case StatusNumberInput:
		case StatusResultDisplayed:
		{
			NSDecimalNumber *number = [self requestDisplayNumber];
			NSDecimalNumber *negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES];
			//-1を掛けた値にする
            NSDecimalNumber *result = [number decimalNumberByMultiplyingBy:negativeOne];
            [self.displayString setString:[result stringValue]];
		}
		break;

		default:
			break;
	}
}

/***
   「clear」が入力された時の処理
 */
- (void)clear {
	switch (self.calcStatus) {
		case StatusNumberInput:
			if (self.isClear) { //All clear
				[self resetCalc];
			}
			else { //clear
				   //operandString = [NSMutableString stringWithString:@"0"];
				self.displayString = [NSMutableString stringWithString:@"0"];
				self.isClear = YES;
			}
			break;

		case StatusOpereterInput:
            if (self.isClear) { //All clear
				[self resetCalc];
			}
			break;

		case StatusResultDisplayed:
			//operandString = [NSMutableString stringWithString:@"0"];
			if (self.isClear) { //All clear
				[self resetCalc];
			}else{
                self.displayString = [NSMutableString stringWithString:@"0"];
				self.isClear = YES;
                self.calcStatus = StatusNumberInput;
            }
			break;

		default:
			break;
	}
}

/***
   「delete」が入力された時の処理
 */
- (void)del {
	switch (self.calcStatus) {
		case StatusNumberInput:
		{
			NSUInteger length = [self.displayString length];
			if (1 < length) {
				[self.displayString deleteCharactersInRange:NSMakeRange(length - 1, 1)]; //最後の一文字を削除
			}
			else if (1 == length) {
				self.displayString = [NSMutableString stringWithString:@"0"]; //0にする
			}
		}
		break;

		case StatusOpereterInput:
			break;

		case StatusResultDisplayed:
			break;

		default:
			break;
	}
}

/**
   中間記法から逆ポーランド記法に変換する
   引数:中間記法の数式が格納されたキュー
   戻り値:逆ポーランド記法が格納されたNSMutable
 */

- (NSMutableArray *)convertInfixToReversePolish:(NSMutableArray *)infixNotationQueue {
	NSMutableArray *operandStack = [[NSMutableArray alloc]init]; //演算子の一時格納用スタック
	NSMutableArray *resultQueue = [[NSMutableArray alloc]init]; //逆ポーランド記法への変換結果を格納するキュー
	infixNotationQueue = [infixNotationQueue mutableCopy]; //呼び出し元のNSMutableが変更されないようにするため、コピーを作成

	id obj;
	while ([infixNotationQueue count] > 0) {
		obj = [infixNotationQueue dequeue]; //演算子か被演算子が入る
		//被演算子と演算子をインスタンスのクラスで判定する。
		if ([obj isMemberOfClass:[NSDecimalNumber class]]) { //NSDecimalNumberは被演算子として処理
			[resultQueue enqueue:obj];
		}
		else if ([obj isKindOfClass:[NSNumber class]]) { //NSNumberは演算子として処理
			while ([operandStack count] > 0) {
				if ([self comparePriorityOperatorA:obj toOperatorB:[operandStack lastObject]] == 1) {
					break;     //演算子が演算子スタック最上段の演算子より優先度が高い場合ループを抜ける
				}
				else {
					id operand = [operandStack pop];
					[resultQueue enqueue:operand];    //演算子スタックからポップし、結果格納用キューに追加
				}
			}
			[operandStack push:obj]; //演算子を結果格納用キューに格納
		}
	}
	while ([operandStack count] > 0) {
		id operand = [operandStack pop];
		[resultQueue enqueue:operand]; //演算子スタックを空になるまでポップし、結果格納用キューに格納
	}
	return resultQueue;
}

/***
 *逆ポーランド記法の数式が格納されたキューを受け取り、計算を実行するメソッド
 *引数:逆ポーランド記法が格納されたキュー
 *戻り値:計算結果
 */
- (NSDecimalNumber *)calculateFromReversePolish:(NSMutableArray *)reversePolishQueue {
	//self.result = [NSDecimalNumber zero];
	NSMutableArray *operandStack = [[NSMutableArray alloc]init]; //被演算子格納用スタック
	id obj;
	while ([reversePolishQueue count] > 0) {
		obj = [reversePolishQueue dequeue];

		if ([obj isMemberOfClass:[NSDecimalNumber class]]) {
			[operandStack push:obj]; //数値の場合は、被演算子スタックにPUSH
		}
		else if ([obj isKindOfClass:[NSNumber class]]) {
			if ([operandStack count] >= 2) {
				NSDecimalNumber *operandB = [operandStack pop]; //スタックでは、先に取り出したほうが2つ目の演算子となる
				NSDecimalNumber *operandA = [operandStack pop];
				NSDecimalNumber *operandC = [self calculateOperandA:operandA andOperandB:operandB withOperator:obj];
				if ([operandC isEqual:[NSDecimalNumber notANumber]]) {
					return operandC;
				}
				[operandStack push:operandC]; //計算結果を被演算子にPUSH
			}
		}
	}
	return [operandStack pop]; //数式がなくなった後、被演算子スタック入っている数値が計算結果となる
}

/***
 *演算子の優先順位を比較するメソッド
 ****************優先度: (×,÷ >>> +,-)
 * A=B  0を返す
 * A>B  1を返す
 * A<B -1を返す
 */
- (NSInteger)comparePriorityOperatorA:(NSNumber *)operatorA toOperatorB:(NSNumber *)operatorB {
	NSInteger opeA = [operatorA intValue];
	NSInteger opeB = [operatorB intValue];

	if ((opeA == OperatorAddition || opeA == OperatorSubtraction) && (opeB == OperatorAddition || opeB == OperatorSubtraction)) {
		return 0; //足算と引き算同士の場合、0を返す
	}
	else if ((opeA == OperatorMultiplication || opeA == OperatorDivision) && (opeB == OperatorMultiplication || opeB == OperatorDivision)) {
		return 0; //掛け算と割り算同士の場合、0を返す
	}
	else if ((opeA == OperatorMultiplication || opeA == OperatorDivision) && (opeB == OperatorAddition || opeB == OperatorSubtraction)) {
		return 1; //演算子Aが掛け算、割り算で、演算子Bが足算、引き算の場合は1を返す
	}
	else {
		return -1; //上記以外の場合(演算子Aが足算、引き算で、演算子Bが掛け算、割り算)-1を返す
	}
}

/*受け取った演算子により、各四則演算メソッドを呼び出す
 *
 */
- (NSDecimalNumber *)calculateOperandA:(NSDecimalNumber *)operandA andOperandB:(NSDecimalNumber *)operandB withOperator:(NSNumber *)operator {
	NSInteger ope = [operator intValue]; //NS_ENUMで定義した値と比較するため、NSIntegerに変換
	NSDecimalNumber *result;
	result = [NSDecimalNumber zero];
	switch (ope) {
		case OperatorAddition:
			result = [self additionWithOperandA:operandA andOperandB:operandB];
			break;

		case OperatorSubtraction:
			result = [self subtractionWithOperandA:operandA andOperandB:operandB];
			break;

		case OperatorMultiplication:
			result = [self multiplicationWithOperandA:operandA andOperandB:operandB];
			break;

		case OperatorDivision:
			result = [self divisionWithOperandA:operandA andOperandB:operandB];
			break;

		default:
			break;
	}
	return result;
}

/**
   足算
 */
- (NSDecimalNumber *)additionWithOperandA:(NSDecimalNumber *)operandA andOperandB:(NSDecimalNumber *)operandB {
	NSDecimalNumber *result = [operandA decimalNumberByAdding:operandB];
	return result;
}

/**
   引算
 */
- (NSDecimalNumber *)subtractionWithOperandA:(NSDecimalNumber *)operandA andOperandB:(NSDecimalNumber *)operandB {
	NSDecimalNumber *result = [operandA decimalNumberBySubtracting:operandB];
	return result;
}

/**
   掛算
 */
- (NSDecimalNumber *)multiplicationWithOperandA:(NSDecimalNumber *)operandA andOperandB:(NSDecimalNumber *)operandB {
	NSDecimalNumber *result = [operandA decimalNumberByMultiplyingBy:operandB];
	return result;
}

/**
   割算
 */
- (NSDecimalNumber *)divisionWithOperandA:(NSDecimalNumber *)operandA andOperandB:(NSDecimalNumber *)operandB {
	if ([operandB compare:[NSDecimalNumber zero]] == NSOrderedSame) {
		return [NSDecimalNumber notANumber]; //0除算になる場合は、NaNを返す
	}
	NSDecimalNumber *result = [operandA decimalNumberByDividingBy:operandB];
	return result;
}

/**
   被演算子と演算子のリセット
 */
- (void)resetCalc {
	self.displayString = [NSMutableString stringWithString:@"0"]; //文字列を0にリセット
	queue = [[NSMutableArray alloc] init];
	konstant = nil;
	konstantCalcOperator = OperatorNone;
	self.isClear = YES;
	self.calcStatus = StatusNumberInput;
}

/**
   表示する文字列を返す変数
 */
- (NSString *)requestDisplayString {
	if (self.displayString == nil) {
		return @"0";
	}

	if ([self.displayString isEqualToString:ERROR_MESSAGE]) {
		return ERROR_MESSAGE;
	}
    /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];*/
    /*NSString *groupingSeparator = [formatter groupingSeparator];
    
    [self.displayString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[self.displayString length])];*/

	if (![self.displayString hasSuffix:decimalSeparator]) {
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
    
        NSMutableString *numberString = [NSMutableString stringWithString:self.displayString];
        /*NSString *groupingSeparator = [formatter groupingSeparator];
        [numberString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[numberString length])];*/
        
        //NSLog(@"self.displaystring %@",self.displayString);
        
     //   NSDictionary *localeDict = [NSDictionary dictionaryWithObject:decimalSeparator forKey:NSLocaleDecimalSeparator];
		NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:numberString];
        
        //NSDecimalNumber *operand = [NSDecimalNumber decimalNumberWithString:self.displayString locale:[NSLocale currentLocale]];
   
		NSDecimalNumber *absoluteValue = [CalcModel abs:decimalNumber];
        
		if (NSOrderedSame == [absoluteValue compare:[NSDecimalNumber zero]]) {
			return self.displayString;
		}
		else if (NSOrderedDescending == [absoluteValue compare:[NSDecimalNumber numberWithDouble:999999999999]] || NSOrderedAscending == [absoluteValue compare:[NSDecimalNumber numberWithDouble:0.000000000001]]) { //FIXME:数字直打ち
			// NSNumberを科学形式(E)に変換
			[formatter setMaximumFractionDigits:6];
			formatter.numberStyle = NSNumberFormatterScientificStyle;
            return [formatter stringFromNumber:decimalNumber];
		}
		else {
			// NSNumberを3桁区切りに変換
			[formatter setMaximumFractionDigits:12];
			formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            //小数点以下の最後が0で終わる数字の表示(例:1.000)
            if(self.calcStatus == StatusNumberInput && [self.displayString hasSuffix:@"0"] && [self.displayString rangeOfString:decimalSeparator].location != NSNotFound){
                
                //小数点の表示ケタを調整
                NSUInteger minimunFractionDigits =  [self.displayString length] - [self.displayString rangeOfString:decimalSeparator options:NSBackwardsSearch].location - 1 ;
                [formatter setMinimumFractionDigits:minimunFractionDigits];
            }
            NSString *formattedNumber = [formatter stringFromNumber:decimalNumber];
            return formattedNumber;
		}
    
	}
	else {//末尾が小数点で終わる場合
        NSMutableString *numberString = [NSMutableString stringWithString:self.displayString];
        [numberString deleteCharactersInRange:NSMakeRange([numberString length] - 1, 1)];
        
		NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:numberString];
        
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
        [formatter setLocale:[NSLocale currentLocale]];
		NSString *formattedNumber = [formatter stringFromNumber:decimalNumber];
		NSString *appendPoint = [formattedNumber stringByAppendingString:[formatter decimalSeparator]]; //小数点を末尾に追加
		return appendPoint;
	}
}

/**
   表示する数値を返す変数
 */
- (NSDecimalNumber *)requestDisplayNumber {
	NSMutableString *numberString = [NSMutableString stringWithString:self.displayString];

	if (numberString == nil) {
		return [NSDecimalNumber zero];
	}

	if ([numberString isEqualToString:ERROR_MESSAGE]) {
		return [NSDecimalNumber zero];
	}

	if ([numberString hasSuffix:decimalSeparator]) { //少数点以下が入力されていないなら、小数点を削除する
		[numberString deleteCharactersInRange:NSMakeRange([numberString length] - 1, 1)];
	}
    /*NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
     NSString *groupingSeparator = [formatter groupingSeparator];*/
    /*[numberString replaceOccurrencesOfString:groupingSeparator withString:@"" options:0 range:NSMakeRange( 0,[numberString length])];*/
    
	return [NSDecimalNumber decimalNumberWithString:numberString];
}

/**
   NSDecimalNumberの絶対値を返すメソッド
 */
+ (NSDecimalNumber *)abs:(NSDecimalNumber *)num {
	if ([num compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
		//-1を掛ける
		NSDecimalNumber *negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1
		                                                                 exponent:0
		                                                               isNegative:YES];
		return [num decimalNumberByMultiplyingBy:negativeOne];
	}
	else {
		return num;
	}
}

/**
   演算子を返すメソッド
 */
- (NSInteger)requestDisplayOperator {
	if (self.calcStatus == StatusOpereterInput) {
        //前回入力された演算子を取り出す
		id obj = [queue objectAtIndex:[queue count] - 1];
		if (![obj isMemberOfClass:[NSDecimalNumber class]] && [obj isKindOfClass:[NSNumber class]]) {
            return [obj integerValue];
		}
	}
	return OperatorNone;
}

@end
