//
//  copyable.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/06/25.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import "CopyableUILabel.h"

@implementation CopyableUILabel

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
	}
	[self attachTapHandler];
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self attachTapHandler];
}

- (void)attachTapHandler {
	[self setUserInteractionEnabled:YES];
	UIGestureRecognizer *touchy = [[UITapGestureRecognizer alloc]
	                               initWithTarget:self action:@selector(handleTap:)];
	[self addGestureRecognizer:touchy];
}

- (void)copy:(id)sender {
	NSLog(@"Copy handler, label: “%@”.", self.text);
    // UIPasteboardのインスタンスを生成する。
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setValue:self.text forPasteboardType:@"public.utf8-plain-text"];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return (action == @selector(copy:));
}

- (void)handleTap:(UIGestureRecognizer *)recognizer {
	[self becomeFirstResponder];
	UIMenuController *menu = [UIMenuController sharedMenuController];
	[menu setTargetRect:self.frame inView:self.superview];
	[menu setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect
   {
    // Drawing code
   }
 */

@end
