//
//  DashBoardViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 04/03/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "DashBoardViewController.h"

#import <PECropViewController.h>

#import "LoginViewController.h"

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
    
    
    
    appObj = [UIApplication sharedApplication].delegate;
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[NSString stringWithFormat:@"%@/ProfilePics",[appObj docPath]]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/ProfilePics",[appObj docPath]] withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"ConnectLater"] || [[NSUserDefaults standardUserDefaults]valueForKey:@"FileManager"])
    {
        NSString *imagePath = [NSString stringWithFormat:@"%@/ProfilePics",[appObj docPath]];
        NSString *filePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",noIs]];
        NSArray *imageContains = [NSArray arrayWithObject:filePath];
        
        BOOL isDirectory;
        for (NSString *item in imageContains){
            BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:item isDirectory:&isDirectory];
            if (fileExistsAtPath)
            {
                NSString * imagePath = [NSString stringWithFormat:@"%@/ProfilePics",[appObj docPath]];
                _profilePic.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",noIs]]]];
                
                _nameLable.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_name"];
                _fbIDLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"];
                _fbLinkLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_link"];
            }
            else
            {
                _profilePic.image = [UIImage imageNamed:@"No_profilePic.png"];
            }
        }
    }
    else if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"]length]>0 && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"TwitterName"]length]>0)
    {
        LoginViewController *loginObj = (LoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginObj animated:YES completion:^{
            NSLog(@"Presented");
        }];
    }
    else if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Twitter"])
    {
        _nameLable.text = [NSString stringWithFormat:@"@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"TwitterName"]];
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"twitterImage"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _profilePic.image = [UIImage imageWithData:data];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_image"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _profilePic.image = [UIImage imageWithData:data];
        _nameLable.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_name"];
        _fbIDLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"];
        _fbLinkLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"fb_link"];
    }
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
    
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 2.0);
    NSString *imagePath = [NSString stringWithFormat:@"%@/ProfilePics",[appObj docPath]];
    NSString *filePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",noIs]];
    [imageData writeToFile:filePath atomically:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"FM" forKey:@"FileManager"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
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

@end
