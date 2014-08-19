//
//  MainViewController.h
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import "FlipsideViewController.h"
#import "F53OSC.h"
#import "PatternSelectViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, PatternSelectViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, F53OSCPacketDestination>
{
    F53OSCServer *oscServer;
    F53OSCClient *oscClient;
    
    NSArray *patterns;
    NSMutableArray *params;
    
    IBOutlet UIButton *patternButton;
    IBOutlet UITableView *paramsTableView;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
