//
//  ParamTableViewCell.h
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParamTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *value;
@property (nonatomic, strong) UISlider *slider;

@end
