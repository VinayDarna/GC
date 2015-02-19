/*==============================================================================
            Copyright (c) 2010-2013 QUALCOMM Austria Research Center GmbH.
            All Rights Reserved.
            Qualcomm Confidential and Proprietary
==============================================================================*/

#import "QCARutils.h"

typedef enum {
    DeviceOrientationLockPortrait,
    DeviceOrientationLockLandscape,
    DeviceOrientationLockAuto
} DeviceOrientationLock;

@interface PARQCARutils : QCARutils
{
    DeviceOrientationLock deviceOrientationLock;
}

@property (assign) DeviceOrientationLock deviceOrientationLock;

+ (PARQCARutils *) getInstance;

//  Autorotation
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (NSUInteger) supportedInterfaceOrientations;
- (BOOL) shouldAutorotate;
@end
