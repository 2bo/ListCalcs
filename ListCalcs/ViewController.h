//
//  ViewController.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2013/11/24.
//  Copyright (c) 2013年 Kota_Nakatsubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcKeyboardView.h"
#import "GADBannerView.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate,CalcKeyboardDelegate>{
    GADBannerView *bannerView;
}

@property (retain, nonatomic) NSMutableArray *calcsArray;
@property (retain, nonatomic) NSIndexPath *currentCellIndexPath;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *calcTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


/*
- (IBAction)inputNumber:(id)sender;
//- (IBAction)pushDecimalPointButton:(id)sender;
- (IBAction)pushAddButton:(id)sender;
- (IBAction)pushSubtractionButton:(id)sender;
- (IBAction)pushMultiplicationButton:(id)sender;
- (IBAction)pushDivisionButton:(id)sender;
- (IBAction)pushEqualButton:(id)sender;
- (IBAction)pushClearButton:(id)sender;
- (IBAction)pushDeleteButton:(id)sender;
- (IBAction)pushPlusMinusButton:(id)sender;
- (IBAction)pushPercentButton:(id)sender;
*/

- (void)addCalc:(id)sender;
- (void)allClearCalc;
- (void)showConfirmationActionSheet:(id)sender;

@end
