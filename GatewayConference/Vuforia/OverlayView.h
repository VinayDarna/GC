/*==============================================================================
Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
All Rights Reserved.
Qualcomm Confidential and Proprietary
==============================================================================*/

#import <UIKit/UIKit.h>

// OverlayView is used to display UI objects over another view
@interface OverlayView : UIView

@property (nonatomic, retain) UIViewController*     parentController;

@property (nonatomic, retain) IBOutlet UIButton*                btnClose;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* aiPending;
@property (nonatomic, retain) IBOutlet UILabel*                 lblInitializing;

@end
