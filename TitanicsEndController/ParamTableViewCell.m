//
//  ParamTableViewCell.m
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import "ParamTableViewCell.h"

@implementation ParamTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 120, 22)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.f];
        self.value = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 120, 22)];
        self.value.textColor = [UIColor whiteColor];
        self.value.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.f];
        self.value.textAlignment = NSTextAlignmentRight;
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 44, 240, 22)];
        [self addSubview:self.slider];
        [self addSubview:self.name];
        [self addSubview:self.value];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
