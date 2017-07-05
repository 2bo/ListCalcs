//
//  StatisticsView.m
//  ListCalc
//
//  Created by K.N on 2014/06/16.
//  Copyright (c) 2014年 K.N. All rights reserved.
//

#import "StatisticsView.h"

@implementation StatisticsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // make self from nib file
        UINib *nib = [UINib nibWithNibName:@"StatisticsView" bundle:nil];
        self = [nib instantiateWithOwner:nil options:nil][0];
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


- (void)setStyle:(StatisticsViewStyle)style{
    switch (style) {
        case StatisticsViewStyleSum:
            self.backgroundColor = [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:1.0];
            self.functionLabel.text = NSLocalizedString(@"Sum", nil);
            break;
            //rgb(241, 196, 15)
            //rgb(231, 76, 60)
            //rgb(26, 188, 156)
            //rgb(243, 156, 18)
            //rgb(230, 126, 34)
        case StatisticsViewStyleAverage:
            self.backgroundColor = [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.0];
            self.functionLabel.text = NSLocalizedString(@"Average", nil);
            
        default:
            break;
    }
    
}



@end
