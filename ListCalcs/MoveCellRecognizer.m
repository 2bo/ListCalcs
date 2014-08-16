//
//  MoveCellRecognizer.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/05/04.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import "MoveCellRecognizer.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const JTTableViewRowAnimationDuration          = 0.25;       // Rough guess is 0.25
@interface MoveCellRecognizer () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <MoveCellDelegate> delegate;

@property (nonatomic, weak) id <UITableViewDelegate>         tableViewDelegate;
@property (nonatomic, weak) UITableView                     *tableView;
@property (nonatomic, strong) NSIndexPath                   *addingIndexPath;
@property (nonatomic, strong) UILongPressGestureRecognizer  *longPressRecognizer;
@property (nonatomic, strong) UIImage                       *cellSnapshot;
@property (nonatomic, assign) CGFloat                        scrollingRate;
@property (nonatomic, strong) NSTimer                       *movingTimer;

@end
#define CELL_SNAPSHOT_TAG 100000

@implementation MoveCellRecognizer

@synthesize delegate, tableView, addingIndexPath,tableViewDelegate;
@synthesize longPressRecognizer;
@synthesize cellSnapshot, scrollingRate, movingTimer;

//セルの移動時にタップされている間の、スクロールを
- (void)scrollTable {
    // Scroll tableview while touch point is on top or bottom part
    
    //(0,0)位置のポイントを作成
    CGPoint location        = CGPointZero;
    
    // Refresh the indexPath since it may change while we use a new offset
    //タップされている位置を取得
    location  = [self.longPressRecognizer locationInView:self.tableView];
    
    //tableviwのスクロール位置を取得する
    CGPoint currentOffset = self.tableView.contentOffset;
    
    //scrollingRate分を追加して、newOffsetにする
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + self.scrollingRate);
    if (newOffset.y < 0) {
        //ゼロを下回ったら、0に設定
        newOffset.y = 0;
    } else if (self.tableView.contentSize.height < self.tableView.frame.size.height) {
        //TableViewのセルがある部分のサイズが、TableViwのフレームサイズを下回る場合、オフセットを現在のオフセットにする
        newOffset = currentOffset;
        
    } else if (newOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height) {
        //TableViewのセルがある部分のサイズ - TableViwのフレームサイズの値が、　あたらしいオフセットを下回る場合
        //その値をあらたなオフセットとする
        newOffset.y = self.tableView.contentSize.height - self.tableView.frame.size.height;
    } else {
    }
    //tableViewをスクロールさせる
    [self.tableView setContentOffset:newOffset];
    
    //locationがゼロ以上なら、その位置にsnapshotを持ってくる
    if (location.y >= 0) {
        UIImageView *cellSnapshotView = (id)[self.tableView viewWithTag:CELL_SNAPSHOT_TAG];
        cellSnapshotView.center = CGPointMake(self.tableView.center.x, location.y);
    }
    //メソッドの呼び出し
    [self updateAddingIndexPathForCurrentLocation];
}

- (void)updateAddingIndexPathForCurrentLocation {
    //IndexPathと位置を生成
    NSIndexPath *indexPath  = nil;
    CGPoint location        = CGPointZero;
    
    // Refresh the indexPath since it may change while we use a new offset
    //長押しされた位置の取得
    location  = [self.longPressRecognizer locationInView:self.tableView];
    //長押しされた位置のindexPathを取得
    indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //indexpathがnilでなく、addingIndexPathと同じでない場合に{}内を処理
    if (indexPath && ! [indexPath isEqual:self.addingIndexPath]) {
        //セルの更新を開始
        [self.tableView beginUpdates];
        //追加セルの位置を削除
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.addingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        //ロングタップされた位置にセルを挿入
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //オブジェクトを入れ替える
        [self.delegate gestureRecognizer:self needsMoveRowAtIndexPath:self.addingIndexPath toIndexPath:indexPath];
        //addingPathを更新
        self.addingIndexPath = indexPath;
        //セルの位置を更新
        [self.tableView endUpdates];
    }
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer {
    //ロングタップされた位置の取得
    CGPoint location = [recognizer locationInView:self.tableView];
    //タップされた位置にあるセルの取得
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //ロングタップが開始された時
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //状態を移動中にする
        //self.state = MoveCellRecognizerStateMoving;
        //タップされたセルを取得
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //セルの大きさのオフスクリーン(描画領域)を作成
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
        //画面描画
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        //セルの内容を画像として取り出す
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        //オフスクリーンの破棄
        UIGraphicsEndImageContext();
        
        
        // We create an imageView for caching the cell snapshot here
        //セルのスナップショットを取得する
        UIImageView *snapShotView = (UIImageView *)[self.tableView viewWithTag:CELL_SNAPSHOT_TAG];
        //スナップショットが取得できなければ生成する
        if ( ! snapShotView) {
            //UIimageViewの生成
            snapShotView = [[UIImageView alloc] initWithImage:cellImage];
            //タグをつける
            snapShotView.tag = CELL_SNAPSHOT_TAG;
            //UIimageViewを追加する
            [self.tableView addSubview:snapShotView];
            //ロングタップされた箇所の描画領域を取得
            CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
            
            //スナップショットのフレームを移動する(?)
            snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
            
        }
        // Make a zoom in effect for the cell
        //アニメーションの開始
        [UIView beginAnimations:@"zoomCell" context:nil];
        //スナップショットのセルを縦横1.1倍に拡大する
        snapShotView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        //イメージのセンターを、TbleViewの中央のセルのタップされた位置にしていする
        snapShotView.center = CGPointMake(self.tableView.center.x, location.y);
        //アニメーションの終了
        [UIView commitAnimations];
        
        //tableViwの更新開始
        [self.tableView beginUpdates];
        //ロングタップされた位置のセルを削除する(アニメーションはしない) 削除対象をNSArrayで複数選択する形式のメソッドになっている。
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //ロングタップされた位置にセルを挿入する(アニメーションはしない)
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //ロングタップされた位置にスペースを作る
        [self.delegate gestureRecognizer:self needsCreatePlaceholderForRowAtIndexPath:indexPath];
        
        //追加位置を記憶
        self.addingIndexPath = indexPath;
        
        //セルの更新を終了
        [self.tableView endUpdates];
        
        // Start timer to prepare for auto scrolling
        
        //1/8秒間隔のタイマーを定義
        self.movingTimer = [NSTimer timerWithTimeInterval:1/8 target:self selector:@selector(scrollTable) userInfo:nil repeats:YES];
        //タイマーをメインループに登録
        [[NSRunLoop mainRunLoop] addTimer:self.movingTimer forMode:NSDefaultRunLoopMode];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // While long press ends, we remove the snapshot imageView
        //スナップショット(選択したセルの画像)の取得
        __block __weak UIImageView *snapShotView = (UIImageView *)[self.tableView viewWithTag:CELL_SNAPSHOT_TAG];
        //弱参照のselfを取得(?)
        __block __weak MoveCellRecognizer *weakSelf = self;
        
        // We use self.addingIndexPath directly to make sure we dropped on a valid indexPath
        // which we've already ensure while UIGestureRecognizerStateChanged
        __block __weak NSIndexPath *indexPath = self.addingIndexPath;
        
        // Stop timer
        //メインループのNSRunLoopオブジェクトからTimerを解放する
        [self.movingTimer invalidate];
        //タイマーを空にする
        self.movingTimer = nil;
        //scrollingRateを0にリセット
        self.scrollingRate = 0;
        
        [UIView animateWithDuration:JTTableViewRowAnimationDuration
                         animations:^{
                             //ロングタップされた位置の描画領域を取得する
                             CGRect rect = [weakSelf.tableView rectForRowAtIndexPath:indexPath];
                             //スナップショットのサイズを元に戻す
                             snapShotView.transform = CGAffineTransformIdentity;    // restore the transformed value
                             //スナップショットをタップされた位置に移動
                             snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y);
                         } completion:^(BOOL finished) {
                             //スナップショットを画面から削除
                             [snapShotView removeFromSuperview];
                             //テーブルビューの更新を開始
                             [weakSelf.tableView beginUpdates];
                             //タップされた位置にあるセルを削除
                             [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             //タップされた位置にあるセルを追加(?)
                             [weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                             //データの入れ替え
                             [weakSelf.delegate gestureRecognizer:weakSelf needsReplacePlaceholderForRowAtIndexPath:indexPath];
                             //テーブルの更新終了
                             [weakSelf.tableView endUpdates];
                             //指定したindexpahのセル以外の画面に表示されているセルを更新
                             [weakSelf.tableView reloadVisibleRowsExceptIndexPath:indexPath];
                             // Update state and clear instance variables
                             //インスタンス変数の開放
                             weakSelf.cellSnapshot = nil;
                             weakSelf.addingIndexPath = nil;
                             //weakSelf.state = MoveCellRecognizerStateNone;
                         }];
        
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // While our finger moves, we also moves the snapshot imageView
        //スナップショット(タップして浮いた状態のセルの画像)の取得
        UIImageView *snapShotView = (UIImageView *)[self.tableView viewWithTag:CELL_SNAPSHOT_TAG];
        //スナップショットの位置をタップされた位置に移動
        snapShotView.center = CGPointMake(self.tableView.center.x, location.y);
        
        CGRect rect      = self.tableView.bounds;
        //長押しされた位置の取得
        CGPoint location = [self.longPressRecognizer locationInView:self.tableView];
        //画面の可視領域の座標を取得
        location.y -= self.tableView.contentOffset.y;       // We needed to compensate actual contentOffset.y to get the relative y position of touch.
        
        [self updateAddingIndexPathForCurrentLocation];
        
        //テーブルビューの6/1の高さ
        CGFloat bottomDropZoneHeight = self.tableView.bounds.size.height / 6;
        CGFloat topDropZoneHeight    = bottomDropZoneHeight;
        
        CGFloat bottomDiff = location.y - (rect.size.height - bottomDropZoneHeight);
        if (bottomDiff > 0) {
            self.scrollingRate = bottomDiff / (bottomDropZoneHeight / 1);
        } else if (location.y <= topDropZoneHeight) {
            self.scrollingRate = -(topDropZoneHeight - MAX(location.y, 0)) / bottomDropZoneHeight;
        } else {
            self.scrollingRate = 0;
        }
    }
}


#pragma mark Class method

+ (MoveCellRecognizer *)gestureRecognizerWithTableView:(UITableView *)tableView delegate:(id)delegate {
    MoveCellRecognizer *recognizer = [[MoveCellRecognizer alloc] init];
    recognizer.delegate             = (id)delegate;
    recognizer.tableView            = tableView;
    recognizer.tableViewDelegate    = tableView.delegate;     // Assign the delegate before chaning the tableView's delegate
    tableView.delegate              = recognizer;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:recognizer action:@selector(longPressGestureRecognizer:)];
    [tableView addGestureRecognizer:longPress];
    longPress.delegate              = recognizer;
    recognizer.longPressRecognizer  = longPress;
    
    return recognizer;
}

#pragma mark UIGestureRecognizer

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
   if (gestureRecognizer == self.longPressRecognizer) {
        
        CGPoint location = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        
        if (indexPath && [self.delegate conformsToProtocol:@protocol(MoveCellDelegate)]) {
            BOOL canMoveRow = [self.delegate gestureRecognizer:self canMoveRowAtIndexPath:indexPath];
            return canMoveRow;
        }
        return NO;
    }
    return YES;
}

@end

@implementation UITableView (JTTableViewGestureDelegate)

- (MoveCellRecognizer *)enableGestureTableViewWithDelegate:(id)delegate {
    if (! [delegate conformsToProtocol:@protocol(MoveCellDelegate)]) {
        [NSException raise:@"delegate should MoveCellDelegate" format:nil];
    }
    MoveCellRecognizer *recognizer = [MoveCellRecognizer gestureRecognizerWithTableView:self delegate:delegate];
    return recognizer;
}


#pragma mark Helper methods

- (void)reloadVisibleRowsExceptIndexPath:(NSIndexPath *)indexPath {
    //レシーバに表示されている(可視可能な)行のインデックスパスを配列で返す
    NSMutableArray *visibleRows = [[self indexPathsForVisibleRows] mutableCopy];
    //可視なセルから指定した位置のオブジェクトを削除
    [visibleRows removeObject:indexPath];
    //可視可能なセルのうち、指定した位置にあるセル以外をすべて更新
    [self reloadRowsAtIndexPaths:visibleRows withRowAnimation:UITableViewRowAnimationNone];
}

@end