//
//  StatisticsView.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/06/16.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CopyableUILabel;

typedef NS_ENUM (NSInteger, StatisticsViewStyle) {
	StatisticsViewStyleSum,//合計
    StatisticsViewStyleAverage//平均
};

@interface StatisticsView : UIView


@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet CopyableUILabel *numberLabel;

- (void)setStyle:(StatisticsViewStyle)style;

@end
