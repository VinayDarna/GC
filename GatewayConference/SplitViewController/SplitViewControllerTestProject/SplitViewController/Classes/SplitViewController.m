    //
//  SplitViewController.m
//  steuerapp
//
//  Created by Bernhard Häussermann on 2011/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SplitViewController.h"
#import "MyImageView.h"


@implementation SplitViewController

@synthesize
    menuViewController,
    detailViewController,
    hideMenuViewControllerInPortraitOrientation,
    menuViewControllerHiddenLeftButtonsImage,
    listButtonTitle;

#define NAVIGATION_BAR_BUTTON_ITEM_GAP 7
#define TOOL_BAR_BUTTON_ITEM_GAP 9
#define BACK_BAR_BUTTON_ITEM_WIDTH_OFFSET 26
#define BACK_BAR_BUTTON_ITEM_FONT [UIFont fontWithName:@"Helvetica-Bold" size:12]

- (UIViewController*)menuViewController
{
    return menuViewController;
}

- (void) setMenuViewController:(UIViewController*) newMenuViewController
{
    [newMenuViewController retain];
    [menuViewController release];
    [menuViewController.view removeFromSuperview];
    menuViewController = newMenuViewController;
    if ([menuViewController respondsToSelector:@selector(setSplitViewController:)])
        [menuViewController performSelector:@selector(setSplitViewController:) withObject:self];
}

- (UIViewController*)detailViewController
{
    return detailViewController;
}

- (void) setDetailViewControllerr:(UIViewController*) newDetailViewController
{
    [newDetailViewController retain];
    [detailViewController release];
    [detailViewController.view removeFromSuperview];
    detailViewController = newDetailViewController;
    if ([detailViewController respondsToSelector:@selector(setSplitViewController:)])
        [detailViewController performSelector:@selector(setSplitViewController:) withObject:self];
}

- (int) splitPoint
{
    return splitPoint ? splitPoint : ((int) viewSplitter.center.x ? (int) viewSplitter.center.x : -menuViewController.view.center.x * 2);
}

- (void) setSplitPoint:(int) newSplitPoint
{
    splitPoint = newSplitPoint;
}


- (id)init 
{
    return [self initWithNibName:@"SplitView" bundle:nil];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        splitPoint = 0;
        hideMenuViewControllerInPortraitOrientation = NO;
        didLoad = NO;
        menuViewHidden = NO;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

+ (BOOL) isInPortraitOrientation
{
    return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
}

+ (CGFloat) widthOfBarButtonItem:(UIBarButtonItem*) barButtonItem
{
    UIView* view = [barButtonItem valueForKey:@"view"];
    return view.frame.size.width;
}

- (BOOL) hasBackButton
{
    return self.navigationController.viewControllers.count>=2;
}


- (void) showList
{
    [sideViewPopOver release];
    sideViewPopOver = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:menuViewController];
    
    // Determine the horizontal location-offset for the arrow of the popover controller. 
    CGFloat backBarButtonItemOffset = 0;
    if (([self hasBackButton]) && (([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) || (! menuViewHidden) || (! menuViewControllerHiddenLeftButtonsImage)))
        backBarButtonItemOffset = [[[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] title] sizeWithFont:BACK_BAR_BUTTON_ITEM_FONT].width + BACK_BAR_BUTTON_ITEM_WIDTH_OFFSET;
    CGFloat arrowCenterX = backBarButtonItemOffset + [SplitViewController widthOfBarButtonItem:listButton]/2 + (toolbarListButton ? TOOL_BAR_BUTTON_ITEM_GAP : NAVIGATION_BAR_BUTTON_ITEM_GAP);
    if ((toolbar) && (toolbarListButton))
    {
        for (UIBarButtonItem* nextItem in toolbar.items)
        {
            if (nextItem==toolbarListButton)
                break;
            arrowCenterX+=[SplitViewController widthOfBarButtonItem:nextItem] + TOOL_BAR_BUTTON_ITEM_GAP;
        }
    }
    else if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)])
        for (UIBarButtonItem* nextItem in leftNavigationBarButtonItems)
            arrowCenterX+=[SplitViewController widthOfBarButtonItem:nextItem] + NAVIGATION_BAR_BUTTON_ITEM_GAP;
    if (! [self.navigationItem respondsToSelector:@selector(setLeftBarButtonItems:animated:)])
        arrowCenterX+=[SplitViewController widthOfBarButtonItem:listButton] / 4;
    
    [sideViewPopOver presentPopoverFromRect:CGRectMake(arrowCenterX - 10,toolbar ? toolbar.frame.origin.y + toolbar.frame.size.height : 0,20,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void) imageView:(UIImageView*) imageView pressedWithTouches:(NSSet*) touches
{
    if ([[touches anyObject] locationInView:imageView].x<imageView.frame.size.width / 2)
    {
        if ([self hasBackButton])
            [self.navigationController popViewControllerAnimated:YES];
        else
        {
            UIBarButtonItem* barButtonItem = [leftNavigationBarButtonItems objectAtIndex:0];
            [barButtonItem.target performSelector:barButtonItem.action];
        }
    }
    else
        [self showList];
}

- (UIBarButtonItem*) createListButton
{
    return [[UIBarButtonItem alloc] initWithTitle:listButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(showList)];
}

- (void) hideMenuViewController
{
    // Set side-view and main-view locations.
    CGPoint center = menuViewController.view.center;
    center.x-=splitPoint;
    menuViewController.view.center = center;
    center = viewSplitter.center;
    center.x-=splitPoint;
    viewSplitter.center = center;
    CGRect frame = detailViewController.view.frame;
    frame.origin.x-=splitPoint;
    frame.size.width+=splitPoint;
    detailViewController.view.frame = frame;
    
    // Display list-button.
    listButton = nil;
    if (toolbarListButton)
    {
        toolbarListButton.width = toolbarListButtonWidth;
        listButton = [toolbarListButton retain];
    }
    // If the navigation bar has a bar button on the left...
    else if ((leftNavigationBarButtonItems.count) || ([self hasBackButton]))
    {
        if ([self.navigationItem respondsToSelector:@selector(setLeftBarButtonItems:animated:)])
        {
            if ([self hasBackButton])
                [self.navigationItem performSelector:@selector(setLeftItemsSupplementBackButton:) withObject:(id) YES];
            listButton = [self createListButton];
            if (leftNavigationBarButtonItems)
                [self.navigationItem setLeftBarButtonItems:[leftNavigationBarButtonItems arrayByAddingObject:listButton] animated:YES];
            else
                [self.navigationItem setLeftBarButtonItem:listButton animated:YES];
        }
        // Prior to iOS 5, only one button could be displayed on the left side of a navigation bar - this is a work-around for earlier versions.
        else if (menuViewControllerHiddenLeftButtonsImage)
        {
            MyImageView* imageView = [[MyImageView alloc] initWithImage:menuViewControllerHiddenLeftButtonsImage];
            imageView.delegate = self;
            imageView.selector = @selector(imageView:pressedWithTouches:);
            listButton = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            [self.navigationItem setLeftBarButtonItem:listButton animated:YES];
            [imageView release];
        }
        else
            NSLog(@"Warning: cannot display list-button since menuViewControllerHiddenLeftButtonsImage is not specified!");
    }
    else
    {
        listButton = [self createListButton];
        [self.navigationItem setLeftBarButtonItem:listButton animated:YES];
    }
    [listButton release];
    menuViewHidden = YES;
}

- (void) showMenuViewController
{
    // Set side-view and main-view locations.
    CGPoint center = viewSplitter.center;
    center.x+=splitPoint;
    viewSplitter.center = center;
    center = menuViewController.view.center;
    center.x+=splitPoint;
    menuViewController.view.center = center;
    CGRect frame = detailViewController.view.frame;
    frame.origin.x+=splitPoint;
    frame.size.width-=splitPoint;
    detailViewController.view.frame = frame;

    // Hide/Remove list-button.
    if (toolbarListButton)
    {
        toolbarListButtonWidth = toolbarListButton.width;
        toolbarListButton.width = 0.1;
    }
    else if (leftNavigationBarButtonItems.count)
    {
        if ([self.navigationItem respondsToSelector:@selector(setLeftBarButtonItems:animated:)])
            [self.navigationItem performSelector:@selector(setLeftBarButtonItems:animated:) withObject:leftNavigationBarButtonItems withObject:(id) YES];
        else
            [self.navigationItem setLeftBarButtonItem:[leftNavigationBarButtonItems objectAtIndex:0] animated:YES];
    }
    else
        self.navigationItem.leftBarButtonItem = nil;
    menuViewHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    didLoad = YES;
    // Place the two content views now that the viewSplitter IBOutlet has been set properly.
    if (splitPoint)
    {
        CGPoint center = viewSplitter.center;
        center.x = splitPoint;
        viewSplitter.center = center;
    }
    else
        splitPoint = viewSplitter.center.x;
    
    menuViewController.view.frame = CGRectMake(0,viewSplitter.frame.origin.y,viewSplitter.frame.origin.x,viewSplitter.frame.size.height);
    menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:menuViewController.view];
    detailViewController.view.frame = CGRectMake(viewSplitter.frame.origin.x + 1,viewSplitter.frame.origin.y,self.view.frame.size.width - viewSplitter.frame.origin.x - 1,viewSplitter.frame.size.height);
    detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:detailViewController.view];
    
    if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)])
        leftNavigationBarButtonItems = [[self.navigationItem performSelector:@selector(leftBarButtonItems)] retain];
    else if ([self.navigationItem leftBarButtonItem])
        leftNavigationBarButtonItems = [[NSArray alloc] initWithObjects:[self.navigationItem leftBarButtonItem],nil];
    
    if (toolbarListButton)
    {
        toolbarListButton.target = self;
        toolbarListButton.action = @selector(showList);
        toolbarListButtonWidth = toolbarListButton.width;
        toolbarListButton.width = 0.1;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [menuViewController viewWillAppear:animated];
    [detailViewController viewWillAppear:animated];
    
    if (hideMenuViewControllerInPortraitOrientation)
    {
        if (([SplitViewController isInPortraitOrientation]) && (! menuViewHidden))
        {
            [self hideMenuViewController];
            [menuViewController.view removeFromSuperview];
        }
        else if ((! [SplitViewController isInPortraitOrientation]) && (menuViewHidden))
        {
            [self.view addSubview:menuViewController.view];
            menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
            menuViewController.view.frame = CGRectMake(-splitPoint,viewSplitter.frame.origin.y,splitPoint,viewSplitter.frame.size.height);
            [self showMenuViewController];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [menuViewController viewWillDisappear:animated];
    [detailViewController viewWillDisappear:animated];
    
    if (sideViewPopOver)
    {
        [sideViewPopOver dismissPopoverAnimated:YES];
        [sideViewPopOver release];
        sideViewPopOver = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [menuViewController viewDidAppear:animated];
    [detailViewController viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [menuViewController viewDidDisappear:animated];
    [detailViewController viewDidDisappear:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return ([menuViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation]) && ([detailViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation]);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval) duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (! didLoad)
        return;
    [menuViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [detailViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (hideMenuViewControllerInPortraitOrientation)
    {
        if ((UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) && ((int) viewSplitter.center.x!=0))
        {
            [UIView beginAnimations:@"hideSideView" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didStop:finished:context:)];
            [UIView setAnimationDuration:duration];
            [self hideMenuViewController];
            [UIView commitAnimations];
        }
        else if ((UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) && ((int) viewSplitter.center.x==0))
        {
            if (sideViewPopOver)
            {
                [sideViewPopOver dismissPopoverAnimated:YES];
                [sideViewPopOver release];
                sideViewPopOver = nil;
            }  
            [self.view addSubview:menuViewController.view];
            menuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
            menuViewController.view.frame = CGRectMake(-splitPoint,viewSplitter.frame.origin.y,splitPoint,viewSplitter.frame.size.height);
            [UIView beginAnimations:@"showSideView" context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didStop:finished:context:)];
            [UIView setAnimationDuration:duration];
            [self showMenuViewController];
            [UIView commitAnimations];
        }
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [detailViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void) didStop:(NSString*) animationName finished:(BOOL) didFinish context:(void*) theContext
{
    if ([animationName isEqualToString:@"hideSideView"])
        [menuViewController.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [menuViewController release];
    [detailViewController release];
    [leftNavigationBarButtonItems release];
    [toolbarListButton release];
    self.menuViewControllerHiddenLeftButtonsImage = nil;
    self.listButtonTitle = nil;
    [sideViewPopOver release];
    
    [super dealloc];
}


@end
