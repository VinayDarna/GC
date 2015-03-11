//
//  DashBoardViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 04/03/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "DashBoardViewController.h"

#import <PECropViewController.h>

@interface DashBoardViewController ()
{
    PECropViewController *peController;
    BOOL imageSelected;
}

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.clipsToBounds = YES;
    [self addTapgestureToImageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)addTapgestureToImageView
{
    UITapGestureRecognizer *tapRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeProfilePic)];
    tapRecog.numberOfTouchesRequired = 1;
    [self.profilePic addGestureRecognizer:tapRecog];
}

-(void)changeProfilePic
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Your Profile Photo" delegate:(id)self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Choose Existing Photo", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

#pragma matrk UIAlertView Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if (TARGET_IPHONE_SIMULATOR)
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = (id)self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController.navigationBar setHidden:NO];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = (id)self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController.navigationBar setHidden:NO];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    else if(buttonIndex==1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = (id)self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController.navigationBar setHidden:NO];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Cancel button clicked");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"original Image Size : %@", NSStringFromCGSize(chosenImage.size));
    [self performSelector:@selector(cropSelectedImge:) withObject:chosenImage afterDelay:1.0];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)cropSelectedImge:(UIImage *)selectedImageIs
{
    peController = [[PECropViewController alloc] init];
    peController.delegate = (id)self;
    peController.keepingCropAspectRatio=YES;
    peController.cropRect=CGRectMake(0, 0, 200, 200);
    peController.image = selectedImageIs;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:peController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    imageSelected = NO;
}

#pragma mark image operations
#pragma mark - UzysImageCropperDelegate

- (void)cropViewController:(PECropViewController *)controlleris didFinishCroppingImage:(UIImage *)croppedImage
{
    self.profilePic.image = croppedImage;
    self.profilePic.layer.cornerRadius=60.0f;
    self.profilePic.layer.masksToBounds=YES;
    self.profilePic.backgroundColor = [UIColor blackColor];
    imageSelected = YES;
    [controlleris dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controlleris
{
    imageSelected = NO;
    [controlleris dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
