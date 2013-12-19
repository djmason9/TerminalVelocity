//
//  StatsTableViewController.m
//  TerminalVelocity
//
//  Created by Darren Mason on 10/3/11.
//  Copyright (c) 2011 Dark Energy Studios. All rights reserved.
//

#import "StatsTableViewController.h"
#import "CCLabelBMFont.h"
#import "PlayerDetails.h"
@implementation StatsTableViewController
@synthesize statsArray;

-(void)dealloc
{
    [super dealloc];
    [statsArray release];

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

   // statsArray = [[NSArray alloc] initWithObjects:@"1. Darren ------- 20000",@"2. Aaron ------- 20000",@"3. Mason ------- 20000",@"4. Hudson ------- 20000", nil];
    // delegate = [[StatsDelegate alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.statsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        PlayerDetails *pd = [statsArray objectAtIndex:indexPath.row];
        

        
        NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
        
        //Set the required date format
        
        [formatter setDateFormat:@"MM/dd/yy"];
        
        //Get the string date
        
        NSString *dt = [formatter stringFromDate: pd.date];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width*.8, 20)];
        lblDate.text = dt;
        lblDate.font = [UIFont boldSystemFontOfSize:14];
        lblDate.textAlignment = UITextAlignmentRight;
        [lblDate setTextColor:[ UIColor whiteColor]];
        lblDate.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblDate];
        [lblDate release];
        
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle]; 
        NSString *formatedScoreNoPointsText =[numberFormatter stringFromNumber:pd.score];
        
        
        UILabel *lblScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width*.8, 20)];
        lblScore.text = formatedScoreNoPointsText;//[NSString stringWithFormat:@"%i", score.value];
        lblScore.font = [UIFont boldSystemFontOfSize:14];
        lblScore.textAlignment = UITextAlignmentCenter;
        [lblScore setTextColor:[ UIColor whiteColor]];
        lblScore.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblScore];
        [lblScore release];
        
        
        UILabel *lblAlias = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width*.8, 20)];
        lblAlias.text = pd.alias;
        lblAlias.font = [UIFont boldSystemFontOfSize:14];
        [lblAlias setTextColor:[ UIColor whiteColor]];
        lblAlias.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:lblAlias];
        [lblAlias release];
    //}
    return cell;
}


@end
