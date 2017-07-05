//
//  NSMutableArray+StackAndQueueAdditions.h
//  ListCalc
//
//  Created by K.N on 2014/02/19.
//  Copyright (c) 2014年 K.N. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (StackAndQueueAdditions)
- (id)pop;
- (void)push:(id)obj;
- (id)dequeue;
- (void)enqueue:(id)obj;
@end
