//
//  ListCalcsTests,m
//  ListCalcsTests
//
//  Created by Kota_Nakatsubo on 2014/08/06,
//  Copyright (c) 2014年 Kota_Nakatsubo, All rights reserved,
//

#import <XCTest/XCTest.h>
#import "CalcModel.h"

@interface ListCalcsTests : XCTestCase

@end

@implementation ListCalcsTests

- (void)setUp {
	[super setUp];
	// Put setup code here, This method is called before the invocation of each test method in the class,
}

- (void)tearDown {
	// Put teardown code here, This method is called after the invocation of each test method in the class,
	[super tearDown];
}

- (void)testInput1To9 {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"2"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"3"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"9"]];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"123.456.789", @"Failed");
}

- (void)testAdd {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	[calcModel inputOperatorAdd];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"2"]];
	[calcModel inputEqual];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"3", @"Failed");
}

- (void)testSub {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	[calcModel inputOperatorSubtract];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"2"]];
	[calcModel inputEqual];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-1", @"Failed");
}

- (void)testMul {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	[calcModel inputOperatorMultiply];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"2"]];
	[calcModel inputEqual];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"2", @"Failed");
}

- (void)testDiv {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	[calcModel inputoperatorDivide];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"2"]];
	[calcModel inputEqual];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,5", @"Failed");
}

- (void)test1Div3Mul3 {
	CalcModel *calcModel = [[CalcModel alloc] init];
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"1"]];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"1", @"Failed");

	[calcModel inputoperatorDivide];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"1", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"3"]];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"3", @"Failed");

	[calcModel inputOperatorMultiply];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,333333333333", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"3"]];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"3", @"Failed");

	[calcModel inputEqual];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"1", @"Failed");
}

- (void)test1 { //4+5+6+7+8= 30
	CalcModel *calcModel = [[CalcModel alloc] init];

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperatorAdd];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");

	[calcModel inputOperatorAdd];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"9", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");

	[calcModel inputOperatorAdd];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"15", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");

	[calcModel inputOperatorAdd];
	XCTAssertEqualObjects([calcModel requestDisplayString], @"22", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");

	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"30", @"Failed");
}

- (void)test2 { //4-5-6+7*8= 49
	CalcModel *calcModel = [[CalcModel alloc] init];

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");

	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-1", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");

	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-7", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");

	[calcModel inputOperatorMultiply]; //*
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");

	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"49", @"Failed");
}

- (void)test3 { //4+5-6*7+8= -25
	CalcModel *calcModel = [[CalcModel alloc] init];

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");

	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"9", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");

	[calcModel inputOperatorMultiply]; //*
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");

	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-33", @"Failed");

	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");

	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-25", @"Failed");
}

- (void)test4 { //4-5-6*7/8= -6,25
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-1", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorMultiply]; //*
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"42", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-6,25", @"Failed");
}


- (void)test5 { //4+5/6+7+8= 19,833333333333
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"11,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"19,833333333333", @"Failed");
}

- (void)test6 { //4+5/6+7/8= 5,708333333333
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5,708333333333", @"Failed");
}

- (void)test7 { //4-5/6*7+8= 6,166666666667
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorSubtract]; //-
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-1,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6,166666666667", @"Failed");
}

- (void)test8 { //4+5/6/7/8= 4,014880952381
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorAdd]; //+
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,833333333333", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
    //FIXME:6÷7になっている。
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,119047619048", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4,014880952381", @"Failed");
}

- (void)test9 { //4*5-6+7-8= 13
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; //*
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorSubtract]; // -
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"14", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorSubtract]; // -
	XCTAssertEqualObjects([calcModel requestDisplayString], @"21", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"13", @"Failed");
}

- (void)test10 { //4/5-6+7*8= 50,8
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorSubtract]; // -
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,8", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"-5,2", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"50,8", @"Failed");
}

- (void)test11 { //4*5+6/7+8= 28,857142857143
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20,857142857143", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"28,857142857143", @"Failed");
}

- (void)test12 { //4*5-6/7*8= 13,142857142857
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorSubtract]; // -
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,857142857143", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"13,142857142857", @"Failed");
}

- (void)test13 { //4/5*6+7+8= 19,8
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputoperatorDivide]; // /
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"0,8", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4,8", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"11,8", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"19,8", @"Failed");
}

- (void)test14 { //4*5*6+7*8= 176
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"120", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"176", @"Failed");
}

- (void)test15 { //4*5*6*7+8= 848
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"120", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorAdd]; // +
	XCTAssertEqualObjects([calcModel requestDisplayString], @"840", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"848", @"Failed");
}

- (void)test16 { //4*5*6*7*8= 6,720
	CalcModel *calcModel = [[CalcModel alloc] init];
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"4"]]; //4の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"4", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"5"]]; //5の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"5", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"20", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"6"]]; //6の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"120", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"7"]]; //7の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"7", @"Failed");
    
	[calcModel inputOperatorMultiply]; // *
	XCTAssertEqualObjects([calcModel requestDisplayString], @"840", @"Failed");
    
	[calcModel inputOperand:[NSDecimalNumber decimalNumberWithString:@"8"]]; //8の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"8", @"Failed");
    
	[calcModel inputEqual]; //=の入力
	XCTAssertEqualObjects([calcModel requestDisplayString], @"6.720", @"Failed");
}

@end
