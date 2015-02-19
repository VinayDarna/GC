//
//  MainMenuViewController.m
//  SplitViewControllerTestProject
//
//  Created by Bernhard Häussermann on 2011/12/15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MainMenuViewController.h"
#import "NavigationMenuViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"


@implementation MainMenuViewController

@synthesize detailViewController;


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 ? 5 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.section==0)
        cell.textLabel.text = [NSString stringWithFormat:@"Row %i",indexPath.row + 1];
    else
        cell.textLabel.text = indexPath.row==0 ? @"Show navigation view controller..." : @"Show toolbar view controller...";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void) dismissModalView
{
    UIViewController* topViewController = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).topViewController;
    [topViewController dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        detailViewController.displayText = [NSString stringWithFormat:@"Row %i",indexPath.row + 1];
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIViewController* modalViewController;
        if (indexPath.row==0)
        {
            SplitViewController* nextSplitViewController = [[SplitViewController alloc] init];
            nextSplitViewController.title = @"Navigation View Splitter";
            nextSplitViewController.hideSideViewControllerInPortraitOrientation = YES;
            nextSplitViewController.listButtonTitle = @"Items";
            nextSplitViewController.sideViewControllerHiddenLeftButtonsImage = [UIImage imageNamed:@"back_items.png"];
            DetailViewController* mainViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
            nextSplitViewController.mainViewController = mainViewController;
            NavigationMenuViewController* sideViewController = [[NavigationMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
            nextSplitViewController.sideViewController = sideViewController;
            sideViewController.detailViewController = mainViewController;
            sideViewController.contentSizeForViewInPopover = CGSizeMake(320,320);
            [mainViewController release];
            [sideViewController release];
            
            UINavigationController* modalNavController = [[UINavigationController alloc] initWithRootViewController:nextSplitViewController];
            [nextSplitViewController release];
            UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissModalView)];
            modalNavController.navigationBar.topItem.leftBarButtonItem = backButtonItem;
            [backButtonItem release];
            modalViewController = modalNavController;
            modalViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        else
        {
            SplitViewController* nextSplitViewController = [[SplitViewController alloc] initWithNibName:@"ToolbarSplitView" bundle:nil];
            nextSplitViewController.title = @"Toolbar View Splitter";
            nextSplitViewController.hideSideViewControllerInPortraitOrientation = YES;
            DetailViewController* mainViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
            nextSplitViewController.mainViewController = mainViewController;
            MenuViewController* sideViewController = [[MenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
            nextSplitViewController.sideViewController = sideViewController;
            sideViewController.detailViewController = mainViewController;
            sideViewController.contentSizeForViewInPopover = CGSizeMake(320,320);
            [mainViewController release];
            [sideViewController release];
            
            for (UIBarButtonItem* nextItem in ((UIToolbar*) [nextSplitViewController.view viewWithTag:15]).items)
            {
                if (nextItem.tag==15)
                {
                    // Found back-button.
                    nextItem.target = self;
                    nextItem.action = @selector(dismissModalView);
                }
                else if (nextItem.tag==16)
                {
                    // Found greet button.
                    nextItem.target = mainViewController;
                    nextItem.action = @selector(sayHi);
                }
            }
            modalViewController = nextSplitViewController;
        }
        UIViewController* topViewController = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).topViewController;
        [topViewController presentModalViewController:modalViewController animated:YES];
        [modalViewController release];
    }
}

- (void)dealloc 
{
    self.detailViewController = nil;
    
    [super dealloc];
}

@end
