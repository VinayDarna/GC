/*
 *  SCTableViewCell.m
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

#import "SCTableViewCell.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "SCGlobals.h"
#import "SCTableViewModel.h"
#import "SCStringDefinition.h"
#import "SCMemoryStore.h"



@interface SCTableViewCell()

- (void)setActiveDetailModel:(SCTableViewModel *)model;

- (void)didLayoutSubviews;

- (SCTableViewModel *)modelForViewController:(UIViewController *)viewController;
- (BOOL)isViewControllerActive:(UIViewController *)viewController;
- (SCTableViewModel *)getCustomDetailModelForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)presentDetailViewController:(UIViewController *)detailViewController forCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withPresentationMode:(SCPresentationMode)mode;

- (void)handleDetailViewControllerWillPresent:(UIViewController *)detailViewController;
- (void)handleDetailViewControllerDidPresent:(UIViewController *)detailViewController;
- (BOOL)handleDetailViewControllerShouldDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped;
- (void)handleDetailViewControllerWillDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped;
- (void)handleDetailViewControllerDidDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped;

- (void)handleDetailViewControllerWillGainFocus:(UIViewController *)detailViewController;
- (void)handleDetailViewControllerDidGainFocus:(UIViewController *)detailViewController;
- (void)handleDetailViewControllerWillLoseFocus:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped;
- (void)handleDetailViewControllerDidLoseFocus:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped;


@end


@implementation SCTableViewCell

@synthesize ownerTableViewModel;
@synthesize ownerSection;
@synthesize cellActions = _cellActions;
@synthesize boundObject;
@synthesize boundObjectStore;
@synthesize boundPropertyName;
@synthesize boundPropertyDataType;
@synthesize height;
@synthesize editable;
@synthesize movable;
@synthesize selectable;
@synthesize enabled;
@synthesize detailCellsImageViews;
@synthesize badgeView;
@synthesize autoDeselect;
@synthesize autoResignFirstResponder;
@synthesize cellEditingStyle;
@synthesize valueRequired;
@synthesize autoValidateValue;
@synthesize commitChangesLive;
@synthesize needsCommit;
@synthesize beingReused;
@synthesize customCell;
@synthesize reuseId;
@synthesize configured;
@synthesize isSpecialCell;
@synthesize themeStyle;

+ (id)cell
{
	return [[[self class] alloc] initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]; 
}

+ (id)cellWithStyle:(UITableViewCellStyle)style
{
    return [[[self class] alloc] initWithStyle:style reuseIdentifier:nil]; 
}

+ (id)cellWithText:(NSString *)cellText
{
	return [[[self class] alloc] initWithText:cellText];
}

+ (id)cellWithText:(NSString *)cellText textAlignment:(UITextAlignment)textAlignment
{
    return [[[self class] alloc] initWithText:cellText textAlignment:textAlignment];
}

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object boundPropertyName:(NSString *)propertyName;
{
	return [[[self class] alloc] initWithText:cellText boundObject:object boundPropertyName:propertyName];
}


- (void)performInitialization
{
	self.shouldIndentWhileEditing = TRUE;
	
	ownerTableViewModel = nil;
    ownerSection = nil;
    _cellActions = [[SCCellActions alloc] init];
	boundObject = nil;
    boundObjectStore = nil;
	boundPropertyName = nil;
    boundPropertyDataType = SCDataTypeUnknown;
    _isCustomBoundProperty = FALSE;
	height = 44;
	editable = FALSE;
	movable = FALSE;
	selectable = TRUE;
    enabled = TRUE;
	
	detailCellsImageViews = nil;
    autoDeselect = FALSE;
	autoResignFirstResponder = TRUE;
	cellEditingStyle = UITableViewCellEditingStyleDelete;
	valueRequired = FALSE;
	autoValidateValue = TRUE;
	commitChangesLive = TRUE;
	needsCommit = FALSE;
	beingReused = FALSE;
	customCell = FALSE;
    isSpecialCell = FALSE;
    configured = FALSE;
    
    detailViewControllerOptions = nil;
    activeDetailModel = nil;
	
	// Setup the badgeView
	badgeView = [[SCBadgeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.contentView addSubview:badgeView];
    
    themeStyle = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if( (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
	{
		[self performInitialization];
        if(reuseIdentifier)
            reuseId = [reuseIdentifier copy];
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self performInitialization];
}

- (id)initWithText:(NSString *)cellText
{
	if( (self=[self initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]) )
	{
		self.textLabel.text = cellText;
	}
	return self;
}

- (id)initWithText:(NSString *)cellText textAlignment:(UITextAlignment)textAlignment
{
    if( (self=[self initWithText:cellText]) )
    {
        self.textLabel.textAlignment = textAlignment;
    }
    return self;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object boundPropertyName:(NSString *)propertyName
{
	if( (self=[self initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]) )
	{
		self.textLabel.text = cellText;
		
		self.boundObject = object;
		self.boundPropertyName = propertyName;
	}
	return self;
}


- (void)setIsCustomBoundProperty:(BOOL)custom
{
    _isCustomBoundProperty = custom;
}

- (void)setNeedsCommit:(BOOL)needs
{
    needsCommit = needs;
}

- (void)setActiveDetailModel:(SCTableViewModel *)model
{
    activeDetailModel = model;
    self.ownerTableViewModel.activeDetailModel = model;
}

- (SCDetailViewControllerOptions *)detailViewControllerOptions
{
    // Conserve resources by lazy loading for only cells that need it
    if(!detailViewControllerOptions)
        detailViewControllerOptions = [[SCDetailViewControllerOptions alloc] init];
    
    return detailViewControllerOptions;
}

- (void)setDetailViewControllerOptions:(SCDetailViewControllerOptions *)options
{
    detailViewControllerOptions = options;
}

- (void)didLayoutSubviews
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    
    [self.ownerTableViewModel styleCell:self atIndexPath:indexPath onlyStylePropertyNamesInSet:[NSSet setWithObjects:@"frame", @"bounds", nil]];
    
    if(self.cellActions.didLayoutSubviews)
    {
        self.cellActions.didLayoutSubviews(self, indexPath);
    }
    else 
        if(self.ownerSection.cellActions.didLayoutSubviews)
        {
            self.ownerSection.cellActions.didLayoutSubviews(self, indexPath);
        }
        else 
            if(self.ownerTableViewModel.cellActions.didLayoutSubviews)
            {
                self.ownerTableViewModel.cellActions.didLayoutSubviews(self, indexPath);
            }
        else 
            if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
               && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:didLayoutSubviewsForCell:forRowAtIndexPath:)])
            {
                [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel didLayoutSubviewsForCell:self
                                                forRowAtIndexPath:indexPath];
            } 
}

//overrides superclass
- (NSString *)reuseIdentifier
{
	return self.reuseId;
}

// overrides superclass
- (UITableViewCellSelectionStyle)selectionStyle
{
    if(self.enabled)
        return [super selectionStyle];
    //else
    return UITableViewCellSelectionStyleNone;
}
 
//overrides superclass
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self.badgeView setNeedsDisplay];
}

//overrides superclass
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[self.badgeView setNeedsDisplay];
}

//overrides superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if(self.badgeView.text)
	{
		// Set the badgeView frame
		CGFloat margin = 10;
		CGSize badgeTextSize = CGSizeMake(0, 0);
		if(self.badgeView.text)
			badgeTextSize = [self.badgeView.text sizeWithFont:self.badgeView.font];
		CGFloat badgeHeight = badgeTextSize.height - 2;
		CGRect badgeFrame = CGRectMake(self.contentView.frame.size.width - (badgeTextSize.width+16) - margin, 
									   round((self.contentView.frame.size.height - badgeHeight)/2), 
									   badgeTextSize.width+16, badgeHeight); // must use "round" for badge to get correctly rendered
		self.badgeView.frame = badgeFrame;
		[self.badgeView setNeedsDisplay];
		
		// Resize textLabel
		if((self.textLabel.frame.origin.x + self.textLabel.frame.size.width) >= badgeFrame.origin.x)
		{
			CGFloat badgeWidth = self.textLabel.frame.size.width - badgeFrame.size.width - margin;
			
			self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, 
											  badgeWidth, self.textLabel.frame.size.height);
		}
		
		// Resize detailTextLabel
		if((self.detailTextLabel.frame.origin.x + self.detailTextLabel.frame.size.width) >= badgeFrame.origin.x)
		{
			CGFloat badgeWidth = self.detailTextLabel.frame.size.width - badgeFrame.size.width - margin;
			
			self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, 
													badgeWidth, self.detailTextLabel.frame.size.height);
		}
	}
    else
    {
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.contentView.frame.size.width - self.textLabel.frame.origin.x - 10, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, self.contentView.frame.size.width - self.detailTextLabel.frame.origin.x - 10, self.detailTextLabel.frame.size.height);
    }
	
	[self didLayoutSubviews];
}

//overrides superclass
- (void)setBackgroundColor:(UIColor *)color
{
	[super setBackgroundColor:color];
	
	if(self.selectionStyle==UITableViewCellSelectionStyleNone && !self.backgroundView)
	{
		// This is much more optimized than [UIColor clearColor]
		self.textLabel.backgroundColor = color;
		self.detailTextLabel.backgroundColor = color;
	}
	else
	{
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
	}
}

//overrides superclass
- (void)setBackgroundView:(UIView *)backgroundView
{
    [super setBackgroundView:backgroundView];
    
    if(backgroundView)
    {
        self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)setBoundValue:(NSObject *)value
{
	if(self.boundObject && self.boundPropertyName)
	{
		if(self.cellActions.willCommitBoundValue)
        {
            NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
            value = self.cellActions.willCommitBoundValue(self, indexPath, value);
        }
        else
            if(self.ownerSection.cellActions.willCommitBoundValue)
            {
                NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
                value = self.ownerSection.cellActions.willCommitBoundValue(self, indexPath, value);
            }
            else
                if(self.ownerTableViewModel.cellActions.willCommitBoundValue)
                {
                    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
                    value = self.ownerTableViewModel.cellActions.willCommitBoundValue(self, indexPath, value);
                }
        
        if(self.boundObjectStore)
            [self.boundObjectStore setValue:value forPropertyName:self.boundPropertyName inObject:self.boundObject];
        else 
            [SCUtilities setValue:value forPropertyName:self.boundPropertyName inObject:self.boundObject];
        
        if([SCUtilities isBasicDataTypeClass:[self.boundObject class]])
            self.boundObject = value;
	}
}

- (NSObject *)boundValue
{
    NSObject *value = nil;
    
    if([SCUtilities isBasicDataTypeClass:[self.boundObject class]])
    {
        value = self.boundObject;
    }
    else
        if(self.boundObject && self.boundPropertyName && !_isCustomBoundProperty)
        {
            if(self.boundObjectStore)
                value = [self.boundObjectStore valueForPropertyName:self.boundPropertyName inObject:self.boundObject];
            else
                value = [SCUtilities valueForPropertyName:self.boundPropertyName inObject:self.boundObject];
        }
    
    if(self.cellActions.didLoadBoundValue)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        value = self.cellActions.didLoadBoundValue(self, indexPath, value);
    }
    else
        if(self.ownerSection.cellActions.didLoadBoundValue)
        {
            NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
            value = self.ownerSection.cellActions.didLoadBoundValue(self, indexPath, value);
        }
        else
            if(self.ownerTableViewModel.cellActions.didLoadBoundValue)
            {
                NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
                value = self.ownerTableViewModel.cellActions.didLoadBoundValue(self, indexPath, value);
            }
    
    return value;
}

- (BOOL)valueIsValid
{
    if(self.cellActions.valueIsValid)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        return self.cellActions.valueIsValid(self, indexPath);
    }
    //else
    if(self.ownerSection.cellActions.valueIsValid)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        return self.ownerSection.cellActions.valueIsValid(self, indexPath);
    }
    //else
    if(self.ownerTableViewModel.cellActions.valueIsValid)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        return self.ownerTableViewModel.cellActions.valueIsValid(self, indexPath);
    }
    
	if(self.autoValidateValue)
		return [self getValueIsValid];
	
	BOOL valid = TRUE;
	
	if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:valueIsValidForRowAtIndexPath:)])
    {
        NSIndexPath *indexPath = [ownerTableViewModel indexPathForCell:self];
        valid = [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
                                    valueIsValidForRowAtIndexPath:indexPath];
    }
	
	return valid;
}

- (BOOL)getValueIsValid
{
	// Should be overridden by subclasses
	return TRUE;
}

- (void)cellValueChanged
{
	needsCommit = TRUE;
	
	if(self.commitChangesLive)
		[self commitChanges];
	
	NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
	if(activeDetailModel) // a custom detail view is defined
	{
		NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
		[self.ownerTableViewModel.tableView reloadRowsAtIndexPaths:indexPaths
														 withRowAnimation:UITableViewRowAnimationNone];
	}
	
	[self.ownerTableViewModel valueChangedForRowAtIndexPath:indexPath];
}

- (void)willDisplay
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    [self.ownerTableViewModel styleCell:self atIndexPath:indexPath onlyStylePropertyNamesInSet:nil];
}

- (void)didSelectCell
{
	if(self.autoDeselect)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        [self.ownerTableViewModel.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)willDeselectCell
{
	if(activeDetailModel)
	{
		UITableView *detailTableView = activeDetailModel.tableView;
		[self setActiveDetailModel:nil];
		detailTableView.dataSource = nil;
		detailTableView.delegate = nil;
		[detailTableView reloadData];
	}
}

- (void)didDeselectCell
{
    // Does nothing
}

- (void)markCellAsSpecial
{
    isSpecialCell = TRUE;
}

- (void)commitChanges
{
	needsCommit = FALSE;
}

- (void)reloadBoundValue
{
	// Does nothing, should be overridden by subclasses
}

- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	self.imageView.image = attributes.imageView.image;
	self.detailCellsImageViews = attributes.imageViewArray;
}

- (void)prepareCellForDetailViewAppearing
{
	// disable ownerViewControllerDelegate
	if([self.ownerTableViewModel.viewController isKindOfClass:[SCTableViewController class]])
	{
		SCTableViewController *tViewController = (SCTableViewController *)self.ownerTableViewModel.viewController;
		ownerViewControllerDelegate = tViewController.delegate;
		tViewController.delegate = nil;
	}
	else
		if([self.ownerTableViewModel.viewController isKindOfClass:[SCViewController class]])
		{
			SCViewController *vController = (SCViewController *)self.ownerTableViewModel.viewController;
			ownerViewControllerDelegate = vController.delegate;
			vController.delegate = nil;
		}
	
	// lock master cell selection (in case a custom detail view is provided)
	if(self.ownerTableViewModel.masterModel)
		self.ownerTableViewModel.masterModel.lockCellSelection = TRUE;
}

- (void)prepareCellForDetailViewDisappearing
{
	// enable ownerViewControllerDelegate
	if([self.ownerTableViewModel.viewController isKindOfClass:[SCTableViewController class]])
	{
		SCTableViewController *tViewController = (SCTableViewController *)self.ownerTableViewModel.viewController;
		tViewController.delegate = ownerViewControllerDelegate;
	}
	else
		if([self.ownerTableViewModel.viewController isKindOfClass:[SCViewController class]])
		{
			SCViewController *vController = (SCViewController *)self.ownerTableViewModel.viewController;
			vController.delegate = ownerViewControllerDelegate;
		}
	
	// resume cell selection
	if(self.ownerTableViewModel.masterModel)
		self.ownerTableViewModel.masterModel.lockCellSelection = FALSE;
}


- (SCTableViewModel *)modelForViewController:(UIViewController *)viewController
{
    SCTableViewModel *detailModel = nil;
    
    if([viewController isKindOfClass:[SCTableViewController class]])
    {
        detailModel = [(SCTableViewController *)viewController tableViewModel];
    }
    else 
        if([viewController isKindOfClass:[SCViewController class]])
        {
            detailModel = [(SCViewController *)viewController tableViewModel];
        }
    
    return detailModel;
}

- (BOOL)isViewControllerActive:(UIViewController *)viewController
{
    BOOL active = FALSE;
    
    if([viewController isKindOfClass:[SCTableViewController class]])
    {
        active = [(SCTableViewController *)viewController state] == SCViewControllerStateActive;
    }
    else 
        if([viewController isKindOfClass:[SCViewController class]])
        {
            active = [(SCViewController *)viewController state] == SCViewControllerStateActive;
        }
    
    return active;
}

- (SCNavigationBarType)defaultDetailViewControllerNavigationBarType
{
    return self.detailViewControllerOptions.navigationBarType;
}

- (void)buildDetailModel:(SCTableViewModel *)detailModel
{
    // should be overridden by subclasses
}

- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
    // should be overridden by subclasses
}

- (UIViewController *)getDetailViewControllerForCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath allowUITableViewControllerSubclass:(BOOL)allowUITableViewController
{
    UIViewController *detailViewController = nil;
    
    if(self.cellActions.detailViewController)
    {
        detailViewController = self.cellActions.detailViewController(self, indexPath);
    }
    else 
        if(self.ownerSection.cellActions.detailViewController)
        {
            detailViewController = self.ownerSection.cellActions.detailViewController(self, indexPath);
        }
        else 
            if(self.ownerTableViewModel.cellActions.detailViewController)
            {
                detailViewController = self.ownerTableViewModel.cellActions.detailViewController(self, indexPath);
            }
    else 
    if([self.ownerTableViewModel.dataSource conformsToProtocol:@protocol(SCTableViewModelDataSource)]
	   && [self.ownerTableViewModel.dataSource respondsToSelector:@selector(tableViewModel:detailViewControllerForRowAtIndexPath:)])
	{
		detailViewController = [self.ownerTableViewModel.dataSource tableViewModel:self.ownerTableViewModel detailViewControllerForRowAtIndexPath:indexPath];
	}
    else 
    if(self.ownerTableViewModel.detailViewController)
    {
        detailViewController = self.ownerTableViewModel.detailViewController;
    }
    
    if(!detailViewController)
    {
        if(allowUITableViewController)
            detailViewController = [[SCTableViewController alloc] initWithStyle:self.detailViewControllerOptions.tableViewStyle];
        else 
            detailViewController = [[SCViewController alloc] init];
    }
        
    detailViewController.modalPresentationStyle = self.detailViewControllerOptions.modalPresentationStyle;
    if(self.detailViewControllerOptions.title)
        detailViewController.title = self.detailViewControllerOptions.title;
    else 
        detailViewController.title = cell.textLabel.text;
    detailViewController.hidesBottomBarWhenPushed = self.detailViewControllerOptions.hidesBottomBarWhenPushed;
    detailViewController.contentSizeForViewInPopover = self.ownerTableViewModel.viewController.contentSizeForViewInPopover;
    
    SCTableViewModel *detailModel = nil;
    detailModel = [self getCustomDetailModelForRowAtIndexPath:indexPath];
    
    UIBarButtonItem *addButtonItem = nil;
    if([detailViewController isKindOfClass:[SCTableViewController class]])
    {
        SCTableViewController *viewController = (SCTableViewController *)detailViewController;
        
        viewController.delegate = self;
        SCNavigationBarType navBarType = [self defaultDetailViewControllerNavigationBarType];
        if(navBarType==SCNavigationBarTypeAuto && viewController.navigationBarType==SCNavigationBarTypeAuto)
            viewController.navigationBarType = SCNavigationBarTypeDoneRightCancelLeft;
        else 
            if(viewController.navigationBarType==SCNavigationBarTypeAuto)
                viewController.navigationBarType = navBarType;
        viewController.allowEditingModeCancelButton = self.detailViewControllerOptions.allowEditingModeCancelButton;
        if(detailModel)
            viewController.tableViewModel = detailModel;
        else 
            detailModel = viewController.tableViewModel;
        
        addButtonItem = viewController.addButton;
    }
    else 
        if([detailViewController isKindOfClass:[SCViewController class]])
        {
            SCViewController *viewController = (SCViewController *)detailViewController;
            
            viewController.delegate = self;
            SCNavigationBarType navBarType = [self defaultDetailViewControllerNavigationBarType];
            if(navBarType==SCNavigationBarTypeAuto && viewController.navigationBarType==SCNavigationBarTypeAuto)
                viewController.navigationBarType = SCNavigationBarTypeDoneRightCancelLeft;
            else 
                if(viewController.navigationBarType==SCNavigationBarTypeAuto)
                    viewController.navigationBarType = navBarType;
            viewController.allowEditingModeCancelButton = self.detailViewControllerOptions.allowEditingModeCancelButton;
            if(detailModel)
                viewController.tableViewModel = detailModel;
            else 
                detailModel = viewController.tableViewModel;
            
            addButtonItem = viewController.addButton;
        }
    
    if(self.cellActions.detailModelCreated)
    {
        self.cellActions.detailModelCreated(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelCreated)
        {
            self.ownerSection.cellActions.detailModelCreated(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelCreated)
            {
                self.ownerTableViewModel.cellActions.detailModelCreated(self, indexPath, detailModel);
            }
    else
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
	   && [self.ownerTableViewModel.delegate 
		   respondsToSelector:@selector(tableViewModel:detailModelCreatedForRowAtIndexPath:detailTableViewModel:)])
	{
		[self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
					  detailModelCreatedForRowAtIndexPath:indexPath
									 detailTableViewModel:detailModel];
	}
    
    [self.ownerTableViewModel configureDetailModel:detailModel];
	[self buildDetailModel:detailModel];
    
    if(addButtonItem)
    {
        for(NSUInteger i=0; i<detailModel.sectionCount; i++)
        {
            SCTableViewSection *section = [detailModel sectionAtIndex:i];
            if([section isKindOfClass:[SCArrayOfItemsSection class]])
            {
                [(SCArrayOfItemsSection *)section setAddButtonItem:addButtonItem];
                break;
            }
        }
    }
	
    if(self.cellActions.detailModelConfigured)
    {
        self.cellActions.detailModelConfigured(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelConfigured)
        {
            self.ownerSection.cellActions.detailModelConfigured(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelConfigured)
            {
                self.ownerTableViewModel.cellActions.detailModelConfigured(self, indexPath, detailModel);
            }
    else 
	if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:detailModelConfiguredForRowAtIndexPath:detailTableViewModel:)])
    {
       [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                   detailModelConfiguredForRowAtIndexPath:indexPath detailTableViewModel:detailModel];
    }
    
    
    return detailViewController;
}

- (SCTableViewModel *)getCustomDetailModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SCTableViewModel *detailModel = nil;
    
    if(self.cellActions.detailTableViewModel)
    {
        detailModel = self.cellActions.detailTableViewModel(self, indexPath);
    }
    else 
        if(self.ownerSection.cellActions.detailTableViewModel)
        {
            detailModel = self.ownerSection.cellActions.detailTableViewModel(self, indexPath);
        }
        else 
            if(self.ownerTableViewModel.cellActions.detailTableViewModel)
            {
                detailModel = self.ownerTableViewModel.cellActions.detailTableViewModel(self, indexPath);
            }
    else 
	if([self.ownerTableViewModel.dataSource conformsToProtocol:@protocol(SCTableViewModelDataSource)]
	   && [self.ownerTableViewModel.dataSource 
		   respondsToSelector:@selector(tableViewModel:detailTableViewModelForRowAtIndexPath:)])
	{
		detailModel = [self.ownerTableViewModel.dataSource tableViewModel:self.ownerTableViewModel detailTableViewModelForRowAtIndexPath:indexPath];
	}
    
	return detailModel;
}

- (void)presentDetailViewController:(UIViewController *)detailViewController forCell:(SCTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withPresentationMode:(SCPresentationMode)mode
{
    [self prepareCellForDetailViewAppearing];
    
    [self setActiveDetailModel:[self modelForViewController:detailViewController]];
    
    BOOL customPresentation = FALSE;
    if([self isViewControllerActive:detailViewController] && mode==SCPresentationModeAuto)
    {
        customPresentation = TRUE;
        
        if([detailViewController respondsToSelector:@selector(gainFocus)])
            [(id)detailViewController gainFocus];
    }
    else 
        if([self.ownerTableViewModel.dataSource conformsToProtocol:@protocol(SCTableViewModelDataSource)]
           && [self.ownerTableViewModel.dataSource 
               respondsToSelector:@selector(tableViewModel:customPresentDetailViewController:forRowAtIndexPath:)])
        {
            customPresentation = [self.ownerTableViewModel.dataSource tableViewModel:self.ownerTableViewModel
                                                   customPresentDetailViewController:detailViewController forRowAtIndexPath:indexPath];
        }
    
    if(!customPresentation)
    {
        UINavigationController *navController = self.ownerTableViewModel.viewController.navigationController;
        if(mode == SCPresentationModeAuto)
        {
            if(navController)
                mode = SCPresentationModePush;
            else 
                mode = SCPresentationModeModal;
        }
        if(mode==SCPresentationModePush && !navController)
            mode = SCPresentationModeModal;
        
        UINavigationController *detailNavController = nil;
        if(mode==SCPresentationModeModal || mode==SCPresentationModePopover)
        {
            detailNavController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
            if(navController)
            {
                detailNavController.view.backgroundColor = navController.view.backgroundColor;
                UIBarStyle barStyle = navController.navigationBar.barStyle;
                if(![SCUtilities isViewInsidePopover:self.ownerTableViewModel.viewController.view])
                    detailNavController.navigationBar.barStyle = barStyle;
                else  
                    detailNavController.navigationBar.barStyle = UIBarStyleBlack;
                detailNavController.navigationBar.tintColor = navController.navigationBar.tintColor;
            }
            
            detailNavController.contentSizeForViewInPopover = detailViewController.contentSizeForViewInPopover;
            detailNavController.modalPresentationStyle = detailViewController.modalPresentationStyle;
        }
        
        switch (mode) {
            case SCPresentationModePush:
                [navController pushViewController:detailViewController animated:YES];
                break;
            case SCPresentationModeModal:
            {
                [self.ownerTableViewModel.viewController presentViewController:detailNavController animated:YES completion:nil];
            }
                break;
            case SCPresentationModePopover:
            {
                UIPopoverController *popoverController  = [[UIPopoverController alloc] initWithContentViewController:self.ownerTableViewModel.viewController];
                if([detailViewController isKindOfClass:[SCTableViewController class]])
                {
                    [(SCTableViewController *)detailViewController setPopoverController:popoverController];
                }
                else 
                    if([detailViewController isKindOfClass:[SCViewController class]])
                    {
                        [(SCViewController *)detailViewController setPopoverController:popoverController];
                    }
                detailViewController.modalInPopover = YES;
                
                [popoverController presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
                break;
                
            default:
                // Do nothing
                break;
        }
    }
}

- (void)handleDetailViewControllerWillPresent:(UIViewController *)detailViewController
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    SCTableViewModel *detailModel = [self modelForViewController:detailViewController];
    
    if(self.cellActions.detailModelWillPresent)
    {
        self.cellActions.detailModelWillPresent(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelWillPresent)
        {
            self.ownerSection.cellActions.detailModelWillPresent(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelWillPresent)
            {
                self.ownerTableViewModel.cellActions.detailModelWillPresent(self, indexPath, detailModel);
            }
    else 
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:detailViewWillPresentForRowAtIndexPath:withDetailTableViewModel:)])
    {
        [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel detailViewWillPresentForRowAtIndexPath:indexPath withDetailTableViewModel:detailModel];
    }
}

- (void)handleDetailViewControllerDidPresent:(UIViewController *)detailViewController
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    SCTableViewModel *detailModel = [self modelForViewController:detailViewController];
    
    if(self.cellActions.detailModelDidPresent)
    {
        self.cellActions.detailModelDidPresent(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelDidPresent)
        {
            self.ownerSection.cellActions.detailModelDidPresent(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelDidPresent)
            {
                self.ownerTableViewModel.cellActions.detailModelDidPresent(self, indexPath, detailModel);
            }
    else
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:detailViewDidPresentForRowAtIndexPath:withDetailTableViewModel:)])
    {
        [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel detailViewDidPresentForRowAtIndexPath:indexPath withDetailTableViewModel:detailModel];
    }
}

- (BOOL)handleDetailViewControllerShouldDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    
    BOOL shouldDismiss = TRUE;
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:shouldDismissDetailViewForRowAtIndexPath:withDetailTableViewModel:cancelButtonTapped:doneButtonTapped:)])
    {
        shouldDismiss = [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                                 shouldDismissDetailViewForRowAtIndexPath:indexPath withDetailTableViewModel:[self modelForViewController:detailViewController] cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
    }
    
    return shouldDismiss;
}

- (void)handleDetailViewControllerWillDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self prepareCellForDetailViewDisappearing];
    
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    SCTableViewModel *detailModel = [self modelForViewController:detailViewController];
	
	if(!cancelTapped)
        [self commitDetailModelChanges:detailModel];
    
    if(self.cellActions.detailModelWillDismiss)
    {
        self.cellActions.detailModelWillDismiss(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelWillDismiss)
        {
            self.ownerSection.cellActions.detailModelWillDismiss(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelWillDismiss)
            {
                self.ownerTableViewModel.cellActions.detailModelWillDismiss(self, indexPath, detailModel);
            }
    else
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:detailViewWillDismissForRowAtIndexPath:)])
    {
        [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                   detailViewWillDismissForRowAtIndexPath:indexPath];
    }
}

- (void)handleDetailViewControllerDidDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self setActiveDetailModel:nil];
	
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    SCTableViewModel *detailModel = [self modelForViewController:detailViewController];
    
    if(self.cellActions.detailModelDidDismiss)
    {
        self.cellActions.detailModelDidDismiss(self, indexPath, detailModel);
    }
    else
        if(self.ownerSection.cellActions.detailModelDidDismiss)
        {
            self.ownerSection.cellActions.detailModelDidDismiss(self, indexPath, detailModel);
        }
        else
            if(self.ownerTableViewModel.cellActions.detailModelDidDismiss)
            {
                self.ownerTableViewModel.cellActions.detailModelDidDismiss(self, indexPath, detailModel);
            }
            else
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:detailViewDidDismissForRowAtIndexPath:)])
    {
        [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                    detailViewDidDismissForRowAtIndexPath:indexPath];
    }
}


- (void)handleDetailViewControllerWillGainFocus:(UIViewController *)detailViewController
{
    [self handleDetailViewControllerWillPresent:detailViewController];
}

- (void)handleDetailViewControllerDidGainFocus:(UIViewController *)detailViewController
{
    [self handleDetailViewControllerDidPresent:detailViewController];
}

- (void)handleDetailViewControllerWillLoseFocus:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerWillDismiss:detailViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)handleDetailViewControllerDidLoseFocus:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    [self.ownerTableViewModel.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleDetailViewControllerDidDismiss:detailViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}


#pragma mark -
#pragma mark SCTableViewControllerDelegate methods

- (void)tableViewControllerWillPresent:(SCTableViewController *)tableViewController
{
    [self handleDetailViewControllerWillPresent:tableViewController];
}

- (void)tableViewControllerDidPresent:(SCTableViewController *)tableViewController
{
    [self handleDetailViewControllerDidPresent:tableViewController];
}

- (BOOL)tableViewControllerShouldDismiss:(SCTableViewController *)tableViewController
					  cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    return [self handleDetailViewControllerShouldDismiss:tableViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)tableViewControllerWillDismiss:(SCTableViewController *)tableViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerWillDismiss:tableViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)tableViewControllerDidDismiss:(SCTableViewController *)tableViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
	[self handleDetailViewControllerDidDismiss:tableViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}


- (void)tableViewControllerWillGainFocus:(SCTableViewController *)tableViewController
{
    [self handleDetailViewControllerWillGainFocus:tableViewController];
}

- (void)tableViewControllerDidGainFocus:(SCTableViewController *)tableViewController
{
    [self handleDetailViewControllerDidGainFocus:tableViewController];
}

- (void)tableViewControllerWillLoseFocus:(SCTableViewController *)tableViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerWillLoseFocus:tableViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)tableViewControllerDidLoseFocus:(SCTableViewController *)tableViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerDidLoseFocus:tableViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

#pragma mark -
#pragma mark SCViewControllerDelegate methods

- (void)viewControllerWillPresent:(SCViewController *)viewController
{
    [self handleDetailViewControllerWillPresent:viewController];
}

- (void)viewControllerDidPresent:(SCViewController *)viewController
{
    [self handleDetailViewControllerDidPresent:viewController];
}

- (BOOL)viewControllerShouldDismiss:(SCViewController *)viewController
                 cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    return [self handleDetailViewControllerShouldDismiss:viewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)viewControllerWillDismiss:(SCViewController *)viewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerWillDismiss:viewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)viewControllerDidDismiss:(SCViewController *)viewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
	[self handleDetailViewControllerDidDismiss:viewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}


- (void)viewControllerWillGainFocus:(SCViewController *)viewController
{
    [self handleDetailViewControllerWillGainFocus:viewController];
}

- (void)viewControllerDidGainFocus:(SCViewController *)viewController
{
    [self handleDetailViewControllerDidGainFocus:viewController];
}

- (void)viewControllerWillLoseFocus:(SCViewController *)viewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerWillLoseFocus:viewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

- (void)viewControllerDidLoseFocus:(SCViewController *)viewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [self handleDetailViewControllerDidLoseFocus:viewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
}

@end










@interface SCCustomCell ()

- (CGFloat)heightForLabel:(UILabel *)label;

// handles label auto-resizing
- (void)autoResizeLabel:(UILabel *)label;

// determines if the custom control is bound to either an object or a key
- (BOOL)controlWithTagIsBound:(NSUInteger)controlTag;

@end



@implementation SCCustomCell

@synthesize objectBindings = _objectBindings;
@synthesize autoResize = _autoResize;
@synthesize showClearButtonInInputAccessoryView = _showClearButtonInInputAccessoryView;


+ (id)cellWithText:(NSString *)cellText objectBindings:(NSDictionary *)bindings nibName:(NSString *)nibName
{
    return [self cellWithText:cellText boundObject:nil objectBindings:bindings nibName:nibName];
}

+ (id)cellWithText:(NSString *)cellText objectBindingsString:(NSString *)bindingsString nibName:(NSString *)nibName
{
    NSDictionary *bindings = [SCUtilities bindingsDictionaryForBindingsString:bindingsString];
    
    return [self cellWithText:cellText boundObject:nil objectBindings:bindings nibName:nibName];
}

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object objectBindings:(NSDictionary *)bindings
	   nibName:(NSString *)nibName
{
	SCCustomCell *cell;
	if(nibName)
	{
		cell = (SCCustomCell *)[SCUtilities getFirstNodeInNibWithName:nibName];
		
        if([cell isKindOfClass:[SCCustomCell class]])
        {
            cell.reuseId = nibName;
            cell.height = cell.frame.size.height;
        }
        else 
        {
            SCDebugLog(@"Warning: Unexpected cell type! Expecting 'SCCustomCell' but got '%@' instead.", NSStringFromClass([cell class]));
            
            cell = nil;
        }
		
	}
	else
	{
		cell = [[[self class] alloc] initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil];
	}
	cell.textLabel.text = cellText;
	[cell setBoundObject:object];
	[cell.objectBindings addEntriesFromDictionary:bindings];
	[cell configureCustomControls];
	
	return cell;
}


- (NSString *)objectBindingsString
{
    return [SCUtilities bindingsStringForBindingsDictionary:self.objectBindings];
}

- (void)setObjectBindingsString:(NSString *)objectBindingsString
{
    [self.objectBindings removeAllObjects];
    [self.objectBindings addEntriesFromDictionary:[SCUtilities bindingsDictionaryForBindingsString:objectBindingsString]];
}

//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	_pauseControlEvents = FALSE;
	_objectBindings = [[NSMutableDictionary alloc] init];
	_autoResize = TRUE;
    _showClearButtonInInputAccessoryView = FALSE;
}

//overrides superclass
- (BOOL)canBecomeFirstResponder
{
    return (self.inputControlsSortedByTag.count > 0);
}

//overrides superclass
- (BOOL)becomeFirstResponder
{
    NSArray *inputControls = self.inputControlsSortedByTag; // optimization
    if(inputControls.count)
    {
        [[inputControls objectAtIndex:0] becomeFirstResponder];
        return TRUE;
    }
    //else 
    return FALSE;
}

//overrides superclass
- (BOOL)resignFirstResponder
{
    BOOL resign = FALSE;
    if(self == self.ownerTableViewModel.activeCell)
    {
        [self.ownerTableViewModel.activeCellControl resignFirstResponder];
        resign = TRUE;
    }
        
    return resign;
}


- (NSArray *)inputControlsSortedByTag
{
    NSMutableArray *inputControls = [NSMutableArray array];
    
    for(UIView *customControl in self.contentView.subviews)
    {
        if([customControl isKindOfClass:[UITextField class]] 
           || [customControl isKindOfClass:[UITextView class]])
        {
            [inputControls addObject:customControl];
        }
    }
    
    // sort based on the controls' tag
    [inputControls sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2)
     {
         if([(UIView *)obj1 tag] > [(UIView *)obj2 tag]) 
             return (NSComparisonResult)NSOrderedDescending;
         
         if([(UIView *)obj1 tag] < [(UIView *)obj2 tag]) 
             return (NSComparisonResult)NSOrderedAscending;
         
         return (NSComparisonResult)NSOrderedSame;
     }];
    
    return inputControls;
}

- (UIView *)controlWithTag:(NSInteger)controlTag
{
	if(controlTag < 1)
		return nil;
	
	for(UIView *customControl in self.contentView.subviews)
		if(customControl.tag == controlTag)
			return customControl;
	
	return nil;
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    for(UIControl *customControl in self.contentView.subviews)
    {
        if([customControl isKindOfClass:[UITextView class]])
            [(UITextView *)customControl setEditable:_enabled];
        else
            if(![customControl isKindOfClass:[UILabel class]])
                customControl.enabled = _enabled;
    }
}

//overrides superclass
- (CGFloat)height
{
    // Make sure the cell's height fits its controls
    if(!self.needsCommit)
    {
        [self loadBindingsIntoCustomControls];
    } 
    
    if(self.autoResize)
    {
        CGFloat maxYValue = 0;
        for(UIView *customControl in self.contentView.subviews)
        {
            CGRect controlFrame = customControl.frame;
            
            if([customControl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)customControl;
                controlFrame.size.height = [self heightForLabel:label]+5.0f;  // 5.0 label padding
            }
            
            CGFloat yValue = controlFrame.origin.y + controlFrame.size.height;
            if(yValue > maxYValue)
                maxYValue = yValue;
        }
        
        if(height > maxYValue)
            return height;
        //else
        return maxYValue;
    }
    //else
    return height;
}

//overrides superclass
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // auto resize labels
    if(self.autoResize)
    {
        for(UIView *customControl in self.contentView.subviews)
        {
            if([customControl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)customControl;
                [self autoResizeLabel:label];
            }
        }
    }

    [self didLayoutSubviews];
}

//override superclass
- (void)willDisplay
{
	[super willDisplay];
	
	if(!self.needsCommit)
	{
		[self loadBindingsIntoCustomControls];
	}
    
}

//override superclass
- (void)reloadBoundValue
{
	[super reloadBoundValue];
    
    [self loadBindingsIntoCustomControls];
}

//override superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	for(UIView *customControl in self.contentView.subviews)
	{
		if(customControl.tag < 1)
			continue;
		
		if([customControl isKindOfClass:[UITextView class]])
		{
			UITextView *textView = (UITextView *)customControl;
			[self commitValueForControlWithTag:textView.tag value:textView.text];
		}
		else
			if([customControl isKindOfClass:[UITextField class]])
			{
				UITextField *textField = (UITextField *)customControl;
				[self commitValueForControlWithTag:textField.tag value:textField.text];
			}
			else
				if([customControl isKindOfClass:[UISlider class]])
				{
					UISlider *slider = (UISlider *)customControl;
					[self commitValueForControlWithTag:slider.tag 
												 value:[NSNumber numberWithFloat:slider.value]];
				}
				else
					if([customControl isKindOfClass:[UISegmentedControl class]])
					{
						UISegmentedControl *segmented = (UISegmentedControl *)customControl;
						[self commitValueForControlWithTag:segmented.tag 
													 value:[NSNumber numberWithInteger:segmented.selectedSegmentIndex]];
					}
					else
						if([customControl isKindOfClass:[UISwitch class]])
						{
							UISwitch *switchControl = (UISwitch *)customControl;
							[self commitValueForControlWithTag:switchControl.tag
														 value:[NSNumber numberWithBool:switchControl.on]];
						}
	}
	
	needsCommit = FALSE;
}

- (BOOL)controlWithTagIsBound:(NSUInteger)controlTag
{
    BOOL isBound = FALSE;
    
    if(self.boundObject)
	{
		if([self.objectBindings valueForKey:[NSString stringWithFormat:@"%i", (int)controlTag]])
            isBound = TRUE;
    }
	
    return isBound;
}

- (NSObject *)boundValueForControlWithTag:(NSInteger)controlTag
{
	NSObject *controlValue = nil;
	
	if(self.boundObject)
	{
		NSString *propertyName = [self.objectBindings valueForKey:[NSString stringWithFormat:@"%i", (int)controlTag]];
		if(!propertyName)
			return nil;
		
        if([SCUtilities propertyName:propertyName existsInObject:self.boundObject])
        {
            if(self.boundObjectStore)
                controlValue = [self.boundObjectStore valueForPropertyName:propertyName inObject:self.boundObject];
            else 
                controlValue = [SCUtilities valueForPropertyName:propertyName inObject:self.boundObject];
        }
	}
	
	return controlValue;
}

- (void)commitValueForControlWithTag:(NSInteger)controlTag value:(NSObject *)controlValue
{
	if(self.boundObject)
	{
		NSString *propertyName = [self.objectBindings valueForKey:[NSString stringWithFormat:@"%i", (int)controlTag]];
		if(!propertyName)
			return;
		
        
        SCDataType propertyDataType = SCDataTypeUnknown;  
        if(self.boundObjectStore)
        {
            SCDataDefinition *boundObjectDef = [self.boundObjectStore definitionForObject:self.boundObject];
            if(boundObjectDef)
                propertyDataType = [boundObjectDef propertyDataTypeForPropertyWithName:propertyName];
        }
        controlValue = [SCUtilities getValueCompatibleWithDataType:propertyDataType fromValue:controlValue];
        
        if(self.boundObjectStore)
            [self.boundObjectStore setValue:controlValue forPropertyName:propertyName inObject:self.boundObject];
        else 
            [SCUtilities setValue:controlValue forPropertyName:propertyName inObject:self.boundObject];
	}
}

- (void)configureCustomControls
{
	for(UIView *customControl in self.contentView.subviews)
	{
		if(customControl.tag < 1)
			continue;
		
		if([customControl isKindOfClass:[UITextView class]])
		{
			UITextView *textView = (UITextView *)customControl;
			textView.delegate = self;
		}
		else
			if([customControl isKindOfClass:[UITextField class]])
			{
				UITextField *textField = (UITextField *)customControl;
				textField.delegate = self;
				[textField addTarget:self action:@selector(textFieldEditingChanged:) 
					forControlEvents:UIControlEventEditingChanged];
			}
			else
				if([customControl isKindOfClass:[UISlider class]])
				{
					UISlider *slider = (UISlider *)customControl;
					[slider addTarget:self action:@selector(sliderValueChanged:) 
                     forControlEvents:UIControlEventValueChanged];
				}
				else
					if([customControl isKindOfClass:[UISegmentedControl class]])
					{
						UISegmentedControl *segmented = (UISegmentedControl *)customControl;
						[segmented addTarget:self action:@selector(segmentedControlValueChanged:) 
                            forControlEvents:UIControlEventValueChanged];
					}
					else
						if([customControl isKindOfClass:[UISwitch class]])
						{
							UISwitch *switchControl = (UISwitch *)customControl;
							[switchControl addTarget:self action:@selector(switchControlChanged:) 
                                    forControlEvents:UIControlEventValueChanged];
						}
						else
							if([customControl isKindOfClass:[UIButton class]])
							{
								UIButton *customButton = (UIButton *)customControl;
								[customButton addTarget:self action:@selector(customButtonTapped:) 
                                       forControlEvents:UIControlEventTouchUpInside];
							}
	}
}

- (void)loadBindingsIntoCustomControls
{
	_pauseControlEvents = TRUE;
	
	for(UIView *customControl in self.contentView.subviews)
	{
		if(customControl.tag<1 || ![self controlWithTagIsBound:customControl.tag])
			continue;
		
		NSObject *controlValue = [self boundValueForControlWithTag:customControl.tag];
		
		if([customControl isKindOfClass:[UILabel class]])
		{
            controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSString fromValue:controlValue];
            
			if(!controlValue)
				controlValue = @"";
			UILabel *label = (UILabel *)customControl;
			label.text = (NSString *)controlValue;
		}
		else
			if([customControl isKindOfClass:[UITextView class]])
			{
                controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSString fromValue:controlValue];
                
				if(!controlValue)
					controlValue = @"";
				UITextView *textView = (UITextView *)customControl;
				textView.text = (NSString *)controlValue;
			}
			else
				if([customControl isKindOfClass:[UITextField class]])
				{
                    controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSString fromValue:controlValue];
                    
					if(!controlValue)
						controlValue = @"";
					UITextField *textField = (UITextField *)customControl;
					textField.text = (NSString *)controlValue;
				}
				else
					if([customControl isKindOfClass:[UISlider class]])
					{
                        controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSNumber fromValue:controlValue];
                        
						if(!controlValue)
							controlValue = [NSNumber numberWithInt:0];
						UISlider *slider = (UISlider *)customControl;
						slider.value = [(NSNumber *)controlValue floatValue];
					}
					else
						if([customControl isKindOfClass:[UISegmentedControl class]])
						{
                            controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSNumber fromValue:controlValue];
                            
							if(!controlValue)
								controlValue = [NSNumber numberWithInt:-1];
							UISegmentedControl *segmented = (UISegmentedControl *)customControl;
							segmented.selectedSegmentIndex = [(NSNumber *)controlValue intValue];
						}
						else
							if([customControl isKindOfClass:[UISwitch class]])
							{
                                controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSNumber fromValue:controlValue];
                                
								if(!controlValue)
									controlValue = [NSNumber numberWithBool:FALSE];
								UISwitch *switchControl = (UISwitch *)customControl;
								switchControl.on = [(NSNumber *)controlValue boolValue];
							}
							else
								if([customControl isKindOfClass:[UIButton class]])
								{
									controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSString fromValue:controlValue];
                                    
                                    if(controlValue)
									{
										UIButton *customButton = (UIButton *)customControl;
										NSString *buttonTitle = (NSString *)controlValue;
										[customButton setTitle:buttonTitle forState:UIControlStateNormal];
									}
								}
                                else 
                                    if([customControl isKindOfClass:[UIImageView class]])
                                    {
                                        controlValue = [SCUtilities getValueCompatibleWithDataType:SCDataTypeNSString fromValue:controlValue];
                                        
                                        NSString *stringValue = (NSString *)controlValue;
                                        UIImageView *imageView = (UIImageView *)customControl;
                                        
                                        SEL setImageWithURLSelector = NSSelectorFromString(@"setImageWithURL:");
                                        if([SCUtilities isURLValid:stringValue] && [imageView respondsToSelector:setImageWithURLSelector])
                                        {
                                            NSURL *imageURL = [NSURL URLWithString:stringValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                            [imageView performSelector:setImageWithURLSelector withObject:imageURL];
#pragma clang diagnostic pop
                                        }
                                    }
	}
	
	_pauseControlEvents = FALSE;
}

- (CGFloat)heightForLabel:(UILabel *)label
{
    CGFloat lineHeight = [label.text sizeWithFont:label.font].height;
    CGFloat maxHeight;
    if(label.numberOfLines > 0)
        maxHeight = label.numberOfLines * lineHeight;
    else
        maxHeight = MAXFLOAT;
    CGSize constraintSize = CGSizeMake(label.frame.size.width, maxHeight);
    CGFloat labelHeight = [label.text sizeWithFont:label.font constrainedToSize:constraintSize
                                     lineBreakMode:label.lineBreakMode].height;
    
    return labelHeight;
}

- (void)autoResizeLabel:(UILabel *)label
{	
	if(label.text && (label.lineBreakMode==NSLineBreakByWordWrapping || label.lineBreakMode==NSLineBreakByCharWrapping) && label.frame.size.width!=0 )
	{
        NSMutableString *labelText = [NSMutableString stringWithString:label.text];
        
        CGFloat labelHeight = [self heightForLabel:label];
        
		// auto-resize label to fit its contents
		CGRect labelFrame = label.frame;
		labelFrame.size.height = labelHeight;
		label.frame = labelFrame;
		//finally add an ellipsis if the string exceed the label's number of lines
		CGSize textConstraint = CGSizeMake(label.frame.size.width, MAXFLOAT);
		CGFloat textHeight = [labelText sizeWithFont:label.font constrainedToSize:textConstraint
									   lineBreakMode:label.lineBreakMode].height;
		if(textHeight > labelFrame.size.height) 
		{
			//add ellipsis
			[labelText appendString:@"..."];
			//range of last character
			NSRange range = {labelText.length - 4, 1};
			
			do 
			{
				[labelText deleteCharactersInRange:range];
				range.location--;
				textHeight = [labelText sizeWithFont:label.font constrainedToSize:textConstraint
									   lineBreakMode:label.lineBreakMode].height;
			} while (textHeight > labelFrame.size.height);
		}
        
        label.text = labelText;
	}
}

#pragma mark -
#pragma mark UITextView methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)_textView
{
    if(!_textView.inputAccessoryView)
        _textView.inputAccessoryView = self.ownerTableViewModel.inputAccessoryView;
    if([_textView.inputAccessoryView isKindOfClass:[SCInputAccessoryView class]])
        [(SCInputAccessoryView *)_textView.inputAccessoryView setShowClearButton:self.showClearButtonInInputAccessoryView];
    
	BOOL shouldBegin = TRUE;
    
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
	   && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:rowAtIndexPath:textViewShouldBeginEditing:)])
	{
		NSIndexPath *indexPath = [self.ownerTableViewModel.tableView indexPathForCell:self];
		shouldBegin = [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
                                                         rowAtIndexPath:indexPath textViewShouldBeginEditing:_textView];
	}
    
    if(shouldBegin)
    {
        [SCModelCenter sharedModelCenter].keyboardIssuer = self.ownerTableViewModel.viewController;
        
        self.ownerTableViewModel.activeCell = self;
        self.ownerTableViewModel.activeCellControl = _textView;
    }
    
	return shouldBegin;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)_textView
{
	[SCModelCenter sharedModelCenter].keyboardIssuer = self.ownerTableViewModel.viewController;
	return TRUE;
}

- (void)textViewDidChange:(UITextView *)_textView
{
	if(_pauseControlEvents)
		return;
	
	[self cellValueChanged];
}

#pragma mark -
#pragma mark UITextField methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)_textField
{
    if(!_textField.inputAccessoryView)
        _textField.inputAccessoryView = self.ownerTableViewModel.inputAccessoryView;
    if([_textField.inputAccessoryView isKindOfClass:[SCInputAccessoryView class]])
        [(SCInputAccessoryView *)_textField.inputAccessoryView setShowClearButton:self.showClearButtonInInputAccessoryView];
    
    BOOL shouldBegin = TRUE;
    
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
	   && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:rowAtIndexPath:textFieldShouldBeginEditing:)])
	{
		NSIndexPath *indexPath = [self.ownerTableViewModel.tableView indexPathForCell:self];
		shouldBegin = [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
                                                         rowAtIndexPath:indexPath textFieldShouldBeginEditing:_textField];
	}
    
    if(shouldBegin)
    {
        [SCModelCenter sharedModelCenter].keyboardIssuer = self.ownerTableViewModel.viewController;
        
        self.ownerTableViewModel.activeCell = self;
        self.ownerTableViewModel.activeCellControl = _textField;
    }
    
	return shouldBegin;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
	   && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:rowAtIndexPath:textField:shouldChangeCharactersInRange:replacementString:)])
	{
		NSIndexPath *indexPath = [self.ownerTableViewModel.tableView indexPathForCell:self];
		return [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
                                                  rowAtIndexPath:indexPath textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
    // else
    return TRUE;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)_textField
{
	[SCModelCenter sharedModelCenter].keyboardIssuer = self.ownerTableViewModel.viewController;
	return TRUE;
}

- (void)textFieldEditingChanged:(id)sender
{
	if(_pauseControlEvents)
		return;
	
	[self cellValueChanged];
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
	if(self.cellActions.returnButtonTapped)
	{
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
		self.cellActions.returnButtonTapped(self, indexPath);
        
		return TRUE;
	}
    // else
    if(self.ownerSection.cellActions.returnButtonTapped)
	{
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
		self.ownerSection.cellActions.returnButtonTapped(self, indexPath);
        
		return TRUE;
	}
    // else
    if(self.ownerTableViewModel.cellActions.returnButtonTapped)
	{
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
		self.ownerTableViewModel.cellActions.returnButtonTapped(self, indexPath);
        
		return TRUE;
	}
	
	if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
	   && [self.ownerTableViewModel.delegate 
		   respondsToSelector:@selector(tableViewModel:returnButtonTappedForRowAtIndexPath:)])
	{
		NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
		[self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
					  returnButtonTappedForRowAtIndexPath:indexPath];
		return TRUE;
	}
	
	BOOL handeledReturn;
	switch (_textField.returnKeyType)
	{
		case UIReturnKeyDefault:
		case UIReturnKeyNext:
			[self.ownerTableViewModel moveToNextCellControl:TRUE];
			handeledReturn = TRUE;
			break;
			
		case UIReturnKeyDone: 
			[_textField resignFirstResponder];
			handeledReturn = TRUE;
			break;
			
		default:
			handeledReturn = FALSE;
			break;
	}
	
	return handeledReturn;
}

#pragma mark -
#pragma mark UISlider methods

- (void)sliderValueChanged:(id)sender
{	
	if(_pauseControlEvents)
		return;
	
	self.ownerTableViewModel.activeCell = self;
    self.ownerTableViewModel.activeCellControl = sender;
	
	[self cellValueChanged];
}

#pragma mark -
#pragma mark UISegmentedControl methods

- (void)segmentedControlValueChanged:(id)sender
{
	if(_pauseControlEvents)
		return;
	
	self.ownerTableViewModel.activeCell = self;
    self.ownerTableViewModel.activeCellControl = sender;
	
	[self cellValueChanged];
}

#pragma mark -
#pragma mark UISwitch methods

- (void)switchControlChanged:(id)sender
{
	if(_pauseControlEvents)
		return;
	
	self.ownerTableViewModel.activeCell = self;
    self.ownerTableViewModel.activeCellControl = sender;
	
	[self cellValueChanged];
}

#pragma mark -
#pragma mark UIButton methods

- (void)customButtonTapped:(id)sender
{
    if(self.cellActions.customButtonTapped)
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        self.cellActions.customButtonTapped(self, indexPath, sender);
    }
    else 
        if(self.ownerSection.cellActions.customButtonTapped)
        {
            NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
            self.ownerSection.cellActions.customButtonTapped(self, indexPath, sender);
        }
        else 
            if(self.ownerTableViewModel.cellActions.customButtonTapped)
            {
                NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
                self.ownerTableViewModel.cellActions.customButtonTapped(self, indexPath, sender);
            }
    else 
	if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate 
           respondsToSelector:@selector(tableViewModel:customButtonTapped:forRowWithIndexPath:)])
    {
        NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
        [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                                       customButtonTapped:sender
                                      forRowWithIndexPath:indexPath];
    }
}


@end












@implementation SCControlCell

@synthesize control;
@synthesize maxTextLabelWidth;
@synthesize controlIndentation;
@synthesize controlMargin;


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	control = nil;
	
    maxTextLabelWidth = SC_DefaultMaxTextLabelWidth;
	controlIndentation = SC_DefaultControlIndentation;
	controlMargin = SC_DefaultControlMargin;
}

//overrides superclass
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    for(UIView *subview in self.contentView.subviews)
    {
        if([subview isKindOfClass:[UIControl class]] || [subview isKindOfClass:[UITextView class]] || [subview isKindOfClass:[UILabel class]])
        {
            if(!self.backgroundView)
                [(UIControl *)subview setBackgroundColor:backgroundColor];
        }
    }
}

//overrides superclass
- (void)setBackgroundView:(UIView *)backgroundView
{
    [super setBackgroundView:backgroundView];
    
    if(backgroundView)
    {
        for(UIView *subview in self.contentView.subviews)
        {
            if([subview isKindOfClass:[UIControl class]] || [subview isKindOfClass:[UITextView class]] || [subview isKindOfClass:[UILabel class]])
            {
                [(UIControl *)subview setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
}


//overrides superclass
- (CGFloat)height
{
    if(!self.needsCommit)
    {
        [self loadBoundValueIntoControl];
    }
    
    return [super height];
}

//overrides superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect textLabelFrame;
	if([self.textLabel.text length])
		textLabelFrame = self.textLabel.frame;
	else
		textLabelFrame = CGRectMake(0, SC_DefaultControlMargin, 0, SC_DefaultControlHeight);
	
	// Modify the textLabel frame to take only it's text width instead of the full cell width
	if([self.textLabel.text length])
	{
		CGSize constraintSize = CGSizeMake(self.maxTextLabelWidth, MAXFLOAT);
		textLabelFrame.size.width = [self.textLabel.text sizeWithFont:self.textLabel.font 
													constrainedToSize:constraintSize 
														lineBreakMode:self.textLabel.lineBreakMode].width;
	}
    
    self.textLabel.frame = textLabelFrame;
	
	// Layout the control next to self.textLabel, with it's same yCoord & height
	CGFloat indentation = self.controlIndentation;
	if(textLabelFrame.size.width == 0)
    {
        indentation = 0;
        if(self.imageView.image)
            textLabelFrame = self.imageView.frame;
    }
		
	CGSize contentViewSize = self.contentView.bounds.size;
	CGFloat controlXCoord = textLabelFrame.origin.x+textLabelFrame.size.width+self.controlMargin;
	if(controlXCoord < indentation)
		controlXCoord = indentation;
	CGRect controlFrame = CGRectMake(controlXCoord, 
									 textLabelFrame.origin.y, 
									 contentViewSize.width - controlXCoord - self.controlMargin, 
									 textLabelFrame.size.height);
	self.control.frame = controlFrame;
	
	[self didLayoutSubviews];
}

//override superclass
- (void)willDisplay
{
	[super willDisplay];
	
	if(!self.needsCommit)
	{
		[self loadBoundValueIntoControl];
	}
		
}

//override superclass
- (void)reloadBoundValue
{
    [super reloadBoundValue];
    
	[self loadBoundValueIntoControl];
}


- (NSObject *)controlValue
{
	// must be overridden by subclasses
    return nil;
}

- (void)loadBoundValueIntoControl
{
	// does nothing, should be overridden by subclasses
}

- (void)clearControl
{
    // does nothing, should be overridden by subclasses
}

@end






@implementation SCLabelCell


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object labelTextPropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object labelTextPropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];

	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	control = [[UILabel alloc] init];
	self.label.textAlignment = NSTextAlignmentRight;
    self.label.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
	self.label.highlightedTextColor = self.textLabel.highlightedTextColor;
	self.label.backgroundColor = self.backgroundColor;
	[self.contentView addSubview:self.label];
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object labelTextPropertyName:(NSString *)propertyName
{
	return [self initWithText:cellText boundObject:object boundPropertyName:propertyName];
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled)
        self.label.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
    else
        self.label.textColor = self.textLabel.textColor;
}

//overrides superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
    // Adjust label position
	CGRect labelFrame = self.label.frame;
	labelFrame.size.height -= 1;
	self.label.frame = labelFrame;
    
    [self didLayoutSubviews];
}

//overrides superclass
- (NSObject *)controlValue
{
	return self.label.text;
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	if(self.boundPropertyName)
	{
		NSObject *val = self.boundValue;
		if(!val)
			val = @"";
		self.label.text = [NSString stringWithFormat:@"%@", val];
	}
}

- (UILabel *)label
{
	return (UILabel *)control;
}

@end










#define kTextViewMargin 5.0f

@interface SCTextViewCell ()

- (void)layoutTextView;

- (CGFloat)textViewContentHeight;

@end


@implementation SCTextViewCell

@synthesize minimumHeight;
@synthesize maximumHeight;


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object textViewTextPropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object textViewTextPropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	initializing = TRUE;
    prevContentHeight = 0;
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	height = 87;
    minimumHeight = 87;		// 3 lines with default font
	maximumHeight = 162;
	
    control = [[UITextView alloc] init];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //self.textView.scrollEnabled = FALSE;
	self.textView.delegate = self; 
	
	self.textView.font = [UIFont fontWithName:self.textView.font.fontName size:SC_DefaultTextViewFontSize];
    self.textView.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
	[self.contentView addSubview:self.textView];  
}	

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object textViewTextPropertyName:(NSString *)propertyName
{
	return [self initWithText:cellText boundObject:object boundPropertyName:propertyName];
}


//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled)
        self.textView.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
    else
        self.textView.textColor = self.textLabel.textColor;
}

- (CGFloat)textViewContentHeight
{
    CGFloat contentHeight = self.textView.contentSize.height;
    
    if(contentHeight < self.minimumHeight-kTextViewMargin)
    {
        contentHeight = self.minimumHeight-kTextViewMargin;
    }
    if(contentHeight > self.maximumHeight-kTextViewMargin)
    {
        contentHeight = self.maximumHeight-kTextViewMargin;
        
        //self.textView.scrollEnabled = TRUE;
    }
    else
    {
        //self.textView.scrollEnabled = FALSE;
    }
    
    return contentHeight;
}

//overrides superclass
- (CGFloat)height
{
	if(self.autoResize)
	{
        if(initializing)
		{
            if(self.boundPropertyName && [SCUtilities isStringClass:[self.boundValue class]])
			{
				_pauseControlEvents = TRUE;
                self.textView.text = (NSString *)self.boundValue;
				_pauseControlEvents = FALSE;
			}
            [self layoutTextView];
		}
		
		CGFloat _height = self.minimumHeight;
		if([self.textView.text length] > 1)
		{
            _height = [self textViewContentHeight] + kTextViewMargin;
		}
        
        if(initializing)
        {
            // The following hack guarantees that the initial height of the cell is correct when it contains text that exceeds its minimum height
            [self performSelector:@selector(updateTextViewCellHeight) withObject:nil afterDelay:0.01f];
            
            initializing = FALSE;
        }
		
		return _height;
	}
	// else
	return height;
}

- (void)updateTextViewCellHeight
{
    [self.ownerTableViewModel.tableView beginUpdates];
    [self.ownerTableViewModel.tableView endUpdates];
}

//overrides superclass
- (BOOL)canBecomeFirstResponder
{
    return TRUE;
}

//overrides superclass
- (BOOL)becomeFirstResponder
{
	[self.textView becomeFirstResponder];
    return TRUE;
}

//overrides superclass
- (BOOL)resignFirstResponder
{
	[self.textView resignFirstResponder];
    return TRUE;
}

//overrides superclass
- (void)layoutSubviews
{	
	[super layoutSubviews];
	
    [self layoutTextView];
	
    
	[self didLayoutSubviews];
}

- (void)layoutTextView
{	
	CGSize contentViewSize = self.contentView.bounds.size;
	CGRect textLabelFrame = self.textLabel.frame;
	CGFloat textViewXCoord = textLabelFrame.origin.x+textLabelFrame.size.width+self.controlMargin;
	CGFloat indentation = self.controlIndentation;
	if(textLabelFrame.size.width == 0)
		indentation = 13;	
	if(textViewXCoord < indentation)
		textViewXCoord = indentation;
	textViewXCoord -= 8; // to account for UITextView padding
    
    CGFloat textViewHeight = self.contentView.frame.size.height;
	CGRect textViewFrame = CGRectMake(textViewXCoord+2, 2, 
									  contentViewSize.width - textViewXCoord - self.controlMargin, textViewHeight-kTextViewMargin);
    
	self.textView.frame = textViewFrame;
}

//overrides superclass
- (NSObject *)controlValue
{
	return self.textView.text;
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	if(self.boundPropertyName && (!self.boundValue || [SCUtilities isStringClass:[self.boundValue class]]) )
	{
		_pauseControlEvents = TRUE;
		self.textView.text = (NSString *)self.boundValue;
		_pauseControlEvents = FALSE;
	}
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	self.boundValue = self.textView.text;
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCTextViewAttributes class]])
		return;
	
	SCTextViewAttributes *textViewAttributes = (SCTextViewAttributes *)attributes;
	self.autoResize = textViewAttributes.autoResize;
	self.textView.editable = textViewAttributes.editable;
    if(textViewAttributes.minimumHeight > 0)
    {
        self.minimumHeight = textViewAttributes.minimumHeight;
        if(!self.autoResize)
            self.height = self.minimumHeight;
    }
	if(textViewAttributes.maximumHeight > 0)
		self.maximumHeight = textViewAttributes.maximumHeight;
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if(![self.textView.text length] && self.valueRequired)
		return FALSE;
	//else
	return TRUE;
}

- (UITextView *)textView
{
	return (UITextView *)control;
}

- (void)clearControl
{
    self.textView.text = nil;
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)_textView
{		
	if(_pauseControlEvents)
		return;
	
	if(_textView != self.textView)
	{
		[super textViewDidChange:_textView];
		return;
	}
	
	[self cellValueChanged];
	
    
	// resize cell if needed
	if(self.autoResize) 
	{
        // This hack insures that self.textView.contentSize.height will return the correct value
        [self performSelector:@selector(resizeTextViewCell) withObject:nil afterDelay:0.01f];
	}
}

- (void)resizeTextViewCell
{
    CGFloat contentHeight = [self textViewContentHeight];
    
    if(prevContentHeight != contentHeight)
    {
        // resize cell by reloading it
        [self.ownerTableViewModel.tableView beginUpdates];
        [self.ownerTableViewModel.tableView endUpdates];
        
        prevContentHeight = contentHeight;
    }
}

@end






@implementation SCTextFieldCell


+ (id)cellWithText:(NSString *)cellText placeholder:(NSString *)placeholder boundObject:(NSObject *)object textFieldTextPropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText placeholder:placeholder boundObject:object textFieldTextPropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];

	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	control = [[UITextField alloc] init];
	self.textField.delegate = self;
	[self.textField addTarget:self action:@selector(textFieldEditingChanged:) 
			 forControlEvents:UIControlEventEditingChanged];
	self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
	[self.contentView addSubview:self.textField];
}

- (id)initWithText:(NSString *)cellText placeholder:(NSString *)placeholder boundObject:(NSObject *)object textFieldTextPropertyName:(NSString *)propertyName
{
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.textField.placeholder = placeholder;
	}
	return self;
}


//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled)
        self.textField.textColor = [UIColor colorWithRed:50.0f/255 green:79.0f/255 blue:133.0f/255 alpha:1];
    else
        self.textField.textColor = self.textLabel.textColor;
}

//overrides superclass
- (BOOL)canBecomeFirstResponder
{
    return TRUE;
}

//overrides superclass
- (BOOL)becomeFirstResponder
{
	[self.textField becomeFirstResponder];
    return TRUE;
}

//overrides superclass
- (BOOL)resignFirstResponder
{
	[self.textField resignFirstResponder];
    return TRUE;
}

//override's superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// Adjust height & yCoord
	CGRect textFieldFrame = self.textField.frame;
	textFieldFrame.origin.y = (self.contentView.frame.size.height - SC_DefaultTextFieldHeight)/2;
	textFieldFrame.size.height = SC_DefaultTextFieldHeight;
	self.textField.frame = textFieldFrame;
    
	
	[self didLayoutSubviews];
}

//overrides superclass
- (NSObject *)controlValue
{
	return self.textField.text;
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	if(self.boundPropertyName && (!self.boundValue || [SCUtilities isStringClass:[self.boundValue class]]) )
	{
		_pauseControlEvents = TRUE;
		self.textField.text = (NSString *)self.boundValue;
		_pauseControlEvents = FALSE;
	}
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	self.boundValue = self.controlValue;
	
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCTextFieldAttributes class]])
		return;
	
	SCTextFieldAttributes *textFieldAttributes = (SCTextFieldAttributes *)attributes;
	if(textFieldAttributes.placeholder)
		self.textField.placeholder = textFieldAttributes.placeholder;
    self.textField.secureTextEntry = textFieldAttributes.secureTextEntry;
    self.textField.autocorrectionType = textFieldAttributes.autocorrectionType;
    self.textField.autocapitalizationType = textFieldAttributes.autocapitalizationType;
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if(![self.textField.text length] && self.valueRequired)
		return FALSE;
	//else
	return TRUE;
}

- (UITextField *)textField
{
	return (UITextField *)control;
}

- (void)clearControl
{
    self.textField.text = nil;
}

@end





@implementation SCNumericTextFieldCell

@synthesize minimumValue;
@synthesize maximumValue;
@synthesize allowFloatValue;
@synthesize displayZeroAsBlank;
@synthesize numberFormatter;



//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	
	minimumValue = nil;
	maximumValue = nil;
	allowFloatValue = TRUE;
	displayZeroAsBlank = FALSE;
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}


//overrides superclass
- (NSObject *)controlValue
{
    NSObject *value = nil;
    if([self.textField.text length])
    {
        [numberFormatter setMinimum:self.minimumValue];
        [numberFormatter setMaximum:self.maximumValue];
        [numberFormatter setAllowsFloats:self.allowFloatValue];
        
        value = [numberFormatter numberFromString:self.textField.text];
    }
    
	return value;
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	if( self.boundPropertyName && (!self.boundValue || [self.boundValue isKindOfClass:[NSNumber class]]))
	{
		_pauseControlEvents = TRUE;
		
		NSNumber *numericValue = (NSNumber *)self.boundValue;
		if(numericValue)
		{
			if([numericValue intValue]==0 && self.displayZeroAsBlank)
				self.textField.text = nil;
			else
            {
                [numberFormatter setMinimum:self.minimumValue];
                [numberFormatter setMaximum:self.maximumValue];
                [numberFormatter setAllowsFloats:self.allowFloatValue];
                
                self.textField.text = [numberFormatter stringFromNumber:numericValue];
            }
		}
		else
		{
			self.textField.text = nil;
		}
		
		_pauseControlEvents = FALSE;
	}
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCNumericTextFieldAttributes class]])
		return;
	
	SCNumericTextFieldAttributes *numericTextFieldAttributes = 
											(SCNumericTextFieldAttributes *)attributes;
	if(numericTextFieldAttributes.minimumValue)
		self.minimumValue = numericTextFieldAttributes.minimumValue;
	if(numericTextFieldAttributes.maximumValue)
		self.maximumValue = numericTextFieldAttributes.maximumValue;
	self.allowFloatValue = numericTextFieldAttributes.allowFloatValue;
    if(numericTextFieldAttributes.numberFormatter)
    {
        numberFormatter = numericTextFieldAttributes.numberFormatter;
    }
}

//overrides superclass
- (BOOL)getValueIsValid
{	
	if(![self.textField.text length])
	{
		if(self.valueRequired)
			return FALSE;
		//else
		return TRUE;
	}
		
	[numberFormatter setMinimum:self.minimumValue];
	[numberFormatter setMaximum:self.maximumValue];
	[numberFormatter setAllowsFloats:self.allowFloatValue];
	BOOL valid;
	if([numberFormatter numberFromString:self.textField.text])
		valid = TRUE;
	else
		valid = FALSE;
		
	return valid;
}


@end







@implementation SCSliderCell


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object sliderValuePropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object sliderValuePropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	control = [[UISlider alloc] init];
	[self.slider addTarget:self action:@selector(sliderValueChanged:) 
		  forControlEvents:UIControlEventValueChanged];
	self.slider.continuous = FALSE;
	[self.contentView addSubview:self.slider];
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object sliderValuePropertyName:(NSString *)propertyName
{
	return [self initWithText:cellText boundObject:object boundPropertyName:propertyName];
}


//overrides superclass
- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object boundPropertyName:(NSString *)propertyName
{
	self = [super initWithText:cellText boundObject:object boundPropertyName:propertyName];
	
	if(self.boundObject && !self.boundValue && self.commitChangesLive)
		self.boundValue = [NSNumber numberWithFloat:self.slider.value];
	
	return self;
}


//overrides superclass
- (NSObject *)controlValue
{
    return [NSNumber numberWithFloat:self.slider.value];
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	if(self.boundPropertyName && [self.boundValue isKindOfClass:[NSNumber class]])
	{
		_pauseControlEvents = TRUE;
		self.slider.value = [(NSNumber *)self.boundValue floatValue];
		_pauseControlEvents = FALSE;
	}
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	self.boundValue = self.controlValue;
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCSliderAttributes class]])
		return;
	
	SCSliderAttributes *sliderAttributes = (SCSliderAttributes *)attributes;
	if(sliderAttributes.minimumValue >= 0)
		self.slider.minimumValue = sliderAttributes.minimumValue;
	if(sliderAttributes.maximumValue >= 0)
		self.slider.maximumValue = sliderAttributes.maximumValue;
}

- (UISlider *)slider
{
	return (UISlider *)control;
}

@end






@implementation SCSegmentedCell


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectedSegmentIndexPropertyName:(NSString *)propertyName segmentTitlesArray:(NSArray *)cellSegmentTitlesArray
{
	return [[[self class] alloc] initWithText:cellText boundObject:object selectedSegmentIndexPropertyName:propertyName
						segmentTitlesArray:cellSegmentTitlesArray];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	control = [[UISegmentedControl alloc] init];
	[self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) 
					forControlEvents:UIControlEventValueChanged];
	self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[self.contentView addSubview:self.segmentedControl];
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectedSegmentIndexPropertyName:(NSString *)propertyName segmentTitlesArray:(NSArray *)cellSegmentTitlesArray
{
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		[self createSegmentsUsingArray:cellSegmentTitlesArray];
	}
	return self;
}


//overrides superclass
- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object boundPropertyName:(NSString *)propertyName
{
	self = [super initWithText:cellText boundObject:object boundPropertyName:propertyName];
	
	if(self.boundObject && !self.boundValue)
		self.boundValue = [NSNumber numberWithInt:-1];
	
	return self;
}


//override's superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// Adjust height & yCoord
	CGRect segmentedFrame = self.segmentedControl.frame;
	segmentedFrame.origin.y = (self.contentView.frame.size.height - SC_DefaultSegmentedControlHeight)/2;
	segmentedFrame.size.height = SC_DefaultSegmentedControlHeight;
	self.segmentedControl.frame = segmentedFrame;
	
	
	[self didLayoutSubviews];
}

//overrides superclass
- (NSObject *)controlValue
{
    return [NSNumber numberWithUnsignedInteger:self.segmentedControl.selectedSegmentIndex];
}

//override's superclass
- (void)loadBoundValueIntoControl
{
	if(self.boundPropertyName && [self.boundValue isKindOfClass:[NSNumber class]])
	{
		_pauseControlEvents = TRUE;
		self.segmentedControl.selectedSegmentIndex = [(NSNumber *)self.boundValue intValue];
		_pauseControlEvents = FALSE;
	}
}

//override's superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	self.boundValue = self.controlValue;
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCSegmentedAttributes class]])
		return;
	
	SCSegmentedAttributes *segmentedAttributes = (SCSegmentedAttributes *)attributes;
	if(segmentedAttributes.segmentTitlesArray)
		[self createSegmentsUsingArray:segmentedAttributes.segmentTitlesArray];
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if( (self.segmentedControl.selectedSegmentIndex==-1) && self.valueRequired )
		return FALSE;
	//else
	return TRUE;
}

- (UISegmentedControl *)segmentedControl
{
	return (UISegmentedControl *)control;
}

- (void)createSegmentsUsingArray:(NSArray *)segmentTitlesArray
{
	[self.segmentedControl removeAllSegments];
	if(segmentTitlesArray)
	{
		for(NSUInteger i=0; i<segmentTitlesArray.count; i++)
		{
			NSString *segmentTitle = (NSString *)[segmentTitlesArray objectAtIndex:i];
			[self.segmentedControl insertSegmentWithTitle:segmentTitle atIndex:i 
												 animated:FALSE];
		}
	}
}


@end






@implementation SCSwitchCell


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object switchOnPropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object switchOnPropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	control = [[UISwitch alloc] init];
	[self.switchControl addTarget:self action:@selector(switchControlChanged:) 
				 forControlEvents:UIControlEventValueChanged];
	[self.contentView addSubview:self.switchControl];
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object switchOnPropertyName:(NSString *)propertyName
{
	return [self initWithText:cellText boundObject:object boundPropertyName:propertyName];
}

//overrides superclass
- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object boundPropertyName:(NSString *)propertyName
{
	self = [super initWithText:cellText boundObject:object boundPropertyName:propertyName];
	
	if(self.boundObject && !self.boundValue && self.commitChangesLive)
		self.boundValue = [NSNumber numberWithBool:self.switchControl.on];
	
	return self;
}


//overrides superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize contentViewSize = self.contentView.bounds.size;
	CGRect switchFrame = self.switchControl.frame;
	switchFrame.origin.x = contentViewSize.width - switchFrame.size.width - 10;
	switchFrame.origin.y = (contentViewSize.height-switchFrame.size.height)/2;
	self.switchControl.frame = switchFrame;
	
	
	[self didLayoutSubviews];
}

//overrides superclass
- (NSObject *)controlValue
{
    return [NSNumber numberWithBool:self.switchControl.on];
}

//overrides superclass
- (void)loadBoundValueIntoControl
{	
	if(self.boundPropertyName && [self.boundValue isKindOfClass:[NSNumber class]])
	{
		_pauseControlEvents = TRUE;
		self.switchControl.on = [(NSNumber *)self.boundValue boolValue];
		_pauseControlEvents = FALSE;
	}
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	[super commitChanges];
	
	self.boundValue = self.controlValue;
	needsCommit = FALSE;
}

- (UISwitch *)switchControl
{
	return (UISwitch *)control;
}

@end







@interface SCDateCell ()
{
    BOOL _dateCleared;
}

- (BOOL)shouldDisplayPickerInDetailView;
- (void)pickerValueChanged;
- (void)deviceOrientationDidChange:(NSNotification *)notification;

@end



@implementation SCDateCell

@synthesize datePicker;
@synthesize dateFormatter;
@synthesize displaySelectedDate;
@synthesize displayDatePickerInDetailView;


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object datePropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object datePropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
    
    _dateCleared = FALSE;
    _activePickerDetailViewController = nil;
	
	datePicker = [[UIDatePicker alloc] init];
	[datePicker addTarget:self action:@selector(pickerValueChanged) 
		 forControlEvents:UIControlEventValueChanged];
	
	pickerField = [[UITextField alloc] initWithFrame:CGRectZero];
	pickerField.delegate = self;
	pickerField.inputView = datePicker;
	[self.contentView addSubview:pickerField];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d  hh:mm a"];
	displaySelectedDate = TRUE;
	displayDatePickerInDetailView = FALSE;
    self.showClearButtonInInputAccessoryView = TRUE;
	
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // Track device orientation changes to correctly show/hide the date picker
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object:nil];
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object datePropertyName:(NSString *)propertyName
{
	return [self initWithText:cellText boundObject:object boundPropertyName:propertyName];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


//overrides superclass
- (BOOL)canBecomeFirstResponder
{
    if([self shouldDisplayPickerInDetailView])
        return FALSE;
    //else
    return TRUE;
}

//overrides superclass
- (BOOL)becomeFirstResponder
{
    if(![self shouldDisplayPickerInDetailView])
    {
        [pickerField becomeFirstResponder];
        return TRUE;
    }
    //else
    return FALSE;
}

//overrides superclass
- (BOOL)resignFirstResponder
{
	return [pickerField resignFirstResponder];
}

//overrides superclass
- (NSObject *)controlValue
{
    NSObject *value = nil;
    if(self.label.text)  // a date has been selected
        value = self.datePicker.date;
    
    return value;
}

//overrides superclass
- (void)loadBoundValueIntoControl
{
	// Set the picker's frame before setting its value (required for iPad compatability)
	CGRect pickerFrame = CGRectZero;

	if([SCUtilities is_iPad])
		pickerFrame.size.width = self.ownerTableViewModel.viewController.contentSizeForViewInPopover.width;
	else
		pickerFrame.size.width = self.ownerTableViewModel.viewController.view.frame.size.width;
	pickerFrame.size.height = 216;
	self.datePicker.frame = pickerFrame;
	
	NSDate *date = nil;
	if(self.boundPropertyName && [self.boundValue isKindOfClass:[NSDate class]])
	{
		date = (NSDate *)self.boundValue;
		self.datePicker.date = date;
	}
	
	self.label.text = [dateFormatter stringFromDate:date];
	self.label.hidden = !self.displaySelectedDate;
}

//override superclass
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if([self shouldDisplayPickerInDetailView] && self.enabled)
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		self.accessoryType = UITableViewCellAccessoryNone;
}

//override superclass
- (void)cellValueChanged
{
    if(!_dateCleared)
        self.label.text = [dateFormatter stringFromDate:self.datePicker.date];
    else
        _dateCleared = FALSE; // reset flag
	
	[super cellValueChanged];
}

//overrides superclass
- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
	[self cellValueChanged];
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	if(self.label.text)	// if a date value have been selected
		self.boundValue = self.datePicker.date;
    else
        self.boundValue = nil;
    
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCDateAttributes class]])
		return;
	
	SCDateAttributes *dateAttributes = (SCDateAttributes *)attributes;
	if(dateAttributes.dateFormatter)
		self.dateFormatter = dateAttributes.dateFormatter;
	self.datePicker.datePickerMode = dateAttributes.datePickerMode;
	self.displayDatePickerInDetailView = dateAttributes.displayDatePickerInDetailView;
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if(!self.label.text && self.valueRequired)
		return FALSE;
	//else
	return TRUE;
}

//override parent's
- (void)didSelectCell
{
    [super didSelectCell];
    
	self.ownerTableViewModel.activeCell = self;
	
	if(![self shouldDisplayPickerInDetailView])
	{
		if(![pickerField isFirstResponder])
		{
			[self cellValueChanged];
			[pickerField becomeFirstResponder];
		}
		
		return;
	}
	
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    _activePickerDetailViewController = [self getDetailViewControllerForCell:self forRowAtIndexPath:indexPath allowUITableViewControllerSubclass:NO];
    
    if(!self.detailViewControllerOptions.title)
		_activePickerDetailViewController.title = self.textLabel.text;
	if([SCUtilities is_iPad])
		_activePickerDetailViewController.view.backgroundColor = [UIColor colorWithRed:32.0f/255 green:35.0f/255 blue:42.0f/255 alpha:1];
	else
		_activePickerDetailViewController.view.backgroundColor = [UIColor colorWithRed:41.0f/255 green:42.0f/255 blue:57.0f/255 alpha:1];
    [_activePickerDetailViewController.view addSubview:self.datePicker];
    
    [self presentDetailViewController:_activePickerDetailViewController forCell:self forRowAtIndexPath:indexPath withPresentationMode:self.detailViewControllerOptions.presentationMode];
}

- (BOOL)shouldDisplayPickerInDetailView
{
	BOOL displayInDetailView = TRUE;
	if(!self.displayDatePickerInDetailView && [SCUtilities systemVersion]>=3.2f)
	{
		if([SCUtilities is_iPad])
		{
			displayInDetailView = FALSE;
		}
		else 
		{
			UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            if(UIInterfaceOrientationIsPortrait(orientation))
			{
				displayInDetailView = FALSE;
			}
		}
	}
	return displayInDetailView;
}

- (void)willDeselectCell
{	
	if(activeDetailModel)
	{
		// Remove datePicker
		[self.datePicker removeFromSuperview];
	}
    
    [super willDeselectCell];
}

- (void)pickerValueChanged
{
	if(![self shouldDisplayPickerInDetailView])
		[self cellValueChanged];
}

- (void)clearControl
{
    self.label.text = nil;
    _dateCleared = TRUE;
    
    [self cellValueChanged];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    if(_activePickerDetailViewController)
    {
        UIViewController *detailVC = _activePickerDetailViewController;
        if([detailVC isKindOfClass:[SCViewController class]])
        {
            SCViewController *viewController = (SCViewController *)detailVC;
            [viewController dismissWithCancelValue:YES doneValue:NO];
        }
        else
            if([detailVC isKindOfClass:[SCTableViewController class]])
            {
                SCTableViewController *viewController = (SCTableViewController *)detailVC;
                [viewController dismissWithCancelValue:YES doneValue:NO];
            }
        
        _activePickerDetailViewController = nil;
        [self setActiveDetailModel:nil];
    }
    else
        [self resignFirstResponder];
}

#pragma mark -
#pragma mark SCViewControllerDelegate methods

// overrides superclass
- (void)handleDetailViewControllerWillPresent:(UIViewController *)detailViewController
{
    // Center the picker in the detailViewController
	CGRect pickerFrame = self.datePicker.frame;
	pickerFrame.origin.x = (detailViewController.view.frame.size.width - pickerFrame.size.width)/2;
	self.datePicker.frame = pickerFrame;
    
    [super handleDetailViewControllerWillPresent:detailViewController];
}

// overrides superclass
- (void)handleDetailViewControllerWillDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
    [super handleDetailViewControllerWillDismiss:detailViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];
    
    if(doneTapped)
        [self cellValueChanged];
    
    _activePickerDetailViewController = nil;
}


@end






@interface SCImagePickerCell ()

- (NSString *)selectedImagePath;
- (void)setCachedImage;
- (void)displayImagePicker;
- (void)displayImageInDetailView;
- (void)addImageViewToDetailView:(UIViewController *)detailView;
- (void)didTapClearImageButton;

@end



@implementation SCImagePickerCell

@synthesize imagePickerController;
@synthesize placeholderImageName;
@synthesize placeholderImageTitle;
@synthesize displayImageNameAsCellText;
@synthesize askForSourceType;
@synthesize selectedImageName;
@synthesize clearImageButton;
@synthesize displayClearImageButtonInDetailView;
@synthesize autoPositionClearImageButton;
@synthesize textLabelFrame;
@synthesize imageViewFrame;

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object imageNamePropertyName:(NSString *)propertyName
{
	return [[[self class] alloc] initWithText:cellText boundObject:object imageNamePropertyName:propertyName];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	cachedImage = nil;
	detailImageView = nil;

	popover = nil;
	
	imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	
	placeholderImageName = nil;
	placeholderImageTitle = nil;
	displayImageNameAsCellText = TRUE;
	askForSourceType = TRUE;
	selectedImageName = nil;
	autoPositionImageView = TRUE;
	
	clearImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	clearImageButton.frame = CGRectMake(0, 0, 120, 25);
	[clearImageButton setTitle:NSLocalizedString(@"Clear Image", @"Clear Image Button Title") forState:UIControlStateNormal];
	[clearImageButton addTarget:self action:@selector(didTapClearImageButton) 
			   forControlEvents:UIControlEventTouchUpInside];
	clearImageButton.backgroundColor = [UIColor grayColor];
	clearImageButton.layer.cornerRadius = 8.0f;
	clearImageButton.layer.masksToBounds = YES;
	clearImageButton.layer.borderWidth = 1.0f;
	displayClearImageButtonInDetailView = TRUE;
	autoPositionClearImageButton = TRUE;
	
	textLabelFrame = CGRectMake(0, 0, 0, 0);
	imageViewFrame = CGRectMake(0, 0, 0, 0);
	
	// Add rounded corners to the image view
	self.imageView.layer.masksToBounds = YES;
	self.imageView.layer.cornerRadius = 8.0f;
	
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object imageNamePropertyName:(NSString *)propertyName
{
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.selectedImageName = (NSString *)self.boundValue;
		[self setCachedImage];
	}
	return self;
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled)
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)resetClearImageButtonStyles
{
	clearImageButton.backgroundColor = [UIColor clearColor];
	clearImageButton.layer.cornerRadius = 0.0f;
	clearImageButton.layer.masksToBounds = NO;
	clearImageButton.layer.borderWidth = 0.0f;
}

- (UIImage *)selectedImageObject
{
	if(self.selectedImageName && !cachedImage)
		[self setCachedImage];
	
	return cachedImage;
}

- (void)setCachedImage
{
	cachedImage = nil;
	
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    NSString *imagePath = [self selectedImagePath];
    UIImage *image;
    if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
       && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:loadImageFromPath:forRowAtIndexPath:)])
    {
        image = [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel 
                                           loadImageFromPath:imagePath forRowAtIndexPath:indexPath];
    }
    else
        image = [UIImage imageWithContentsOfFile:imagePath];
    
	if(image)
	{
		cachedImage = image;
	}
}

- (NSString *)selectedImagePath
{
	if(!self.selectedImageName)
		return nil;
	
	NSString *fullName = [NSString stringWithFormat:@"Documents/%@", self.selectedImageName];
	
	return [NSHomeDirectory() stringByAppendingPathComponent:fullName];
}

//overrides superclass
- (void)layoutSubviews
{
	// call before [super layoutSubviews]
	if(self.selectedImageName)
	{
		if(self.displayImageNameAsCellText)
			self.textLabel.text = self.selectedImageName;
		
		if(!cachedImage)
			[self setCachedImage];
		
		self.imageView.image = cachedImage;
		
		if(cachedImage)
		{
			// Set the correct frame for imageView
			CGRect imgframe = self.imageView.frame;
			imgframe.origin.x = 2;
			imgframe.origin.y = 3;
			imgframe.size.height -= 4;
			self.imageView.frame = imgframe;
			self.imageView.image = cachedImage;
		}
	}
	else
	{
		if(self.displayImageNameAsCellText)
			self.textLabel.text = @"";
		
		if(self.placeholderImageName)
			self.imageView.image = [UIImage imageNamed:self.placeholderImageName];
		else
			self.imageView.image = nil;
	}
	
	[super layoutSubviews];
	
	if(self.textLabelFrame.size.height)
	{
		self.textLabel.frame = self.textLabelFrame;
	}
	if(self.imageViewFrame.size.height)
	{
		self.imageView.frame = self.imageViewFrame;
	}
}

//overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit)
		return;
	
	self.boundValue = self.selectedImageName;
	
	needsCommit = FALSE;
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if(!self.selectedImageName && self.valueRequired)
		return FALSE;
	//else
	return TRUE;
}

//override parent's
- (void)didSelectCell
{
    [super didSelectCell];
    
	self.ownerTableViewModel.activeCell = self;

	if(!self.ownerTableViewModel.tableView.editing && self.selectedImageName)
	{
		[self displayImageInDetailView];
		return;
	}
	
	BOOL actionSheetDisplayed = FALSE;
	
	if(self.askForSourceType)
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			UIActionSheet *actionSheet = [[UIActionSheet alloc]
										 initWithTitle:nil
										 delegate:self
										 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button Title")
										 destructiveButtonTitle:nil
										 otherButtonTitles:NSLocalizedString(@"Take Photo", @"Take Photo Button Title"),
										  NSLocalizedString(@"Choose Photo", @"Choose Photo Button Title"),nil];
			[actionSheet showInView:self.ownerTableViewModel.viewController.view];
			
			actionSheetDisplayed = TRUE;
		}
		else
		{
			self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
	}
	
	if(!actionSheetDisplayed)
		[self displayImagePicker];
}	

- (void)displayImageInDetailView
{
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    UIViewController *detailViewController = [self getDetailViewControllerForCell:self forRowAtIndexPath:indexPath allowUITableViewControllerSubclass:NO];
    
    if(!self.detailViewControllerOptions.title)
		detailViewController.title = self.textLabel.text;
	if([SCUtilities is_iPad])
		detailViewController.view.backgroundColor = [UIColor colorWithRed:32.0f/255 green:35.0f/255 blue:42.0f/255 alpha:1];
	else
		detailViewController.view.backgroundColor = [UIColor colorWithRed:41.0f/255 green:42.0f/255 blue:57.0f/255 alpha:1];
    
    [self presentDetailViewController:detailViewController forCell:self forRowAtIndexPath:indexPath withPresentationMode:self.detailViewControllerOptions.presentationMode];
}

- (void)addImageViewToDetailView:(UIViewController *)detailView
{
	// Add an image view with the correct image size to the detail view
	CGSize detailViewSize = detailView.view.frame.size;
	
	detailImageView = [[UIImageView alloc] init];
	detailImageView.frame = CGRectMake(0, 0, detailViewSize.width, detailViewSize.height);
	detailImageView.contentMode = UIViewContentModeScaleAspectFit;
	detailImageView.image = cachedImage;
	[detailView.view addSubview:detailImageView];
	
	//Add clearImageButton
	if(self.displayClearImageButtonInDetailView)
	{
		if(self.autoPositionClearImageButton)
		{
			CGRect btnFrame = self.clearImageButton.frame;
			self.clearImageButton.frame = CGRectMake(detailViewSize.width - btnFrame.size.width - 10,
													 detailViewSize.height - btnFrame.size.height - 10,
													 btnFrame.size.width, btnFrame.size.height);
		}
		[detailView.view addSubview:self.clearImageButton];
	}
}

- (void)didTapClearImageButton
{
	self.selectedImageName = nil;
	cachedImage = nil;
	detailImageView.image = nil;
	
	[self cellValueChanged];
}

- (void)displayImagePicker
{	
	if([SCUtilities is_iPad])
	{
		popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
		[popover presentPopoverFromRect:self.frame inView:self.ownerTableViewModel.viewController.view
			   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else
	{
        [self prepareCellForDetailViewAppearing];
        
		[self.ownerTableViewModel.viewController presentViewController:self.imagePickerController animated:TRUE completion:nil];
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet
	clickedButtonAtIndex:(NSInteger)buttonIndex
{
	BOOL cancelTapped = FALSE;
	switch (buttonIndex)
	{
		case 0:  // Take Photo
			self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			break;
		case 1:  // Choose Photo
			self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			break;	
		default:
			cancelTapped = TRUE;
			break;
	}
	
	if(!cancelTapped)
		[self displayImagePicker];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.imagePickerController dismissViewControllerAnimated:TRUE completion:nil];
	
	[self prepareCellForDetailViewDisappearing];
    
    [self handleDetailViewControllerDidDismiss:self.imagePickerController cancelButtonTapped:YES doneButtonTapped:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
	didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self.imagePickerController dismissViewControllerAnimated:TRUE completion:nil];
	
	if([SCUtilities is_iPad])
	{
		[popover dismissPopoverAnimated:TRUE];
	}
	else
	{
		[self prepareCellForDetailViewDisappearing];
	}
	
	cachedImage = nil;

    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
	UIImage *image = nil;
	if(self.imagePickerController.allowsEditing)
		image = [info valueForKey:UIImagePickerControllerEditedImage];
	if(!image)
		image = [info valueForKey:UIImagePickerControllerOriginalImage];
	if(image)
	{
		if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
           && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:imageNameForRowAtIndexPath:)])
		{
			self.selectedImageName = 
            [self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                                   imageNameForRowAtIndexPath:indexPath];
		}
		else
			self.selectedImageName = [NSString stringWithFormat:@"%@", [NSDate date]];
			
        // Save the image
        NSString *imagePath = [self selectedImagePath];
        if([self.ownerTableViewModel.delegate conformsToProtocol:@protocol(SCTableViewModelDelegate)]
           && [self.ownerTableViewModel.delegate respondsToSelector:@selector(tableViewModel:saveImage:toPath:forRowAtIndexPath:)])
		{
			[self.ownerTableViewModel.delegate tableViewModel:self.ownerTableViewModel
                                                    saveImage:image toPath:imagePath forRowAtIndexPath:indexPath];
		}
        else
            [UIImageJPEGRepresentation(image, 80) writeToFile:imagePath atomically:YES];
		
		[self layoutSubviews];
		
		
		// reload cell
        if(indexPath)
        {
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.ownerTableViewModel.tableView reloadRowsAtIndexPaths:indexPaths 
                                                             withRowAnimation:UITableViewRowAnimationNone];
        }
		
		[self cellValueChanged];
	}
    
    [self handleDetailViewControllerDidDismiss:self.imagePickerController cancelButtonTapped:NO doneButtonTapped:YES];
}


- (void)handleDetailViewControllerWillPresent:(UIViewController *)detailViewController
{
	[self addImageViewToDetailView:detailViewController];
	
	[super handleDetailViewControllerWillPresent:detailViewController];
}


@end







@interface SCSelectionCell ()
{
    @protected
    NSArray *items;
    BOOL itemsInSync;
    BOOL _loadingContents;
    UIActivityIndicatorView *_activityIndicator;
    BOOL _commitingDetailModel;
}

- (void)buildSelectedItemsIndexesFromBoundValue;
- (void)buildSelectedItemsIndexesFromString:(NSString *)string;
- (NSString *)buildStringFromSelectedItemsIndexes;

- (NSString *)getTitleForItemAtIndex:(NSUInteger)index;

@end

@implementation SCSelectionCell

@synthesize selectionItemsStore;
@synthesize selectionItemsFetchOptions;
@synthesize allowMultipleSelection;
@synthesize allowNoSelection;
@synthesize maximumSelections;
@synthesize autoDismissDetailView;
@synthesize hideDetailViewNavigationBar;
@synthesize allowAddingItems;
@synthesize allowDeletingItems;
@synthesize allowMovingItems;
@synthesize allowEditDetailView;
@synthesize displaySelection;
@synthesize delimeter;
@synthesize selectedItemsIndexes;
@synthesize placeholderCell;
@synthesize addNewItemCell;


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectedIndexPropertyName:(NSString *)propertyName items:(NSArray *)cellItems
{
	return [[[self class] alloc] initWithText:cellText boundObject:object selectedIndexPropertyName:propertyName items:cellItems];
}

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectedIndexesPropertyName:(NSString *)propertyName items:(NSArray *)cellItems allowMultipleSelection:(BOOL)multipleSelection;
{
	return [[[self class] alloc] initWithText:cellText boundObject:object selectedIndexesPropertyName:propertyName items:cellItems allowMultipleSelection:multipleSelection];
}

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectionStringPropertyName:(NSString *)propertyName items:(NSArray *)cellItems
{
	return [[[self class] alloc] initWithText:cellText boundObject:object selectionStringPropertyName:propertyName items:cellItems];
}


//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	selectionItemsStore = nil;
    selectionItemsFetchOptions = nil;  // will be re-initialized when selectionItemsStore is set
    items = nil;
    itemsInSync = FALSE;
    _loadingContents = FALSE;
    _activityIndicator = nil;
    _commitingDetailModel = FALSE;
    
	allowMultipleSelection = FALSE;
	allowNoSelection = FALSE;
	maximumSelections = 0;
	autoDismissDetailView = FALSE;
	hideDetailViewNavigationBar = FALSE;
    allowAddingItems = FALSE;
	allowDeletingItems = FALSE;
	allowMovingItems = FALSE;
	allowEditDetailView = FALSE;
	displaySelection = TRUE;
	delimeter = @", ";
	selectedItemsIndexes = [[NSMutableSet alloc] init];
    placeholderCell = nil;
    addNewItemCell = nil;
	
	self.detailViewControllerOptions.tableViewStyle = UITableViewStyleGrouped;
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectedIndexPropertyName:(NSString *)propertyName items:(NSArray *)cellItems
{	
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.boundPropertyDataType = SCDataTypeNSNumber;
        self.allowMultipleSelection = FALSE;
        
        self.selectionItemsStore = [SCMemoryStore storeWithObjectsArray:[NSMutableArray arrayWithArray:cellItems] defaultDefiniton:[SCStringDefinition definition]];
		
		[self buildSelectedItemsIndexesFromBoundValue];
		
		if(self.boundObject && !self.boundValue && self.commitChangesLive)
			self.boundValue = [NSNumber numberWithInt:-1];
	}
	return self;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectedIndexesPropertyName:(NSString *)propertyName items:(NSArray *)cellItems allowMultipleSelection:(BOOL)multipleSelection
{
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.selectionItemsStore = [SCMemoryStore storeWithObjectsArray:[NSMutableArray arrayWithArray:cellItems] defaultDefiniton:[SCStringDefinition definition]];
        
		self.allowMultipleSelection = multipleSelection;
		
		[self buildSelectedItemsIndexesFromBoundValue];
		
		if(self.boundObject && !self.boundValue && self.commitChangesLive)
			self.boundValue = [NSMutableSet set];   //Empty set
	}
	return self;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectionStringPropertyName:(NSString *)propertyName items:(NSArray *)cellItems
{
	if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.boundPropertyDataType = SCDataTypeNSString;
		self.allowMultipleSelection = FALSE;
        
        self.selectionItemsStore = [SCMemoryStore storeWithObjectsArray:[NSMutableArray arrayWithArray:cellItems] defaultDefiniton:[SCStringDefinition definition]];
		
		[self buildSelectedItemsIndexesFromBoundValue];
	}
	return self;
}


- (NSArray *)items
{
    if(!itemsInSync)
    {
        if(!items)
            items = [NSArray array];
        switch (self.selectionItemsStore.storeMode)
        {
            case SCStoreModeSynchronous:
                items = [self.selectionItemsStore fetchObjectsWithOptions:self.selectionItemsFetchOptions];
                itemsInSync = TRUE;
                break;
                
            case SCStoreModeAsynchronous:
            {
                BOOL skipBuildingFromBoundValue = _commitingDetailModel;
                _loadingContents = TRUE;
                self.selectable = FALSE;
                if(!_activityIndicator)
                {
                    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    _activityIndicator.frame = self.contentView.bounds;
                    [self.contentView addSubview:_activityIndicator];
                }
                [_activityIndicator startAnimating];
                [self.selectionItemsStore asynchronousFetchObjectsWithOptions:self.selectionItemsFetchOptions
                                                                      success:^(NSArray *results)
                 {
                     items = results;
                     
                     if(!skipBuildingFromBoundValue)
                         [self buildSelectedItemsIndexesFromBoundValue];
                     [self loadBoundValueIntoControl];
                     
                     _loadingContents = FALSE;
                     [_activityIndicator stopAnimating];
                     self.selectable = TRUE;
                 }
                                                                      failure:^(NSError *error)
                 {
                     _loadingContents = FALSE;
                     [_activityIndicator stopAnimating];
                     itemsInSync = FALSE;
                     self.selectable = TRUE;
                 }];
                itemsInSync = TRUE;
            }
                break;
        }
    }
    
    return items;
}

- (void)setItems:(NSArray *)customItems
{
    if([self.selectionItemsStore isKindOfClass:[SCMemoryStore class]])
        [(SCMemoryStore *)self.selectionItemsStore setObjectsArray:[NSMutableArray arrayWithArray:customItems]];
    
    items = customItems;
    itemsInSync = TRUE;
}

- (void)setSelectionItemsStore:(SCDataStore *)store
{
    selectionItemsStore = store;
    
    selectionItemsFetchOptions = [store.defaultDataDefinition generateCompatibleDataFetchOptions];
    
    
    itemsInSync = FALSE;
    
    [self buildSelectedItemsIndexesFromBoundValue];
    [self loadBoundValueIntoControl];
}

- (void)setSelectionItemsFetchOptions:(SCDataFetchOptions *)fetchOptions
{
    selectionItemsFetchOptions = fetchOptions;
    
    itemsInSync = FALSE;
    
    [self buildSelectedItemsIndexesFromBoundValue];
    [self loadBoundValueIntoControl];
}

//overrides superclass
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_activityIndicator)
        _activityIndicator.frame = self.contentView.bounds;
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled)
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)buildSelectedItemsIndexesFromBoundValue
{
	[self.selectedItemsIndexes removeAllObjects];
	
	if([self.boundValue isKindOfClass:[NSNumber class]])
	{
		[self.selectedItemsIndexes addObject:self.boundValue];
	}
	else
		if([self.boundValue isKindOfClass:[NSMutableSet class]])
		{
			NSMutableSet *boundSet = (NSMutableSet *)self.boundValue;
			for(NSNumber *index in boundSet)
				[self.selectedItemsIndexes addObject:index];
		}
		else
			if([SCUtilities isStringClass:[self.boundValue class]] && self.items)
			{
				[self buildSelectedItemsIndexesFromString:(NSString *)self.boundValue];
			}
}

- (void)buildSelectedItemsIndexesFromString:(NSString *)string
{
	NSArray *selectionStrings = [string componentsSeparatedByString:@";"];
	
	[self.selectedItemsIndexes removeAllObjects];
	for(NSString *selectionString in selectionStrings)
	{
		NSUInteger index = [self.items indexOfObject:selectionString];
		if(index != NSNotFound)
			[self.selectedItemsIndexes addObject:[NSNumber numberWithUnsignedInteger:index]];
	}
}

- (NSString *)buildStringFromSelectedItemsIndexes
{
	NSMutableArray *selectionStrings = [NSMutableArray arrayWithCapacity:[self.selectedItemsIndexes count]];
	for(NSNumber *index in self.selectedItemsIndexes)
	{
		[selectionStrings addObject:[self.items objectAtIndex:[index intValue]]];
	}
	
	return [selectionStrings componentsJoinedByString:@";"];
}

//override superclass
- (void)cellValueChanged
{
	[self loadBoundValueIntoControl];
	
	[super cellValueChanged];
}

- (NSString *)getTitleForItemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}

//override superclass
- (void)loadBoundValueIntoControl
{
    NSArray *indexesArray = [[self.selectedItemsIndexes allObjects] 
                             sortedArrayUsingSelector:@selector(compare:)];
    if(self.items.count && self.displaySelection && indexesArray.count)
    {
        NSMutableString *selectionString = [[NSMutableString alloc] init];
        for(NSUInteger i=0; i<indexesArray.count; i++)
        {
            NSUInteger index = [(NSNumber *)[indexesArray objectAtIndex:i] intValue];
            if(index > (self.items.count-1))
                continue;
            
            if(i==0)
                [selectionString appendString:[self getTitleForItemAtIndex:index]];
            else
                [selectionString appendFormat:@"%@%@", self.delimeter,
                 (NSString *)[self getTitleForItemAtIndex:index]];
        }
        self.label.text = selectionString;
    }
    else
        self.label.text = nil;
}

- (void)reloadBoundValue
{
    itemsInSync = FALSE;
    
	[self buildSelectedItemsIndexesFromBoundValue];
	[self loadBoundValueIntoControl];
}
			 
- (void)buildDetailModel:(SCTableViewModel *)detailModel
{
    [detailModel clear];
    
    if([detailModel isKindOfClass:[SCSelectionModel class]])
    {
        SCSelectionModel *selectionModel = (SCSelectionModel *)detailModel;
        
        selectionModel.dataStore = self.selectionItemsStore;
        selectionModel.dataFetchOptions = self.selectionItemsFetchOptions;
        
        selectionModel.boundObjectStore = self.boundObjectStore;
        selectionModel.allowNoSelection = self.allowNoSelection;
        selectionModel.maximumSelections = self.maximumSelections;
        selectionModel.allowMultipleSelection = self.allowMultipleSelection;
        selectionModel.autoDismissViewController = self.autoDismissDetailView;
        
        selectionModel.allowAddingItems = self.allowAddingItems;
        selectionModel.allowDeletingItems = self.allowDeletingItems;
        selectionModel.allowMovingItems = self.allowMovingItems;
        selectionModel.allowEditDetailView = self.allowEditDetailView;
        
        [selectionModel setDetailViewControllerOptions:self.detailViewControllerOptions];
    }
    else 
    {
        SCSelectionSection *selectionSection = [SCSelectionSection sectionWithHeaderTitle:nil dataStore:self.selectionItemsStore];
        
        selectionSection.dataFetchOptions = self.selectionItemsFetchOptions;
        
        if(self.boundPropertyDataType == SCDataTypeNSNumber)
        {
            selectionSection.selectedItemIndex = self.selectedItemIndex;
        }
        else
        {
            for(NSNumber *index in self.selectedItemsIndexes)
                [selectionSection.selectedItemsIndexes addObject:index];
        }
        
        selectionSection.boundObjectStore = self.boundObjectStore;
        selectionSection.allowNoSelection = self.allowNoSelection;
        selectionSection.maximumSelections = self.maximumSelections;
        selectionSection.allowMultipleSelection = self.allowMultipleSelection;
        selectionSection.autoDismissViewController = self.autoDismissDetailView;
        selectionSection.cellsImageViews = self.detailCellsImageViews;
        
        selectionSection.allowAddingItems = self.allowAddingItems;
        selectionSection.allowDeletingItems = self.allowDeletingItems;
        selectionSection.allowMovingItems = self.allowMovingItems;
        selectionSection.allowEditDetailView = self.allowEditDetailView;
        
        selectionSection.placeholderCell = self.placeholderCell;
        selectionSection.addNewItemCell = self.addNewItemCell;
        selectionSection.addNewItemCellExistsInNormalMode = FALSE;
        
        [selectionSection setDetailViewControllerOptions:self.detailViewControllerOptions];
        
        [detailModel addSection:selectionSection];
    }
}

- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
    _commitingDetailModel = TRUE;
    
    // The detail model my have added/modified/removed items
    itemsInSync = FALSE;
    
    NSSet *selectedIndexes = nil;
    if([detailModel isKindOfClass:[SCSelectionModel class]])
    {
        selectedIndexes = [(SCSelectionModel *)detailModel selectedItemsIndexes];
    }
    else 
    {
        for(NSUInteger i=0; i<detailModel.sectionCount; i++)
        {
            SCTableViewSection *section = [detailModel sectionAtIndex:i];
            if([section isKindOfClass:[SCSelectionSection class]])
            {
                selectedIndexes = [(SCSelectionSection *)section selectedItemsIndexes];
                break;
            }
        }
    }
    
    if(selectedIndexes)
    {
        [self.selectedItemsIndexes removeAllObjects];
        for(NSNumber *index in selectedIndexes)
            [self.selectedItemsIndexes addObject:index];
        
        [self cellValueChanged];
    }
    
    _commitingDetailModel = FALSE;
}

//override superclass
- (SCNavigationBarType)defaultDetailViewControllerNavigationBarType
{
    if(self.detailViewControllerOptions.navigationBarType != SCNavigationBarTypeAuto)
        return self.detailViewControllerOptions.navigationBarType;
    
    
    SCNavigationBarType navBarType;
	if(self.autoDismissDetailView)
		navBarType = SCNavigationBarTypeNone;
	else
    {
        if(self.allowAddingItems || self.allowDeletingItems || self.allowMovingItems || self.allowEditDetailView)
            navBarType = SCNavigationBarTypeEditRight;
        else
            navBarType = SCNavigationBarTypeDoneRightCancelLeft;
    }
    
    return navBarType;
}

//override superclass
- (void)didSelectCell
{
    [super didSelectCell];
    
	self.ownerTableViewModel.activeCell = self;

	if(!self.items)
		return;
    
    if(_loadingContents)
        return;
	
	NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    UIViewController *detailViewController = [self getDetailViewControllerForCell:self forRowAtIndexPath:indexPath allowUITableViewControllerSubclass:YES];
    
    [self presentDetailViewController:detailViewController forCell:self forRowAtIndexPath:indexPath withPresentationMode:self.detailViewControllerOptions.presentationMode];
}

// overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
	if(self.boundPropertyDataType == SCDataTypeNSNumber)
	{
		self.boundValue = self.selectedItemIndex;
	}
	else
	if(self.boundPropertyDataType==SCDataTypeNSString || self.boundPropertyDataType==SCDataTypeDictionaryItem)
	{
		self.boundValue = [self buildStringFromSelectedItemsIndexes];
	}
	else
	{
		if([self.boundValue isKindOfClass:[NSMutableSet class]])
		{
			NSMutableSet *boundValueSet = (NSMutableSet *)self.boundValue;
			[boundValueSet removeAllObjects];
			for(NSNumber *index in self.selectedItemsIndexes)
				[boundValueSet addObject:index];
		}
	}
	
	needsCommit = FALSE;
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCSelectionAttributes class]])
		return;
	
	SCSelectionAttributes *selectionAttributes = (SCSelectionAttributes *)attributes;
    
	if(selectionAttributes.selectionItemsStore)
    {
        self.selectionItemsStore = selectionAttributes.selectionItemsStore;	
        self.selectionItemsFetchOptions = selectionAttributes.selectionItemsFetchOptions;
    }
		
	self.allowMultipleSelection = selectionAttributes.allowMultipleSelection;
	self.allowNoSelection = selectionAttributes.allowNoSelection;
	self.maximumSelections = selectionAttributes.maximumSelections;
	self.autoDismissDetailView = selectionAttributes.autoDismissDetailView;
	self.hideDetailViewNavigationBar = selectionAttributes.hideDetailViewNavigationBar;
    self.allowAddingItems = selectionAttributes.allowAddingItems;
    self.allowDeletingItems = selectionAttributes.allowDeletingItems;
    self.allowMovingItems = selectionAttributes.allowMovingItems;
    self.allowEditDetailView = selectionAttributes.allowEditingItems;
    if([selectionAttributes.placeholderuiElement isKindOfClass:[SCTableViewCell class]])
        self.placeholderCell = (SCTableViewCell *)selectionAttributes.placeholderuiElement;
    if([selectionAttributes.addNewObjectuiElement isKindOfClass:[SCTableViewCell class]])
        self.addNewItemCell = (SCTableViewCell *)selectionAttributes.addNewObjectuiElement;
}

//overrides superclass
- (BOOL)getValueIsValid
{
	if(![self.selectedItemsIndexes count] && !self.allowNoSelection && self.valueRequired)
		return FALSE;
	//else
	return TRUE;
}

- (void)setSelectedItemIndex:(NSNumber *)number
{
	[self.selectedItemsIndexes removeAllObjects];
	if([number intValue] >= 0)
	{
		NSNumber *num = [number copy];
		[self.selectedItemsIndexes addObject:num];
	}
}

- (NSNumber *)selectedItemIndex
{
	NSNumber *index = [self.selectedItemsIndexes anyObject];
	
	if(index)
		return index;
	//else
	return [NSNumber numberWithInt:-1];
}


- (void)handleDetailViewControllerWillPresent:(UIViewController *)detailViewController
{
	if(self.autoDismissDetailView && self.hideDetailViewNavigationBar)
		[self.ownerTableViewModel.viewController.navigationController setNavigationBarHidden:YES animated:YES];
	
	[super handleDetailViewControllerWillPresent:detailViewController];
}

- (void)handleDetailViewControllerWillDismiss:(UIViewController *)detailViewController cancelButtonTapped:(BOOL)cancelTapped doneButtonTapped:(BOOL)doneTapped
{
	[self.ownerTableViewModel.viewController.navigationController setNavigationBarHidden:FALSE animated:YES];
	
	[super handleDetailViewControllerWillDismiss:detailViewController cancelButtonTapped:cancelTapped doneButtonTapped:doneTapped];	
}

@end








@interface SCObjectSelectionCell ()

- (NSMutableSet *)boundMutableSet;

@end


@implementation SCObjectSelectionCell

@synthesize intermediateEntityDefinition;


+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectedObjectPropertyName:(NSString *)propertyName selectionItemsStore:(SCDataStore *)store
{
    return [[[self class] alloc] initWithText:cellText boundObject:object selectedObjectPropertyName:propertyName selectionItemsStore:store];
}

+ (id)cellWithText:(NSString *)cellText boundObject:(NSObject *)object selectedObjectPropertyName:(NSString *)propertyName selectionItems:(NSArray *)items itemsDefintion:(SCDataDefinition *)definition
{
	return [[[self class] alloc] initWithText:cellText boundObject:object selectedObjectPropertyName:propertyName selectionItems:items itemsDefintion:definition];
}

//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
    
    intermediateEntityDefinition = nil;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectedObjectPropertyName:(NSString *)propertyName selectionItemsStore:(SCDataStore *)store
{
    if( (self=[self initWithText:cellText boundObject:object boundPropertyName:propertyName]) )
	{
		self.selectionItemsStore = store;
        
        [self buildSelectedItemsIndexesFromBoundValue];
	}
	return self;
}

- (id)initWithText:(NSString *)cellText boundObject:(NSObject *)object selectedObjectPropertyName:(NSString *)propertyName selectionItems:(NSArray *)selitems itemsDefintion:(SCDataDefinition *)definition
{
	SCMemoryStore *store = [SCMemoryStore storeWithObjectsArray:[NSMutableArray arrayWithArray:selitems] defaultDefiniton:definition];
    
    self = [self initWithText:cellText boundObject:object selectedObjectPropertyName:propertyName selectionItemsStore:store];
    
    return self;
}


- (NSMutableSet *)boundMutableSet
{
    if(self.boundPropertyDataType == SCDataTypeNSString)
        return nil;
    
    NSMutableSet *set;
    if([self.boundObject respondsToSelector:@selector(mutableSetValueForKey:)])
    {
        set = [self.boundObject mutableSetValueForKey:self.boundPropertyName];
    }
    else 
    {
        set = (NSMutableSet *)self.boundValue;
    }
    
    return set;
}

//overrides superclass
- (void)buildSelectedItemsIndexesFromBoundValue
{
    [self.selectedItemsIndexes removeAllObjects];
    
    if(self.boundPropertyDataType == SCDataTypeNSString)
    {
        NSString *stringBoundValue = (NSString *)self.boundValue;
        NSArray *objectTitles = [stringBoundValue componentsSeparatedByString:@";"];
        SCDataDefinition *definition = [self.selectionItemsStore defaultDataDefinition];
        for(NSString *title in objectTitles)
        {
            NSObject *obj = [definition objectWithTitle:title inObjectsArray:self.items];
            NSUInteger index = [self.items indexOfObjectIdenticalTo:obj];
            if(index != NSNotFound)
                [self.selectedItemsIndexes addObject:[NSNumber numberWithUnsignedInteger:index]];
        }
        
        return;
    }
    
    
    if(self.allowMultipleSelection)
    {
        if(!self.intermediateEntityDefinition)
        {
            NSMutableSet *boundSet = [self boundMutableSet];  //optimize
            for(NSObject *obj in boundSet)
            {
                NSUInteger index = [self.items indexOfObjectIdenticalTo:obj];
                if(index != NSNotFound)
                    [self.selectedItemsIndexes addObject:[NSNumber numberWithUnsignedInteger:index]];
            }
        }
        else
        {
            // TODO - RESOLVE!!

            /*
            NSEntityDescription *boundObjEntity = [(NSManagedObject *)self.boundObject entity];
            NSEntityDescription *intermediateEntity = self.intermediateEntityClassDefinition.entity;
            NSEntityDescription *itemsEntity = self.itemsClassDefinition.entity;
            
            // Determine the boundObjEntity relationship name that connects to intermediateEntity
            NSString *intermediatesRel = nil;
            NSArray *relationships = [boundObjEntity relationshipsWithDestinationEntity:intermediateEntity];
            if(relationships.count)
                intermediatesRel = [(NSRelationshipDescription *)[relationships objectAtIndex:0] name];
            
            // Determine the intermediateEntity relationship name that connects to itemsEntity
            NSString *itemRel = nil;
            relationships = [intermediateEntity relationshipsWithDestinationEntity:itemsEntity];
            if(relationships.count)
                itemRel = [(NSRelationshipDescription *)[relationships objectAtIndex:0] name];
            
            if(intermediatesRel && itemRel)
            {
                NSMutableSet *intermediatesSet = [(NSManagedObject *)self.boundObject mutableSetValueForKey:intermediatesRel];
                for(NSManagedObject *intermediateObj in intermediatesSet)
                {
                    NSManagedObject *itemObj = [intermediateObj valueForKey:itemRel];
                    int index = [self.items indexOfObjectIdenticalTo:itemObj];
                    if(index != NSNotFound)
                        [self.selectedItemsIndexes addObject:[NSNumber numberWithInt:index]];
                }
            }
             */
                                     
        }
    }
    else
    {
        NSObject *selectedObject = [SCUtilities valueForPropertyName:self.boundPropertyName inObject:self.boundObject]; 
        NSUInteger index = [self.items indexOfObjectIdenticalTo:selectedObject];
        if(index != NSNotFound)
            [self.selectedItemsIndexes addObject:[NSNumber numberWithUnsignedInteger:index]];
    }
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCObjectSelectionAttributes class]])
		return;
	
	SCObjectSelectionAttributes *objectSelectionAttributes = (SCObjectSelectionAttributes *)attributes;

    self.intermediateEntityDefinition = objectSelectionAttributes.intermediateEntityDefinition;
    
    [self buildSelectedItemsIndexesFromBoundValue];
}

// override superclass
- (NSString *)getTitleForItemAtIndex:(NSUInteger)index
{
    NSObject *item = [self.items objectAtIndex:index];
    SCDataDefinition *itemDefinition = [self.selectionItemsStore definitionForObject:item];
    if(itemDefinition.titlePropertyName)
	{
		return [itemDefinition titleValueForObject:[self.items objectAtIndex:index]];
	}
	//else
	return nil;
}

// override superclass
- (void)buildDetailModel:(SCTableViewModel *)detailModel
{
    [detailModel clear];
    
	if([detailModel isKindOfClass:[SCObjectSelectionModel class]])
    {
        SCObjectSelectionModel *selectionModel = (SCObjectSelectionModel *)detailModel;
        selectionModel.autoFetchItems = FALSE;
        [selectionModel setMutableItems:[NSMutableArray arrayWithArray:self.items]];
        
        // Override object's bound value since it might not yet be committed
        [selectionModel.selectedItemsIndexes removeAllObjects];
        for(NSNumber *index in self.selectedItemsIndexes)
            [selectionModel.selectedItemsIndexes addObject:index];
        
        selectionModel.boundObject = self.boundObject;
        selectionModel.boundObjectStore = self.boundObjectStore;
        selectionModel.boundPropertyName = self.boundPropertyName;
        selectionModel.dataStore = self.selectionItemsStore;
        selectionModel.dataFetchOptions = self.selectionItemsFetchOptions;
        
        selectionModel.allowNoSelection = self.allowNoSelection;
        selectionModel.maximumSelections = self.maximumSelections;
        selectionModel.allowMultipleSelection = self.allowMultipleSelection;
        selectionModel.autoDismissViewController = self.autoDismissDetailView;
        
        selectionModel.allowAddingItems = self.allowAddingItems;
        selectionModel.allowDeletingItems = self.allowDeletingItems;
        selectionModel.allowMovingItems = self.allowMovingItems;
        selectionModel.allowEditDetailView = self.allowEditDetailView;
        
        [selectionModel setDetailViewControllerOptions:self.detailViewControllerOptions];
    }
    else
    {
        SCObjectSelectionSection *selectionSection = [SCObjectSelectionSection sectionWithHeaderTitle:nil boundObject:self.boundObject selectedObjectPropertyName:self.boundPropertyName selectionItemsStore:self.selectionItemsStore];
        selectionSection.dataFetchOptions = self.selectionItemsFetchOptions;
        selectionSection.autoFetchItems = FALSE;
        [selectionSection setMutableItems:[NSMutableArray arrayWithArray:self.items]];
        
        selectionSection.intermediateEntityDefinition = self.intermediateEntityDefinition;
        
        // Override object's bound value since it might not yet be committed
        [selectionSection.selectedItemsIndexes removeAllObjects];
        for(NSNumber *index in self.selectedItemsIndexes)
            [selectionSection.selectedItemsIndexes addObject:index];
        
        selectionSection.boundObjectStore = self.boundObjectStore;
        selectionSection.commitCellChangesLive = FALSE;
        selectionSection.allowNoSelection = self.allowNoSelection;
        selectionSection.maximumSelections = self.maximumSelections;
        selectionSection.allowMultipleSelection = self.allowMultipleSelection;
        selectionSection.autoDismissViewController = self.autoDismissDetailView;
        selectionSection.cellsImageViews = self.detailCellsImageViews;
        
        selectionSection.allowAddingItems = self.allowAddingItems;
        selectionSection.allowDeletingItems = self.allowDeletingItems;
        selectionSection.allowMovingItems = self.allowMovingItems;
        selectionSection.allowEditDetailView = self.allowEditDetailView;
        
        selectionSection.placeholderCell = self.placeholderCell;
        selectionSection.addNewItemCell = self.addNewItemCell;
        selectionSection.addNewItemCellExistsInNormalMode = FALSE;
        
        [selectionSection setDetailViewControllerOptions:self.detailViewControllerOptions];
        
        [detailModel addSection:selectionSection];
    }
}

// overrides superclass
- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
    _commitingDetailModel = TRUE;
    
    // The detail model my have added/modified/removed items
    itemsInSync = FALSE;
    
    NSSet *detailIndexes;
    if([detailModel isKindOfClass:[SCObjectSelectionModel class]])
    {
        detailIndexes = [(SCObjectSelectionModel *)detailModel selectedItemsIndexes];
    }
    else
    {
        SCObjectSelectionSection *selectionSection = (SCObjectSelectionSection *)[detailModel sectionAtIndex:0];
        detailIndexes = selectionSection.selectedItemsIndexes;
    }
    
	[self.selectedItemsIndexes removeAllObjects];
	for(NSNumber *index in detailIndexes)
		[self.selectedItemsIndexes addObject:index];
    
    [self cellValueChanged];
    
    _commitingDetailModel = FALSE;
}

// overrides superclass
- (void)commitChanges
{
	if(!self.needsCommit || !self.valueIsValid)
		return;
	
    if(self.boundPropertyDataType == SCDataTypeNSString)
    {
        SCDataDefinition *definition = [self.selectionItemsStore defaultDataDefinition];
        
        NSMutableString *objectTitles = [NSMutableString string];
        BOOL addSeparator = FALSE;
        for(NSNumber *index in self.selectedItemsIndexes)
        {
            NSObject *obj = [self.items objectAtIndex:(NSUInteger)[index intValue]];
            NSString *objTitle = [definition titleValueForObject:obj];
            if(!addSeparator)
            {
                [objectTitles appendString:objTitle];
                addSeparator = TRUE;
            }
            else
            {
                [objectTitles appendFormat:@";%@", objTitle];
            }
        }
        
        self.boundValue = objectTitles;
        
        return;
    }
    
	if(self.allowMultipleSelection)
    {
        if(!self.intermediateEntityDefinition)
        {
            NSMutableSet *boundValueSet = [self boundMutableSet];
            [boundValueSet removeAllObjects];
            for(NSNumber *index in self.selectedItemsIndexes)
            {
                NSObject *obj = [self.items objectAtIndex:(NSUInteger)[index intValue]];
                [boundValueSet addObject:obj];
            }
        }
        else
        {
            // TODO - RESOLVE!!
#ifdef _COREDATADEFINES_H            
            NSEntityDescription *boundObjEntity = [(NSManagedObject *)self.boundObject entity];
            NSEntityDescription *intermediateEntity = self.intermediateEntityClassDefinition.entity;
            NSEntityDescription *itemsEntity = self.itemsClassDefinition.entity;
            
            // Determine the boundObjEntity relationship name that connects to intermediateEntity
            NSString *intermediatesRel = nil;
            NSArray *relationships = [boundObjEntity relationshipsWithDestinationEntity:intermediateEntity];
            if(relationships.count)
                intermediatesRel = [(NSRelationshipDescription *)[relationships objectAtIndex:0] name];
            
            // Determine the intermediateEntity relationship name that connects to itemsEntity
            NSString *itemRel = nil;
            NSString *invItemRel = nil;
            relationships = [intermediateEntity relationshipsWithDestinationEntity:itemsEntity];
            if(relationships.count)
            {
                itemRel = [(NSRelationshipDescription *)[relationships objectAtIndex:0] name];
                invItemRel = [[(NSRelationshipDescription *)[relationships objectAtIndex:0] inverseRelationship] name];
            }
                
            
            if(intermediatesRel && itemRel && invItemRel)
            {
                NSMutableSet *intermediatesSet = [(NSManagedObject *)self.boundObject mutableSetValueForKey:intermediatesRel];
                
                // remove all intermediate objects
                for(NSManagedObject *intermediateObj in intermediatesSet)
                {
                    [self.intermediateEntityClassDefinition.managedObjectContext deleteObject:intermediateObj];
                }
                
                // add new intermediate objects
                for(NSNumber *index in self.selectedItemsIndexes)
                {
                    NSManagedObject *itemObj = [self.items objectAtIndex:[index intValue]];
                    
                    NSManagedObject *intermediateObj = [NSEntityDescription insertNewObjectForEntityForName:[intermediateEntity name] inManagedObjectContext:self.intermediateEntityClassDefinition.managedObjectContext];
                    [intermediatesSet addObject:intermediateObj];
                    [[itemObj mutableSetValueForKey:invItemRel] addObject:intermediateObj];
                }
            }
#endif            
        }
    }
	else
	{
		NSObject *selectedObject = nil;
		NSInteger index = [self.selectedItemIndex intValue];
		if(index >= 0)
			selectedObject = [self.items objectAtIndex:index];
		
		self.boundValue = selectedObject;
	}
}

@end










@interface SCObjectCell ()

- (void)setCellTextAndDetailText;

@end



@implementation SCObjectCell

@synthesize boundObjectTitleText;


+ (id)cellWithBoundObject:(NSObject *)object
{
	return [[[self class] alloc] initWithBoundObject:object];
}

+ (id)cellWithBoundObject:(NSObject *)object boundObjectDefinition:(SCDataDefinition *)definition
{
	return [[[self class] alloc] initWithBoundObject:object boundObjectDefinition:definition];
}

+ (id)cellWithBoundObject:(NSObject *)object boundObjectStore:(SCDataStore *)store
{
    return [[[self class] alloc] initWithBoundObject:object boundObjectStore:store];
}

//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
	boundObjectTitleText = nil;
	self.detailViewControllerOptions.tableViewStyle = UITableViewStyleGrouped;
	
	self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

- (id)initWithBoundObject:(NSObject *)object
{
	return [self initWithBoundObject:object boundObjectDefinition:nil];
}

- (id)initWithBoundObject:(NSObject *)object boundObjectDefinition:(SCDataDefinition *)definition
{
	SCDataStore *store = [definition generateCompatibleDataStore];
    
    return [self initWithBoundObject:object boundObjectStore:store];
}

- (id)initWithBoundObject:(NSObject *)object boundObjectStore:(SCDataStore *)store
{
    if( (self=[self initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]) )
	{
		boundObject = object;
		
		self.boundObjectStore = store;
	}
	return self;
}


- (SCDataDefinition *)objectDefinition
{
    return [self.boundObjectStore definitionForObject:self.boundObject];
}

- (void)setObjectDefinition:(SCDataDefinition *)objectDefinition
{
    [self.boundObjectStore setDefaultDataDefinition:objectDefinition];
}

- (void)setBoundObjectTitleText: (NSString*)input 
{ 
    boundObjectTitleText = [input copy];
    
    [self setCellTextAndDetailText];
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled && self.boundObject)
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
}

//override superclass
- (void)willDisplay
{
	[super willDisplay];
	
	if(self.boundObject && self.enabled)
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		self.accessoryType = UITableViewCellAccessoryNone;
	
	[self setCellTextAndDetailText];
}

//override superclass
- (void)cellValueChanged
{
	[self setCellTextAndDetailText];
	
	[super cellValueChanged];
}

- (void)buildDetailModel:(SCTableViewModel *)detailModel
{
    [detailModel clear];
    
    if(self.boundObjectStore)
        [detailModel generateSectionsForObject:self.boundObject withDataStore:self.boundObjectStore newObject:NO];
    
    for(NSUInteger i=0; i<detailModel.sectionCount; i++)
    {
        SCTableViewSection *section = [detailModel sectionAtIndex:i];
        
        [section setDetailViewControllerOptions:self.detailViewControllerOptions];
        section.commitCellChangesLive = FALSE;
        section.cellsImageViews = self.detailCellsImageViews;
        for(NSUInteger j=0; j<section.cellCount; j++)
        {
            [[section cellAtIndex:j] setDetailViewControllerOptions:self.detailViewControllerOptions];
        }
    }
}

- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
	// commitChanges & ignore self.commitChangesLive setting as it's not applicable here
	//looping to include any custom user added sections too
	for(NSUInteger i=0; i<detailModel.sectionCount; i++)
	{
		SCTableViewSection *section = [detailModel sectionAtIndex:i];
		[section commitCellChanges];
	}
	
	[self cellValueChanged];
}

//override superclass
- (SCNavigationBarType)defaultDetailViewControllerNavigationBarType
{
    SCNavigationBarType navBarType;
    if(self.objectDefinition.requireEditingModeToEditPropertyValues)
        navBarType = SCNavigationBarTypeEditRight;
    else
        navBarType = SCNavigationBarTypeDoneRightCancelLeft;
    
    return navBarType;
}

//override superclass
- (void)didSelectCell
{
    [super didSelectCell];
    
	self.ownerTableViewModel.activeCell = self;

	if(!self.boundObject)
		return;
	
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    UIViewController *detailViewController = [self getDetailViewControllerForCell:self forRowAtIndexPath:indexPath allowUITableViewControllerSubclass:YES];
    
    [self presentDetailViewController:detailViewController forCell:self forRowAtIndexPath:indexPath withPresentationMode:self.detailViewControllerOptions.presentationMode];
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCObjectAttributes class]])
		return;
	
	__unused SCObjectAttributes *objectAttributes = (SCObjectAttributes *)attributes;
	// No assignments currently needed.
    // Placeholder for future assignments.
}

- (void)setCellTextAndDetailText
{
	if(self.boundObjectTitleText)
		self.textLabel.text = self.boundObjectTitleText;
	else
	{
		if(self.boundObject && self.objectDefinition.titlePropertyName)
		{
			self.textLabel.text = [self.objectDefinition titleValueForObject:self.boundObject];
		}
	}
	
	if(self.boundObject && self.objectDefinition.descriptionPropertyName)
	{
		self.detailTextLabel.text = [SCUtilities stringValueForPropertyName:self.objectDefinition.descriptionPropertyName
																inObject:self.boundObject
											separateValuesUsingDelimiter:@" "];
	}
}


@end








@implementation SCArrayOfObjectsCell

@synthesize dataStore;
@synthesize dataFetchOptions;
@synthesize allowAddingItems;
@synthesize allowDeletingItems;
@synthesize allowMovingItems;
@synthesize allowEditDetailView;
@synthesize allowRowSelection;
@synthesize autoSelectNewItemCell;
@synthesize displayItemsCountInBadgeView;
@synthesize placeholderCell;
@synthesize addNewItemCell;
@synthesize addNewItemCellExistsInNormalMode;
@synthesize addNewItemCellExistsInEditingMode;
@synthesize detailSectionActions = _detailSectionActions;


+ (id)cellWithDataStore:(SCDataStore *)store
{
    return [[[self class] alloc] initWithDataStore:store];
}

+ (id)cellWithItems:(NSMutableArray *)cellItems itemsDefinition:(SCDataDefinition *)definition
{
	return [[[self class] alloc] initWithItems:cellItems itemsDefinition:definition];
}

//overrides superclass
- (void)performInitialization
{
	[super performInitialization];
	
    dataStore = nil;
    dataFetchOptions = nil;  // will be re-initialized when dataStore is set
    
	allowAddingItems = TRUE;
	allowDeletingItems = TRUE;
	allowMovingItems = TRUE;
	allowEditDetailView = TRUE;
	allowRowSelection = TRUE;
	autoSelectNewItemCell = FALSE;
	displayItemsCountInBadgeView = TRUE;
    
    placeholderCell = nil;
    addNewItemCell = nil;
    addNewItemCellExistsInNormalMode = TRUE;
    addNewItemCellExistsInEditingMode = TRUE;
    
    _detailSectionActions = [[SCSectionActions alloc] init];
}

- (id)initWithDataStore:(SCDataStore *)store
{
    if( (self=[self initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]) )
	{
		self.dataStore = store;
	}
	return self;
}

- (id)initWithItems:(NSMutableArray *)cellItems itemsDefinition:(SCDataDefinition *)definition
{
	if( (self=[self initWithStyle:SC_DefaultCellStyle reuseIdentifier:nil]) )
	{
		self.dataStore = [SCMemoryStore storeWithObjectsArray:cellItems defaultDefiniton:definition];
        [self.dataStore addDataDefinition:definition];
	}
	return self;
}


- (void)setDataStore:(SCDataStore *)store
{
    dataStore = store;
    
    if(!dataFetchOptions)
        dataFetchOptions = [store.defaultDataDefinition generateCompatibleDataFetchOptions];
}


//override superclass
- (void)layoutSubviews
{
	if(self.displayItemsCountInBadgeView)
	{
		self.badgeView.text = [NSString stringWithFormat:@"%i", (int)self.items.count];
	}
	
	[super layoutSubviews];
}

//overrides superclass
- (void)buildDetailModel:(SCTableViewModel *)detailModel
{
    [detailModel clear];
    
    if([detailModel isKindOfClass:[SCArrayOfObjectsModel class]])
    {
        SCArrayOfObjectsModel *objectsModel = (SCArrayOfObjectsModel *)detailModel;
        
        objectsModel.allowAddingItems = self.allowAddingItems;
        objectsModel.allowDeletingItems = self.allowDeletingItems;
        objectsModel.allowMovingItems = self.allowMovingItems;
        objectsModel.allowEditDetailView = self.allowEditDetailView;
        objectsModel.allowRowSelection = self.allowRowSelection;
        objectsModel.autoSelectNewItemCell = self.autoSelectNewItemCell;
        if([detailModel.viewController isKindOfClass:[SCViewController class]])
            objectsModel.addButtonItem = [(SCViewController *)detailModel.viewController addButton];
        else 
            if([detailModel.viewController isKindOfClass:[SCTableViewController class]])
                objectsModel.addButtonItem = [(SCTableViewController *)detailModel.viewController addButton];
        [objectsModel setDetailViewControllerOptions:self.detailViewControllerOptions];
    }
    else 
    {
        SCArrayOfObjectsSection *objectsSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil dataStore:self.dataStore];
        
        objectsSection.boundObjectStore = self.boundObjectStore;
        objectsSection.allowAddingItems = self.allowAddingItems;
        objectsSection.allowDeletingItems = self.allowDeletingItems;
        objectsSection.allowMovingItems = self.allowMovingItems;
        objectsSection.allowEditDetailView = self.allowEditDetailView;
        objectsSection.allowRowSelection = self.allowRowSelection;
        objectsSection.autoSelectNewItemCell = self.autoSelectNewItemCell;
        if([detailModel.viewController isKindOfClass:[SCViewController class]])
            objectsSection.addButtonItem = [(SCViewController *)detailModel.viewController addButton];
        else 
            if([detailModel.viewController isKindOfClass:[SCTableViewController class]])
                objectsSection.addButtonItem = [(SCTableViewController *)detailModel.viewController addButton];
        objectsSection.cellsImageViews = self.detailCellsImageViews;
        objectsSection.placeholderCell = self.placeholderCell;
        objectsSection.addNewItemCell = self.addNewItemCell;
        objectsSection.addNewItemCellExistsInNormalMode = self.addNewItemCellExistsInNormalMode;
        objectsSection.addNewItemCellExistsInEditingMode = self.addNewItemCellExistsInEditingMode;
        [objectsSection setDetailViewControllerOptions:self.detailViewControllerOptions];
        
        [objectsSection.sectionActions setActionsTo:self.detailSectionActions overrideExisting:YES];
        
        [detailModel addSection:objectsSection];
    }
}

- (void)commitDetailModelChanges:(SCTableViewModel *)detailModel
{
	[self cellValueChanged];
}

//overrides superclass
- (void)setEnabled:(BOOL)_enabled
{
    [super setEnabled:_enabled];
    
    if(_enabled && self.items)
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        self.accessoryType = UITableViewCellAccessoryNone;
}

//override superclass
- (void)willDisplay
{
	[super willDisplay];
	
	if( self.items && self.enabled )
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		self.accessoryType = UITableViewCellAccessoryNone;
}

//override superclass
- (SCNavigationBarType)defaultDetailViewControllerNavigationBarType
{
    SCNavigationBarType navBarType;
	if(!self.allowAddingItems && !self.allowDeletingItems && !self.allowMovingItems)
		navBarType = SCNavigationBarTypeNone;
	else
	{
		if(self.allowAddingItems && !self.addNewItemCell)
			navBarType = SCNavigationBarTypeAddEditRight;
		else
			navBarType = SCNavigationBarTypeEditRight;
	}

    return navBarType;
}

//override superclass
- (void)didSelectCell
{
    [super didSelectCell];
    
	self.ownerTableViewModel.activeCell = self;
	
	// If table is in edit mode, just display the bound object's detail view
	if(self.editing)
	{
		[super didSelectCell];
		return;
	}
    
    NSIndexPath *indexPath = [self.ownerTableViewModel indexPathForCell:self];
    UIViewController *detailViewController = [self getDetailViewControllerForCell:self forRowAtIndexPath:indexPath allowUITableViewControllerSubclass:YES];
    
    [self presentDetailViewController:detailViewController forCell:self forRowAtIndexPath:indexPath withPresentationMode:self.detailViewControllerOptions.presentationMode];
}

//overrides superclass
- (void)setAttributesTo:(SCPropertyAttributes *)attributes
{
	[super setAttributesTo:attributes];
	
	if(![attributes isKindOfClass:[SCArrayOfObjectsAttributes class]])
		return;
	
	SCArrayOfObjectsAttributes *objectsArrayAttributes = (SCArrayOfObjectsAttributes *)attributes;
    
	if(objectsArrayAttributes.objectsFetchOptions)
    {
        self.dataFetchOptions = objectsArrayAttributes.objectsFetchOptions;
    }
    
	self.allowAddingItems = objectsArrayAttributes.allowAddingItems;
	self.allowDeletingItems = objectsArrayAttributes.allowDeletingItems;
	self.allowMovingItems = objectsArrayAttributes.allowMovingItems;
	self.allowEditDetailView = objectsArrayAttributes.allowEditingItems;
    if([objectsArrayAttributes.placeholderuiElement isKindOfClass:[SCTableViewCell class]])
        self.placeholderCell = (SCTableViewCell *)objectsArrayAttributes.placeholderuiElement;
    if([objectsArrayAttributes.addNewObjectuiElement isKindOfClass:[SCTableViewCell class]])
        self.addNewItemCell = (SCTableViewCell *)objectsArrayAttributes.addNewObjectuiElement;
    self.addNewItemCellExistsInNormalMode = objectsArrayAttributes.addNewObjectuiElementExistsInNormalMode;
    self.addNewItemCellExistsInEditingMode = objectsArrayAttributes.addNewObjectuiElementExistsInEditingMode;
    
    [self.detailSectionActions setActionsTo:objectsArrayAttributes.sectionActions overrideExisting:NO];
}

- (NSArray *)items
{
    return [self.dataStore fetchObjectsWithOptions:self.dataFetchOptions];
}

@end

















