//
//  NSMutableArray+StackAndQueueAdditions.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/02/19.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import "NSMutableArray+StackAndQueueAdditions.h"

@implementation NSMutableArray (StackAndQueueAdditions)

/**
   スタックのポップ
 */
- (id)pop {
	if ([self count] == 0) {
		return nil;
	}
	id object = [self lastObject];
	if (object != nil) {
		[self removeLastObject];
	}
	return object;
}

/**
   スタックのプッシュ
 */
- (void)push:(id)obj {
	[self addObject:obj];
}

/**
   キューのデキュー
 */
- (id)dequeue {
	id object = [self objectAtIndex:0];
	if (object != nil) {
		[self removeObjectAtIndex:0];
	}
	return object;
}

/**
   キューのエンキュー
 */
- (void)enqueue:(id)anObject {
	[self addObject:anObject];
}

@end
