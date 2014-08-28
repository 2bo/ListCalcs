//
//  ViewController.m
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2013/11/24.
//  Copyright (c) 2013年 Kota_Nakatsubo. All rights reserved.
//

#import "ViewController.h"
#import "CalcTableViewCell.h"
#import "MoveCellRecognizer.h"
#import "CalcModel.h"
#import "StatisticsView.h"
#import "CopyableUILabel.h"
#import "CalcKeyboardView.h"
#import "SettingTableViewController.h"
#import "SVProgressHUD.h"

@interface ViewController () <MoveCellDelegate>
@property (nonatomic, strong) MoveCellRecognizer *tableViewRecognizer;
@property (nonatomic, strong) id grabbedObject;

@end

@implementation ViewController 
#define DUMMY_CELL @"Dummy"
{
	CGFloat initialTableViewHeight;
	StatisticsView *sumView;
	StatisticsView *averageView;
}

@synthesize tableViewRecognizer;
@synthesize grabbedObject;



- (void)viewDidLoad {
	[super viewDidLoad];
    
    /*広告枠の追加*/
    bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 20, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    bannerView.adUnitID = @"ca-app-pub-6871882305713553/4205288629";
    bannerView.rootViewController = self;
    [self.view addSubview:bannerView];
    
    [bannerView loadRequest:[GADRequest request]];
    
    //GADRequest *request = [GADRequest request];
    
    /*// テスト広告のリクエストを行う。
    // テスト広告を表示する端末の識別子を埋め込む。
    request.testDevices = [NSArray arrayWithObjects:
                           @"22642F6E-2462-5500-AC38-CCC722807242",
                           @"YOUR_DEVICE_IDENTIFIER",
                           nil];*/

	self.calcsArray = [NSMutableArray array];
	//NavigationBarに置くボタンの作成
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCalc:)];
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:@selector(share:)];
	UIBarButtonItem *trashButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showConfirmationActionSheet:)];
    

    UIButton *gearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [gearButton setImage:[UIImage imageNamed:@"settings-512.png"] forState:UIControlStateNormal];
    gearButton.frame = CGRectMake(0, 0, 25, 25);
    [gearButton addTarget:self action:@selector(openSettingTableViewController:) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *preferenceButton = [[UIBarButtonItem alloc] initWithCustomView:gearButton];
    
    /*[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-512.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(openSettingTableViewController:)];*/
    
    /*[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"settings-44.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStylePlain target:self action:nil];*/

	//NavigationBarへボタンを置く
	self.navigationBar.topItem.rightBarButtonItems = @[addButton, actionButton];
	self.navigationBar.topItem.leftBarButtonItems = @[trashButton, preferenceButton];

	//セルの初期化
	[self.calcsArray addObject:[[CalcModel alloc] init]];
	self.currentCellIndexPath = [NSIndexPath indexPathForRow:[self.calcsArray count] - 1 inSection:0];

	self.tableViewRecognizer = [self.calcTableView enableGestureTableViewWithDelegate:self];
	//self.calcTableView.backgroundColor = [UIColor blackColor];

	[self.calcTableView setDataSource:self];
	[self.calcTableView setDelegate:self];

	//TableViewの背景色を設定 rgb(236, 240, 241)
	[self.calcTableView setBackgroundColor:[UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.0]];

	

	//統計ビューの初期化
	sumView = [[StatisticsView alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0f)];
	[sumView setStyle:StatisticsViewStyleSum];
	averageView = [[StatisticsView alloc] initWithFrame:CGRectMake(320, 0, 320, 44.0f)];
	[averageView setStyle:StatisticsViewStyleAverage];
	[self displyStatitics];

	[self.view addSubview:self.pageControl];
	[self.pageControl addTarget:self action:@selector(pageControlDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //ステータスバーがタップされた時に、TableViewだけを先頭にスクロールする
    self.scrollView.scrollsToTop = NO;
    self.calcTableView.scrollsToTop = YES;
    
    NSLog(@"%lf",self.scrollView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.calcTableView reloadData];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    //TableViewの高さを保持
	initialTableViewHeight = self.calcTableView.frame.size.height;
    
	CGRect contentRect = CGRectMake(0, 0, 320 * 2, 44);
	UIView *contentView = [[UIView alloc] initWithFrame:contentRect];
	[contentView addSubview:sumView];
	[contentView addSubview:averageView];
	[self.scrollView addSubview:contentView];

	[self.scrollView setContentSize:contentRect.size];
	[self.view layoutSubviews];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	//self.calcTableView.frame.size.height = initialTableViewHeight;
	/*CGRect frame = self.calcTableView.frame;
	   frame.size.height = initialTableViewHeight;
	   self.calcTableView.frame = frame;*/

	//initialTableViewHeight = self.calcTableView.frame.size.height;
	CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
	CGRect tvFrame = self.calcTableView.frame;
	tvFrame.size.height = initialTableViewHeight - convertedFrame.size.height;
	self.calcTableView.frame = tvFrame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
	CGRect tvFrame = self.calcTableView.frame;
	tvFrame.size.height = initialTableViewHeight;
	//[UIView beginAnimations:@"TableViewDown" context:NULL];
	//[UIView setAnimationDuration:0.3f];
	self.calcTableView.frame = tvFrame;
	//[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//セクション数は常に1
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.calcsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *object = [self.calcsArray objectAtIndex:indexPath.row];
	static NSString *CellIdentifier = @"CalcTableViewCell";

	CalcTableViewCell *cell
	    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[CalcTableViewCell alloc]
		        initWithStyle:UITableViewCellStyleDefault
		                         reuseIdentifier:CellIdentifier];
	}
	if ([object isEqual:DUMMY_CELL]) {
		[cell setCellinfoNone];
	}
	else {
		//セルに値を表示する
		[cell setCellDefault];
		[cell setCellInfo:[self.calcsArray objectAtIndex:indexPath.row]];
		cell.memoTextField.delegate = self;
		cell.invisibleTextField.delegate = self;
		//cell.invisibleTextField.inputView = [[[NSBundle mainBundle] loadNibNamed:@"CalcKeyboard" owner:self options:nil] lastObject];
        
        CGRect screenSize = [UIScreen mainScreen].bounds;
        CalcKeyboardView *calcKeybordView;
        
        //画面サイズによってキーボードのサイズを変える
        if(screenSize.size.height <= 480){
            calcKeybordView  = [[CalcKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 320, 208)];
        }else{
            calcKeybordView  = [[CalcKeyboardView alloc] initWithFrame:CGRectMake(0, 0, 320, 299)];
        }
		calcKeybordView.delegate = self;
		cell.invisibleTextField.inputView = calcKeybordView;


		//キーボード上部のAccessoryView用のツールバー
		UIToolbar *toolbar = [[UIToolbar alloc] init];
		[toolbar setBarStyle:UIBarStyleDefault];
		[toolbar sizeToFit];
		UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedSpace.width = 24;
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyboardDoneButtonDidTouch:)];
        
        UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [copyButton setImage:[UIImage imageNamed:@"copy-512.png"] forState:UIControlStateNormal];
        copyButton.frame = CGRectMake(0, 0, 25, 25);
        [copyButton addTarget:self action:@selector(keyboardCopyButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        
		UIBarButtonItem *copyBarButton = [[UIBarButtonItem alloc] initWithCustomView:copyButton];
        /*[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(keyboardCopyButtonDidTouch:)];*/
        
        UIButton *pasteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [pasteButton setImage:[UIImage imageNamed:@"paste-512.png"] forState:UIControlStateNormal];
        pasteButton.frame = CGRectMake(0, 0, 25, 25);
        [pasteButton addTarget:self action:@selector(keyboardPasteButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        
		UIBarButtonItem *pasteBarButton = [[UIBarButtonItem alloc] initWithCustomView:pasteButton];
        /*[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Paste", nil)  style:UIBarButtonItemStyleBordered target:self action:@selector(keyboardPasteButtonDidTouch:)];*/

		//可変長スペース
		UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		[toolbar setItems:[NSArray arrayWithObjects:copyBarButton, fixedSpace, pasteBarButton, flexibleItem, doneButton, nil] animated:NO];
		toolbar.translucent = YES;
		cell.invisibleTextField.inputAccessoryView = toolbar;
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *object = [self.calcsArray objectAtIndex:indexPath.row];
	if ([object isEqual:DUMMY_CELL]) {
		cell.backgroundColor = [UIColor blackColor];
	}
	else {
		cell.backgroundColor = [UIColor whiteColor];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.currentCellIndexPath != nil && self.currentCellIndexPath.row != indexPath.row) {
		//前回選択されたセルを取得
		CalcModel *calcModel = (CalcModel *)[self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
		if (calcModel != nil && calcModel.calcStatus != StatusResultDisplayed) {
			//別のセルに移る前に、=を入力する
			[calcModel inputEqual];
			CalcTableViewCell *lastSelectedCell = (CalcTableViewCell *)[tableView cellForRowAtIndexPath:self.currentCellIndexPath];
			[lastSelectedCell setCellInfo:calcModel];
			[self displyStatitics];
		}
	}

	//最後に選択されたセルの位置を保持する
	self.currentCellIndexPath = indexPath;
	CalcTableViewCell *cell = (CalcTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell.invisibleTextField becomeFirstResponder];

}

//数字ボタンが押された時の処理
- (void)pushNumberButton:(id)sender {
	//押されたボタンの取得
	UIButton *button = (UIButton *)sender;

	//NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:button.currentTitle];
	//値の変更
	NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInteger:button.tag] decimalValue]];

	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputOperand:decimalNumber];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];

	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];

	if (![calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   　小数点ボタンが押された時の処理
 */
- (void)pushDecimalPointButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputDecimalPoint];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];

	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];

	if (![calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   「+」ボタンが押された時の処理
 */
- (void)pushAddButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputOperatorAdd];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];
	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
    
    if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}
	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   「-」ボタンが押された時の処理
 */
- (void)pushSubtractionButton:(id)sender {
	
    CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputOperatorSubtract];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];
	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
    
    
    if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   「×」ボタンが押された時の処理
 */
- (void)pushMultiplicationButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputOperatorMultiply];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];
	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
    
    if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   「÷」ボタンが押された時の処理
 */
- (void)pushDivisionButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputoperatorDivide];
	[self.calcsArray replaceObjectAtIndex:self.currentCellIndexPath.row withObject:calcModel];
	//最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
    
    if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/***
   「＝」ボタンが押された時の処理
 */
- (void)pushEqualButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputEqual];
	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];

	//1-2の処理を共通メソッドに切り出したほうがスマートかも
    
    if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//統計を計算
	[self displyStatitics];
}

- (void)pushClearButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];

	//Clearが事項される前のisClear
	if ([calcModel isClear]) {
		//ACが押された場合は、統計を再計算する
		[calcModel clear];
		[self displyStatitics];
	}
	else {
		[calcModel clear];
	}

	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];

	if ([calcModel isClear]) {
		CalcKeyboardView *calcKeyboardView  = (CalcKeyboardView *)currentCell.invisibleTextField.inputView;
		if ([calcKeyboardView isKindOfClass:[CalcKeyboardView class]]) {
			[calcKeyboardView setClearButtonAllClear];
			currentCell.invisibleTextField.inputView = calcKeyboardView;
		}
	}

	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];

	//1-2の処理を共通メソッドに切り出したほうがスマートかも
}

- (void)pushDeleteButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel del];
	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];

	//1-2の処理を共通メソッドに切り出したほうがスマートかも
}

/***
   「+/-」ボタンが押された時の処理
 */
- (void)pushPlusMinusButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputPlusMinus];
	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];

	//1-2の処理を共通メソッドに切り出したほうがスマートかも
}

/***
   「％」ボタンが押された時の処理
 */
- (void)pushPercentButton:(id)sender {
	CalcModel *calcModel = [self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
	[calcModel inputPercent];
	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];

	//1-2の処理を共通メソッドに切り出したほうがスマートかも
}

- (void)addCalc:(id)sender {
	//キーボードを閉じる
	[self.view endEditing:YES];

	//配列にモデルオブジェクトを追加
	[self.calcsArray addObject:[[CalcModel alloc] init]];


	//前回選択されたセルを取得
	if (self.currentCellIndexPath != nil) {
		CalcModel *calcModel = (CalcModel *)[self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
		if (calcModel != nil && calcModel.calcStatus != StatusResultDisplayed) {
			//別のセルに移る前に、=を入力する
			[calcModel inputEqual];
			CalcTableViewCell *lastSelectedCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
			[lastSelectedCell setCellInfo:calcModel];
			[self displyStatitics];
		}
	}

	//セルの追加
	self.currentCellIndexPath = [NSIndexPath indexPathForRow:[self.calcsArray count] - 1 inSection:0];
	[self.calcTableView insertRowsAtIndexPaths:@[self.currentCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	//追加行が画面に見えるようにスクロールする
	[self.calcTableView selectRowAtIndexPath:self.currentCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	[self.calcTableView scrollToRowAtIndexPath:self.currentCellIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

	//統計の表示
	[self displyStatitics];
}

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
	//セルが2つ以上あれば削除する
	if (editingStyle == UITableViewCellEditingStyleDelete && [self.calcsArray count] > 1) {
		[self.view endEditing:YES];
		[self.calcsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		self.currentCellIndexPath = nil;
		[self displyStatitics];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	//最後の1セルはスワイプしても、削除ボタンが出ないようにしている
	if ([self.calcsArray count] > 1) {
		return UITableViewCellEditingStyleDelete;
	}
	//統計の計算
	[self displyStatitics];
	return UITableViewCellEditingStyleNone;
}

//すべてのセルの合計をだす。
- (NSDecimalNumber *)calcSum {
	NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
	CalcModel *calcModel;
	for (int i = 0; i < [self.calcsArray count]; i++) {
		calcModel = (CalcModel *)[self.calcsArray objectAtIndex:i];
		sum = [sum decimalNumberByAdding:[calcModel requestDisplayNumber]];
	}
	return sum;
}

/***
   すべてのセルの平均を計算
 */
- (NSDecimalNumber *)calcAverage {
	NSDecimalNumber *average = [self calcSum];
	NSDecimalNumber *count = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithUnsignedInteger:[self.calcsArray count]] decimalValue]];
	average = [average decimalNumberByDividingBy:count];
	return average;
}

/***
   統計を表示するメソッド
 */
- (void)displyStatitics {
	sumView.numberLabel.text = [self formatNumber:[self calcSum]];
	averageView.numberLabel.text = [self formatNumber:[self calcAverage]];
}

/**
   数字をフォーマットするメソッド
 */
- (NSString *)formatNumber:(NSDecimalNumber *)decimalNumber {
	NSDecimalNumber *absoluteValue = [CalcModel abs:decimalNumber];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
	if (NSOrderedSame == [absoluteValue compare:[NSDecimalNumber zero]]) {
		// NSNumberを3桁区切りに変換
		[formatter setMaximumFractionDigits:12];
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
	}
	else if (NSOrderedDescending == [absoluteValue compare:[NSDecimalNumber numberWithDouble:999999999999]] || NSOrderedAscending == [absoluteValue compare:[NSDecimalNumber numberWithDouble:0.000000000001]]) {  //(F):数字直打ち
		// NSNumberを科学形式(E)に変換
		[formatter setMaximumFractionDigits:6];
		formatter.numberStyle = NSNumberFormatterScientificStyle;
	}
	else {
		// NSNumberを3桁区切りに変換
		[formatter setMaximumFractionDigits:12];
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
	}
	return [formatter stringFromNumber:decimalNumber];
}

- (void)allClearCalc {
	//削除するセルの位置(常に2行目)
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	//先頭の１行以外のセル１行づつすべて削除する
	NSInteger numOfRows = [self.calcsArray count];
	for (int i = 0; i < numOfRows - 1; i++) {
		[self.calcsArray removeObjectAtIndex:1];
		[self.calcTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	//選択中の位置を先頭にする
	self.currentCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	//計算モデルのクリア
	[self.calcsArray replaceObjectAtIndex:0 withObject:[[CalcModel alloc] init]];

	//統計の計算
	[self displyStatitics];

	//テーブルビューのリロード
	[self.calcTableView reloadData];
}

- (void)showConfirmationActionSheet:(id)sender {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Cancellation_Confirmed", nil)	                                                   delegate:self
	                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
	                                     destructiveButtonTitle:NSLocalizedString(@"Clear_All", nil)
	                                          otherButtonTitles:nil];
	[sheet setActionSheetStyle:UIActionSheetStyleDefault];
	[sheet showInView:self.view];
}

- (void)     actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self allClearCalc];
			break;
	}
}

/**
   常にYESを返す
 **/
- (BOOL)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

/**
   セルの移動時に、移動させるセルに対応するObjectを、ダミーObjectと入れ替える
 */
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
	//ロングタップで選択した行を、浮いた状態のオブジェクトに指定する
	id object  = [self.calcsArray objectAtIndex:indexPath.row];
	self.grabbedObject = object;

	if ([object isKindOfClass:[CalcModel class]]) {
		CalcModel *calcModel = (CalcModel *)object;
		CalcTableViewCell *cell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:indexPath];
		calcModel.memo = cell.memoTextField.text;
		self.grabbedObject = calcModel;
	}

	//データ配列に、ダミーのオブジェクトを入れる
	[self.calcsArray replaceObjectAtIndex:indexPath.row withObject:DUMMY_CELL];
}

/**
   オブジェクトを入れ替える
 **/
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	//移動元の位置にあるオブジェクトを取り出す
	id object = [self.calcsArray objectAtIndex:sourceIndexPath.row];
	//移動元の位置にあるオブジェクトを削除する
	[self.calcsArray removeObjectAtIndex:sourceIndexPath.row];
	//移動先の位置にオブジェクトを挿入する
	[self.calcsArray insertObject:object atIndex:destinationIndexPath.row];
}

/**
   動かしたセルのデータを、任意の位置に入れる
 **/
- (void)gestureRecognizer:(MoveCellRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
	//指定の位置に、移動セルのデータを入れる
	[self.calcsArray replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
	//浮いた状態のセルに対応するデータの確保用オブジェクトをnilにする
	self.grabbedObject = nil;

	self.currentCellIndexPath = indexPath;
}

/**
   テキストフィールド入力時に、キーボードでReturnが押された際に呼ばれるメソッド
 **/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UIView *view = textField;
    while (view && ![view isKindOfClass:[CalcTableViewCell class]]){
        view = view.superview;
    }
    
	CalcTableViewCell *cell = (CalcTableViewCell *)view;
    
	if ([cell isKindOfClass:[CalcTableViewCell class]]) { //UITableViewCellクラスか確認
        NSIndexPath *path = [self.calcTableView indexPathForCell:cell];
		NSInteger row = path.row;
		NSObject *object = [self.calcsArray objectAtIndex:row];

		if ([object isKindOfClass:[CalcModel class]]) {
			CalcModel *calcModel = (CalcModel *)object;
            NSLog(@"textField.text: %@ tag %ld",textField.text,(long)textField.tag);
            
            if(textField.tag == 0){
                //Memo用のTextField(Tag:0)ならば、メモの内容を保持
                calcModel.memo = textField.text;
            }else if (textField.tag == -1 && calcModel.calcStatus != StatusResultDisplayed){
                //計算用のTextField(Tag:-1)で、結果表示状態でなければ「=」を入力
                [calcModel inputEqual];
                [cell setCellInfo:calcModel];
                [self displyStatitics];
            }
            [self.calcsArray replaceObjectAtIndex:row withObject:calcModel];
		}
	}
}

- (void)scrollToCell:(NSIndexPath *)path {
	[self.calcTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIView *view = textField;
    while (view && ![view isKindOfClass:[UITableViewCell class]]){
        view = view.superview;
    }
	UITableViewCell *cell = (UITableViewCell *)view;
    
	NSIndexPath *path = [self.calcTableView indexPathForCell:cell];

	if (self.currentCellIndexPath != nil && self.currentCellIndexPath.row != path.row) {
		//前回選択されたセルを取得
		CalcModel *calcModel = (CalcModel *)[self.calcsArray objectAtIndex:self.currentCellIndexPath.row];
		if (calcModel.calcStatus != StatusResultDisplayed) {
			//別のセルに移る前に、=を入力する
			[calcModel inputEqual];
			CalcTableViewCell *lastSelectedCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
			[lastSelectedCell setCellInfo:calcModel];
			[self displyStatitics];
		}
	}
	[self.calcTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
	self.currentCellIndexPath = path;
	[self performSelector:@selector(scrollToCell:) withObject:path afterDelay:0.1f];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	CGFloat pageWidth = self.scrollView.frame.size.width;
	if (fmod(self.scrollView.contentOffset.x, pageWidth) == 0.0) {
		int pageNum = self.scrollView.contentOffset.x / pageWidth;
		self.pageControl.currentPage = pageNum;
	}
}

- (void)pageControlDidChange:(UIPageControl *)sender {
	CGRect frame = self.scrollView.frame;
	frame.origin.x = frame.size.width * sender.currentPage;
	frame.origin.y = 0;
	[self.scrollView scrollRectToVisible:frame animated:YES];
}

/**
   電卓用キーボードのDoneボタンが押された時の処理
 */
- (void)keyboardDoneButtonDidTouch:(id)sender {
	//キーボードを閉じる
	[self.view endEditing:YES];
}

/**
   電卓用キーボードのCopyボタンが押された時の処理
 */
- (void)keyboardCopyButtonDidTouch:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	CalcTableViewCell *cell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	[pasteboard setValue:cell.numberLabel.text forPasteboardType:@"public.utf8-plain-text"];
}

/**
   電卓用キーボードのPasteボタンが押された時の処理
 */
- (void)keyboardPasteButtonDidTouch:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	NSString *pastboardString = [pasteboard valueForPasteboardType:@"public.text"];
	CalcModel *calcModel = (CalcModel *)[self.calcsArray objectAtIndex:self.currentCellIndexPath.row];

	if (pastboardString != nil) {
		[calcModel inputOperandWithString:pastboardString];
	}

	//1.最後に選択されたセルの取得
	CalcTableViewCell *currentCell = (CalcTableViewCell *)[self.calcTableView cellForRowAtIndexPath:self.currentCellIndexPath];
	//2.ボタンのラベル(NSstring)をセル内のラベルに表示
	[currentCell setCellInfo:calcModel];
}

/**
   　設定画面へ遷移する処理
 */
- (void)openSettingTableViewController:(id)sender {
	UINavigationController *settingTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
	[self presentViewController:settingTableViewController animated:YES completion:nil];
}


/**
   共有ボタンが押された時の処理
 */
- (void)share:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

	NSMutableString *text = [NSMutableString stringWithCapacity:0];
    
    //合計
	[text appendString:sumView.functionLabel.text];
	[text appendString:@"\t"];
	[text appendString:sumView.numberLabel.text];
	[text appendString:@"\r\n"];
    
    //平均
    [text appendString:averageView.functionLabel.text];
	[text appendString:@"\t"];
	[text appendString:averageView.numberLabel.text];
	[text appendString:@"\r\n"];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	//共有するテキストの作成(タブ区切り)
	int i = 1;
	if ([userDefaults boolForKey:@"isMemoSwitchOn"]) {
		//memoありの場合
		for (CalcModel *calcModel in self.calcsArray) {
			[text appendString:[NSString stringWithFormat:@"%d:", i]];
			[text appendString:@"\t"];
			if (calcModel.memo != nil) {
				[text appendString:calcModel.memo];
			}
			else {
				[text appendString:@" "];
			}
			[text appendString:@"\t"];
			[text appendString:[calcModel requestDisplayString]];
			[text appendString:@"\t"];
			[text appendString:@"\r\n"];
			i++;
		}
	}
	else {
		//memoなしの場合
		for (CalcModel *calcModel in self.calcsArray) {
			[text appendString:[NSString stringWithFormat:@"%d:", i]];
			[text appendString:@"\t"];
			[text appendString:[calcModel requestDisplayString]];
			[text appendString:@"\t"];
			[text appendString:@"\r\n"];
			i++;
		}
	}

    
	//CSVファイルの作成
	NSURL *csvFileURL = [self exportToCSV];
    
    
	if (csvFileURL != nil) {
		NSArray *activityItems = @[text, csvFileURL];

		//共有アクションシートの呼び出し
		UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
		                                                    initWithActivityItems:activityItems applicationActivities:@[]];
		[self presentViewController:activityViewController animated:YES completion:nil];
	}
    [SVProgressHUD dismiss];
}



/**
   CSVを出力するメソッド
 */
- (NSURL *)exportToCSV {
	NSString *directoryPath = NSTemporaryDirectory();
	NSString *filePath = [directoryPath stringByAppendingPathComponent:@"ListCalcs.csv"];
	NSMutableString *csv = [NSMutableString stringWithCapacity:0];

	//合計
    [csv appendString:@"-"];
    [csv appendString:@","];
	[csv appendString:sumView.functionLabel.text];
	[csv appendString:@","];
	[csv appendString:@"\""];
	[csv appendString:sumView.numberLabel.text];
	[csv appendString:@"\""];
	[csv appendString:@"\r\n"];

    //平均
    [csv appendString:@"-"];
    [csv appendString:@","];
    [csv appendString:averageView.functionLabel.text];
	[csv appendString:@","];
	[csv appendString:@"\""];
	[csv appendString:averageView.numberLabel.text];
	[csv appendString:@"\""];
	[csv appendString:@"\r\n"];

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	int i = 1;
    //共有するテキストの作成(タブ区切り)
	if ([userDefaults boolForKey:@"isMemoSwitchOn"]) {
        //memoありの場合
		for (CalcModel *calcModel in self.calcsArray) {
			[csv appendString:[NSString stringWithFormat:@"%d", i]];
			[csv appendString:@","];
            [csv appendString:@"\""];
            if (calcModel.memo != nil) {
				[csv appendString:calcModel.memo];
			}
            [csv appendString:@"\""];
			[csv appendString:@","];
			[csv appendString:@"\""];
			[csv appendString:[calcModel requestDisplayString]];
			[csv appendString:@"\""];
			[csv appendString:@"\r\n"];
			i++;
		}
	}else {
        //memoなしの場合
        for (CalcModel *calcModel in self.calcsArray) {
			[csv appendString:[NSString stringWithFormat:@"%d", i]];
			[csv appendString:@","];
			[csv appendString:@"\""];
			[csv appendString:[calcModel requestDisplayString]];
			[csv appendString:@"\""];
			[csv appendString:@"\r\n"];
			i++;
		}
    }

	NSLog(@"%@", csv);

	NSError *error;

	if ([csv writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
		return [NSURL fileURLWithPath:filePath];
	}
	else {
		NSLog(@"writeToFile failed: %@", error);
		return nil;
	}
}
@end

/***
 JTGestureBasedTableView
 Copyright (c) 2012 James Tang <mystcolor@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ***/

/***
 SVProgressHUD
 Copyright (c) 2011 Sam Vermette
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 A different license may apply to other ressources included in this package,
 including Joseph Wain's Glyphish Icons. Please consult their
 respective headers for the terms of their individual licenses.
 ***/
