//
//  MainViewController.m
//  TitanicsEndController
//
//  Created by Ashutosh Desai on 8/19/14.
//  Copyright (c) 2014 Ashutosh Desai. All rights reserved.
//

#import "MainViewController.h"
#import "ParamTableViewCell.h"

@interface MainViewController ()

@end

@implementation MainViewController

int listeningPort = 9001;
int serverPort = 10001;
NSString *serverIP = @"10.0.1.125";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [patternButton setTitle:@"Not Connected" forState:UIControlStateNormal];
    patterns = @[];
    params = [@[] mutableCopy];
    
    oscClient = [[F53OSCClient alloc] init];
    
    oscServer = [[F53OSCServer alloc] init];
    [oscServer setPort:9001];
    [oscServer setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(entering)
												 name:UIApplicationDidBecomeActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(exiting)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
}

- (void)entering
{
    [oscServer startListening];
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/server/connect" arguments:nil];
    [oscClient sendPacket:message toHost:serverIP onPort:serverPort];
}

- (void)exiting
{
    [oscServer stopListening];
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/server/disconnect" arguments:nil];
    [oscClient sendPacket:message toHost:serverIP onPort:serverPort];
}

- (void)selectedPatternAtIndex:(int)index
{
    [self.navigationController popViewControllerAnimated:YES];
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/server/changepattern" arguments:@[@(index)]];
    [oscClient sendPacket:message toHost:serverIP onPort:serverPort];
}

- (void)takeMessage:(F53OSCMessage *)message {
    
    NSString *addressPattern = message.addressPattern;
    NSArray *arguments = message.arguments;
    
    if ([addressPattern isEqualToString:@"/broadcast/state"])
    {
        patterns = @[];
        params = [@[] mutableCopy];
        
        for (int i = 0; i < [arguments count]; i++)
        {
            id arg = arguments[i];
            if ([arg isKindOfClass:[NSString class]])
            {
                NSString *status = (NSString*)arg;
                if ([status isEqualToString:@"active pattern"])
                {
                    [patternButton setTitle:arguments[i+1] forState:UIControlStateNormal];
                    i++;
                }
                else if ([status isEqualToString:@"begin param"])
                {
                    [params addObject:@{@"name":arguments[i+1], @"value":arguments[i+2], @"min":arguments[i+3], @"max":arguments[i+4]}];
                    i+=4;
                }
                else if ([status isEqualToString:@"all patterns"])
                {
                    NSRange range;
                    range.location = i+1;
                    range.length = [arguments count] - i - 1;
                    patterns = [arguments subarrayWithRange:range];
                    i = [arguments count];
                }
            }
        }
        [paramsTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)setIP:(NSString *)ip
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [patternButton setTitle:@"Not Connected" forState:UIControlStateNormal];
    patterns = @[];
    params = [@[] mutableCopy];
    
    serverIP = ip;
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/server/connect" arguments:nil];
    [oscClient sendPacket:message toHost:serverIP onPort:serverPort];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"patternSelectSegue"])
        [(PatternSelectViewController *)segue.destinationViewController setPatterns:patterns];
    else if ([segue.identifier isEqualToString:@"ipSettingSegue"])
        [(FlipsideViewController *)segue.destinationViewController setServerIP:serverIP];
    
    [[segue destinationViewController] setDelegate:self];
}

#pragma mark - Table View Controller

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//Set number of rows based on arrays of games (filtered in tabBarController)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [params count];
}

//Since our cells are custom cells, we need to return the height of each row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 94.f;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Create cell as TableViewCell, our custom cell class
	NSString *CellIdentifier;
	ParamTableViewCell *cell;
	
	CellIdentifier = @"Cell";
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ParamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	}

    NSDictionary *paramDict = params[indexPath.row];
    cell.slider.tag = indexPath.row;
    cell.slider.minimumValue = [paramDict[@"min"] floatValue];
    cell.slider.maximumValue = [paramDict[@"max"] floatValue];
    cell.slider.value = [paramDict[@"value"] floatValue];
    cell.name.text = paramDict[@"name"];
    
    float f = [paramDict[@"value"] floatValue];
    int digits = 0;
    if (f < 1)
        digits = 2;
    else if (f < 10)
        digits = 1;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:digits];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    cell.value.text = [formatter stringFromNumber:paramDict[@"value"]];
	
    return cell;
}

- (void)sliderChanged:(id)sender {
    UISlider *slider = (UISlider*)sender;
    NSString *paramName = params[slider.tag][@"name"];
    NSNumber *paramValue = @(slider.value);
    
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:@"/server/changeparam" arguments:@[paramName, paramValue]];
    [oscClient sendPacket:message toHost:serverIP onPort:serverPort];
}

@end
