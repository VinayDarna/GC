//
//  SplitViewController.h
//  steuerapp
//
//  Created by Bernhard Häussermann on 2011/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplitViewController : UIViewController 
{
    IBOutlet UIView*            viewSplitter;
    IBOutlet UIToolbar*         toolbar;
    IBOutlet UIBarButtonItem*   toolbarListButton;
    
    CGFloat toolbarListButtonWidth;

    UIViewController*   menuViewController;
    UIViewController*   detailViewController;

    NSArray*    leftNavigationBarButtonItems;
    BOOL        didLoad;
    BOOL        menuViewHidden;
    
    int     splitPoint;
    BOOL    hideMenuViewControllerInPortraitOrientation;
    
    UIImage*            menuViewControllerHiddenLeftButtonsImage;
    UIBarButtonItem*    listButton;
    NSString*           listButtonTitle;
    
    id  sideViewPopOver;
}

@property (nonatomic, retain) UIViewController* menuViewController;
@property (nonatomic, retain) UIViewController* detailViewController;

@property (nonatomic, assign) int splitPoint;

@property (nonatomic, assign) BOOL          hideMenuViewControllerInPortraitOrientation;
@property (nonatomic, retain) UIImage*      menuViewControllerHiddenLeftButtonsImage;
@property (nonatomic, retain) NSString*     listButtonTitle;

- (id)init;
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil;

@end
