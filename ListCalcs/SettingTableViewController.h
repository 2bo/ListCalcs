//
//  SettingTableViewController.h
//  ListCalc
//
//  Created by Kota_Nakatsubo on 2014/07/07.
//  Copyright (c) 2014年 Kota_Nakatsubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *memoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *clickSoundSwitch;

- (IBAction)pushDoneButton:(id)sender;


- (IBAction)changeMemoSwitch:(id)sender;
- (IBAction)changeClickSoundSwitch:(id)sender;

@end
