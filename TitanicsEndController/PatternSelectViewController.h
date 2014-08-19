//
//  PatternSelectViewController.h
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatternSelectViewControllerDelegate
- (void)selectedPatternAtIndex:(int)index;
@end

@interface PatternSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *patternTableView;
}

@property (nonatomic, strong) NSArray *patterns;
@property (weak, nonatomic) id <PatternSelectViewControllerDelegate> delegate;

@end
