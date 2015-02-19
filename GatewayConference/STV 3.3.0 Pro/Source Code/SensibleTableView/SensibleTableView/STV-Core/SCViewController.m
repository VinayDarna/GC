/*
 *  SCViewController.m
 *  Sensible TableView
 *  Version: 3.3.0
 *
 *
 *	THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY UNITED STATES 
 *	INTELLECTUAL PROPERTY LAW AND INTERNATIONAL TREATIES. UNAUTHORIZED REPRODUCTION OR 
 *	DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES. YOU SHALL NOT DEVELOP NOR
 *	MAKE AVAILABLE ANY WORK THAT COMPETES WITH A SENSIBLE COCOA PRODUCT DERIVED FROM THIS 
 *	SOURCE CODE. THIS SOURCE CODE MAY NOT BE RESOLD OR REDISTRIBUTED ON A STAND ALONE BASIS.
 *
 *	USAGE OF THIS SOURCE CODE IS BOUND BY THE LICENSE AGREEMENT PROVIDED WITH THE 
 *	DOWNLOADED PRODUCT.
 *
 *  Copyright 2012-2013 Sensible Cocoa. All rights reserved.
 *
 *
 *	This notice may not be removed from this file.
 *
 */


#import "SCViewController.h"
#import "SCTableViewModel.h"
#import "SCGlobals.h"




@interface SCViewController ()
{
    __weak id _delegate;
	SCTableViewModel *_tableViewModel;
	SCNavigationBarType _navigationBarType;
	UIBarButtonItem *_addButton;
	UIBarButtonItem *_cancelButton;
	UIBarButtonItem *_doneButton;
	BOOL _cancelButtonTapped;
	BOOL _doneButtonTapped;
    UIPopoverController *_popoverController;
    SCViewControllerActions *_actions;
    SCViewControllerState _state;
    BOOL _hasFocus;
}

@end



@implementation SCViewController

@synthesize tableView = _tableView;
@synthesize tableViewModel = _tableViewModel;
@synthesize delegate = _delegate;
@synthesize navigationBarType = _navigationBarType;
@synthesize addButton = _addButton;
@synthesize cancelButton = _cancelButton;
@synthesize allowEditingModeCancelButton = _allowEditingModeCancelButton;
@synthesize doneButton = _doneButton;
@synthesize cancelButtonTapped = _cancelButtonTapped;
@synthesize doneButtonTapped = _doneButtonTapped;
@synthesize popoverController = _popoverController;
@synthesize actions = _actions;
@synthesize state = _state;
@synthesize hasFocus = _hasFocus;


- (id)init
{
	if( (self = [super init]) )
	{
		[self performInitialization];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if( (self = [super initWithCoder:aDecoder]) ) 
	{
		[self performInitialization];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
	{
		[self performInitialization];
	}
	
	return self;
}

- (void)dealloc
{
    if([SCModelCenter sharedModelCenter].keyboardIssuer == self)
        [SCModelCenter sharedModelCenter].keyboardIssuer = nil;
}

- (void)performInitialization
{
    _delegate = nil;
    _tableView = nil;
    _tableViewModel = [[SCTableViewModel alloc] init];
    _navigationBarType = SCNavigationBarTypeAuto;
    _addButton = nil;
    _cancelButton = nil;
    _allowEditingModeCancelButton = TRUE;
    _doneButton = nil;
    
    _popoverController = nil;
    
    _cancelButtonTapped = FALSE;
    _doneButtonTapped = FALSE;
    _state = SCViewControllerStateNew;
    _hasFocus = FALSE;
    
    _actions = [[SCViewControllerActions alloc] init];
}


- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    if(!_tableView.superview)
        [self.view addSubview:_tableView];
    
    self.tableViewModel.tableView = tableView;
}

- (void)setTableViewModel:(SCTableViewModel *)model
{
    // Preserve the detailViewController when applicable
    if(_tableViewModel.detailViewController && !model.detailViewController)
        model.detailViewController = _tableViewModel.detailViewController;
    
    _tableViewModel = model;
    
    _tableViewModel.tableView = self.tableView;
    _tableViewModel.editButtonItem = self.editButton;
    if([_tableViewModel isKindOfClass:[SCArrayOfItemsModel class]] && self.addButton)
        [(SCArrayOfItemsModel *)_tableViewModel setAddButtonItem:self.addButton];
}

- (void)setPopoverController:(UIPopoverController *)popover
{
    _popoverController = popover;
    
    _popoverController.delegate = self;
}


- (void)loadView
{
    [super loadView];
    
    self.tableViewModel.tableView = self.tableView;
    [self.tableViewModel styleViews];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    if(_state != SCViewControllerStateNew)
		_state = SCViewControllerStateActive;
	
    if(_state == SCViewControllerStateNew)
    {
        if(self.tableViewModel.masterModel)
        {
            // Inherit owner's background
            if(self.tableView.style!=UITableViewStylePlain && self.tableViewModel.masterModel.tableView.style!=UITableViewStylePlain)
            {
                self.tableView.backgroundColor = self.tableViewModel.masterModel.tableView.backgroundColor;
            }
        }
        
        [self.tableViewModel styleViews];
    }
	
	_cancelButtonTapped = FALSE;
	_doneButtonTapped = FALSE;
	
    if(self.actions.willAppear)
        self.actions.willAppear(self);
    
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerWillAppear:)])
	{
		[self.delegate viewControllerWillAppear:self];
	}
    
    if(self.state == SCViewControllerStateNew)
    {
        if(self.actions.willPresent)
            self.actions.willPresent(self);
        
        if([self.delegate conformsToProtocol:@protocol(SCTableViewControllerDelegate)]
           && [self.delegate respondsToSelector:@selector(viewControllerWillPresent:)])
        {
            [self.delegate viewControllerWillPresent:self];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
    if(self.tableViewModel)
		self.tableViewModel.commitButton = self.doneButton;
	
    if(self.actions.didAppear)
        self.actions.didAppear(self);
    
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerDidAppear:)])
	{
		[self.delegate viewControllerDidAppear:self];
	}
    
    if(self.state == SCViewControllerStateNew)
    {
        if(self.actions.didPresent)
            self.actions.didPresent(self);
        
        if([self.delegate conformsToProtocol:@protocol(SCTableViewControllerDelegate)]
           && [self.delegate respondsToSelector:@selector(viewControllerDidPresent:)])
        {
            [self.delegate viewControllerDidPresent:self];
        }
    }
    
    _state = SCViewControllerStateActive;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
    if(_state != SCViewControllerStateDismissed)  // could be set by the controller's buttons
    {
        if(self.navigationController)
        {
            if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
            {
                // self has been popped from the navigation controller
                _state = SCViewControllerStateDismissed;
            }
            else 
            {
                _state = SCViewControllerStateInactive;
            }
        }
        
        // When there is no navigationController, the view controller will be dismissed using the cancelButton and thus will have the correct state.
    }
    
    if(self.actions.willDisappear)
        self.actions.willDisappear(self);
    
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerWillDisappear:)])
	{
		[self.delegate viewControllerWillDisappear:self];
	}
    
    if(self.state == SCViewControllerStateDismissed)
    {
        if(self.actions.willDismiss)
            self.actions.willDismiss(self);
        
        if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
           && [self.delegate respondsToSelector:@selector(viewControllerWillDismiss:cancelButtonTapped:doneButtonTapped:)])
        {
            [self.delegate viewControllerWillDismiss:self cancelButtonTapped:self.cancelButtonTapped doneButtonTapped:self.doneButtonTapped];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
    if(self.actions.didDisappear)
        self.actions.didDisappear(self);
    
	if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
	   && [self.delegate respondsToSelector:@selector(viewControllerDidDisappear:)])
	{
		[self.delegate viewControllerDidDisappear:self];
	}
    
    if(self.state == SCViewControllerStateDismissed)
    {
        if(self.actions.didDismiss)
            self.actions.didDismiss(self);
        
        if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
           && [self.delegate respondsToSelector:@selector(viewControllerDidDismiss:cancelButtonTapped:doneButtonTapped:)])
        {
            [self.delegate viewControllerDidDismiss:self cancelButtonTapped:self.cancelButtonTapped doneButtonTapped:self.doneButtonTapped];
        }
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask interfaceOrientations;
    
    if(self.tableViewModel.masterModel)
    {
        interfaceOrientations = [self.tableViewModel.masterModel.viewController supportedInterfaceOrientations];
    }
    else
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            interfaceOrientations = UIInterfaceOrientationMaskPortrait;
        }
        else
        {
            interfaceOrientations = [super supportedInterfaceOrientations];
        }
    }
    
    return interfaceOrientations;
}




- (void)setNavigationBarType:(SCNavigationBarType)barType
{
	_navigationBarType = barType;
	
    UINavigationItem *navItem = self.navigationItem;
    
	// Reset buttons
	_addButton = nil;
	_cancelButton = nil;
	_doneButton = nil;
    if(!navItem.backBarButtonItem)
        navItem.leftBarButtonItem = nil;
    navItem.rightBarButtonItem = nil;
    
    // Setup self.editButton
    self.editButton.target = self;
    self.editButton.action = @selector(editButtonAction);
	
	if(navItem && _navigationBarType!=SCNavigationBarTypeNone)
	{
		UIBarButtonItem *tempAddButton = [[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
										  target:nil 
										  action:nil];
		UIBarButtonItem *tempCancelButton = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											 target:self 
											 action:@selector(cancelButtonAction)];
		UIBarButtonItem *tempDoneButton = [[UIBarButtonItem alloc] 
										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
										   target:self 
										   action:@selector(doneButtonAction)];
		
		switch (_navigationBarType)
		{
			case SCNavigationBarTypeAddLeft:
				navItem.leftBarButtonItem = tempAddButton;
				_addButton = tempAddButton;
				break;
			case SCNavigationBarTypeAddRight:
				navItem.rightBarButtonItem = tempAddButton;
				_addButton = tempAddButton;
				break;
			case SCNavigationBarTypeEditLeft:
				navItem.leftBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeEditRight:
				navItem.rightBarButtonItem = self.editButton;
                _cancelButton = tempCancelButton;
                _cancelButton.action = @selector(editingModeCancelButtonAction);
				break;
			case SCNavigationBarTypeAddRightEditLeft:
				navItem.rightBarButtonItem = tempAddButton;
				_addButton = tempAddButton;
				navItem.leftBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeAddLeftEditRight:
				navItem.leftBarButtonItem = tempAddButton;
				_addButton = tempAddButton;
				navItem.rightBarButtonItem = self.editButton;
				break;
			case SCNavigationBarTypeDoneLeft:
				navItem.leftBarButtonItem = tempDoneButton;
				_doneButton = tempDoneButton;
				break;
			case SCNavigationBarTypeDoneRight:
				navItem.rightBarButtonItem = tempDoneButton;
				_doneButton = tempDoneButton;
				break;
			case SCNavigationBarTypeDoneLeftCancelRight:
				navItem.leftBarButtonItem = tempDoneButton;
				_doneButton = tempDoneButton;
				navItem.rightBarButtonItem = tempCancelButton;
				_cancelButton = tempCancelButton;
				break;
			case SCNavigationBarTypeDoneRightCancelLeft:
				navItem.rightBarButtonItem = tempDoneButton;
				_doneButton = tempDoneButton;
				navItem.leftBarButtonItem = tempCancelButton;
				_cancelButton = tempCancelButton;
				break;
			case SCNavigationBarTypeAddEditRight:
			{
				_addButton = tempAddButton;
				_addButton.style = UIBarButtonItemStyleBordered;
				
				// create an array of the buttons
                NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
                [buttons addObject:self.editButton];
                [buttons addObject:_addButton];
                
                navItem.rightBarButtonItems = buttons;
			}
				break;
                
			default:
				break;
		}
	}
}

- (UIBarButtonItem *)editButton
{
	return [self editButtonItem];
}

- (void)cancelButtonAction
{
    BOOL acceptTap = TRUE;
    if(self.actions.cancelButtonTapped)
    {
        acceptTap = self.actions.cancelButtonTapped(self);
    }
    if(!acceptTap)
        return;
    
	[self dismissWithCancelValue:TRUE doneValue:FALSE];
}

- (void)doneButtonAction
{
    BOOL acceptTap = TRUE;
    if(self.actions.doneButtonTapped)
    {
        acceptTap = self.actions.doneButtonTapped(self);
    }
    if(!acceptTap)
        return;
    
	[self dismissWithCancelValue:FALSE doneValue:TRUE];
}

- (void)editButtonAction
{
    if(self.tableViewModel.swipeToDeleteActive)
    {
        [self.tableViewModel setTableViewEditing:NO animated:TRUE];
        return;
    }
    
    BOOL editing = !self.tableView.editing;
    BOOL acceptTap = TRUE;
    if(editing)
    {
        if(self.actions.editButtonTapped)
        {
            acceptTap = self.actions.editButtonTapped(self);
        }
    }
    else
    {
        if(self.actions.doneButtonTapped)
        {
            acceptTap = self.actions.doneButtonTapped(self);
        }
    }
    if(!acceptTap)
        return;
    
    if(self.navigationBarType == SCNavigationBarTypeEditRight)
    {
        if(editing)
        {
            [self.navigationItem setHidesBackButton:TRUE animated:FALSE];
            
            SCTableViewSection *section = nil;
            if(self.tableViewModel.sectionCount)
                section = [self.tableViewModel sectionAtIndex:0];
            if(self.allowEditingModeCancelButton && ![section isKindOfClass:[SCArrayOfItemsSection class]])
                self.navigationItem.leftBarButtonItem = self.cancelButton;
            
            self.tableViewModel.commitButton = self.editButton;
        }
        else
        {
            self.tableViewModel.commitButton = nil;
            self.editButton.enabled = TRUE;  // in case user taps 'Cancel' while button disabled
            
            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setHidesBackButton:FALSE animated:FALSE];
            
            if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
               && [self.delegate respondsToSelector:@selector(viewControllerDidExitEditingMode:cancelButtonTapped:doneButtonTapped:)])
            {
                [self.delegate viewControllerDidExitEditingMode:self cancelButtonTapped:NO doneButtonTapped:YES];
            }
        }
    }
    
    [self.tableViewModel setTableViewEditing:editing animated:TRUE];
}

- (void)editingModeCancelButtonAction
{
    BOOL acceptTap = TRUE;
    if(self.actions.cancelButtonTapped)
    {
        acceptTap = self.actions.cancelButtonTapped(self);
    }
    if(!acceptTap)
        return;
    
	self.navigationItem.leftBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:FALSE animated:FALSE];
    
    for(NSInteger i=0; i<self.tableViewModel.sectionCount; i++)
    {
        SCTableViewSection *section = [self.tableViewModel sectionAtIndex:i];
        [section reloadBoundValues];
    }
    [self.tableViewModel setTableViewEditing:FALSE animated:TRUE];
    
    if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
       && [self.delegate respondsToSelector:@selector(viewControllerDidExitEditingMode:cancelButtonTapped:doneButtonTapped:)])
    {
        [self.delegate viewControllerDidExitEditingMode:self cancelButtonTapped:YES doneButtonTapped:NO];
    }
}

- (void)dismissWithCancelValue:(BOOL)cancelValue doneValue:(BOOL)doneValue
{
    BOOL shouldDismiss = TRUE;
    if([self.delegate conformsToProtocol:@protocol(SCTableViewControllerDelegate)]
	   && [self.delegate respondsToSelector:
		   @selector(viewControllerShouldDismiss:cancelButtonTapped:doneButtonTapped:)])
	{
		shouldDismiss = [self.delegate viewControllerShouldDismiss:self
                                                     cancelButtonTapped:cancelValue
                                                       doneButtonTapped:doneValue];
	}
    if(!shouldDismiss)
        return;
    
	_cancelButtonTapped = cancelValue;
	_doneButtonTapped = doneValue;
    
    if(_hasFocus)
    {
        [self loseFocus];
        
        return;
    }
    
    _state = SCViewControllerStateDismissed;
	
	if(self.popoverController)
    {
        self.popoverController.delegate = nil;  // disable delegate methods
        [self.popoverController dismissPopoverAnimated:YES];
        self.popoverController = nil;
    }
    else 
        if(self.navigationController)
        {
            // check if self is the root controller on the navigation stack
            if([self.navigationController.viewControllers objectAtIndex:0] == self)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
                [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gainFocus
{
    if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
       && [self.delegate respondsToSelector:
           @selector(viewControllerWillGainFocus:)])
    {
        [self.delegate viewControllerWillGainFocus:self];
    }
    
    _hasFocus = TRUE;
    [self.tableViewModel.tableView reloadData];
    
    if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
       && [self.delegate respondsToSelector:
           @selector(viewControllerDidGainFocus:)])
    {
        [self.delegate viewControllerDidGainFocus:self];
    }
}

- (void)loseFocus
{
    if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
       && [self.delegate respondsToSelector:@selector(viewControllerWillLoseFocus:cancelButtonTapped:doneButtonTapped:)])
    {
        [self.delegate viewControllerWillLoseFocus:self cancelButtonTapped:self.cancelButtonTapped doneButtonTapped:self.doneButtonTapped];
    }
    
    _hasFocus = FALSE;
    if(self.navigationBarType != SCNavigationBarTypeNone)
        self.navigationBarType = SCNavigationBarTypeAuto;
    self.title = nil;
    
    // Clear model and refresh table view
    NSRange sectionsRange = {0, self.tableViewModel.sectionCount};
    [self.tableViewModel clear];
    [self.tableViewModel.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:sectionsRange] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([self.delegate conformsToProtocol:@protocol(SCViewControllerDelegate)]
       && [self.delegate respondsToSelector:@selector(viewControllerDidLoseFocus:cancelButtonTapped:doneButtonTapped:)])
    {
        [self.delegate viewControllerDidLoseFocus:self cancelButtonTapped:self.cancelButtonTapped doneButtonTapped:self.doneButtonTapped];
    }
    
    self.delegate = nil;
}


// overrides superclass
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}



#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    BOOL shouldDismiss = TRUE;
    if([self.delegate conformsToProtocol:@protocol(SCTableViewControllerDelegate)]
	   && [self.delegate respondsToSelector:
		   @selector(tableViewControllerShouldDismiss:cancelButtonTapped:doneButtonTapped:)])
	{
		shouldDismiss = [self.delegate viewControllerShouldDismiss:self
                                                cancelButtonTapped:FALSE
                                                  doneButtonTapped:TRUE];
	}
    return shouldDismiss;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // handle dismissal
}

@end

