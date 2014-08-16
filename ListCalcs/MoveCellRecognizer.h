//
//  MoveCellRecognizer.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/05/04.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import <Foundation/Foundation.h>

// JTTableViewRowAnimationDuration is decided to be as close as the internal settings of UITableViewRowAnimation duration
extern CGFloat const JTTableViewRowAnimationDuration;

@interface MoveCellRecognizer : NSObject <UITableViewDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;

+ (MoveCellRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id)delegate;

@end

@protocol MoveCellDelegate;

// Conform to MoveCellDelegate to enable features
// - long press to reorder cell
@protocol MoveCellDelegate <NSObject>

- (BOOL)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UITableView (MoveCellDelegate)

- (MoveCellRecognizer *)enableGestureTableViewWithDelegate:(id)delegate;

// Helper methods for updating cell after datasource changes
- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath;

@end