//
//  FlipsideViewController.h
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)setIP:(NSString*)ip;
@end

@interface FlipsideViewController : UIViewController
{
    IBOutlet UITextField *ip;
    IBOutlet UILabel *ipLabel;
}

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *serverIP;

@end
