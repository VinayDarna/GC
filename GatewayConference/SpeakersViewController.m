//
//  SpeakersViewController.m
//  GatewayConference
//
//  Created by Olive Tech on 14/01/15.
//  Copyright (c) 2015 Teja Swaroop. All rights reserved.
//

#import "SpeakersViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GCSpeakerModel.h"

@interface SpeakersViewController ()

@end

@implementation SpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [speakersTableView reloadData];
    [[GCSharedClass sharedInstance]fetchDetailsWithParameter:@"speakers" andReturnWith:^(NSMutableArray *speakers, BOOL Success) {

//    [[GCSharedClass sharedInstance]fetchSpeakerDetailsWith:^(NSMutableArray *speakers, BOOL Success) {
        if (Success)
        {
            speakersArray = [speakers copy];
            [speakersTableView reloadData];
        }
        else
        {
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Data can't be Fetched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
        }
    }];
    
    [[GCSharedClass sharedInstance]fetchParseDetails];

}


#pragma UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [speakersArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    GCSpeakerModel *gcSpeak = [speakersArray objectAtIndex:indexPath.row];
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, 200, 30)];
    [nameLbl setTextAlignment:NSTextAlignmentCenter];
    [nameLbl setFont:[UIFont fontWithName:@"Heiti TC" size:22]];
    nameLbl.text = [NSString stringWithFormat:@"%@",gcSpeak.title];
    [cell.contentView addSubview:nameLbl];
    
    UIImageView *strongImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 100, 100)];
    NSURL *url = [NSURL URLWithString:gcSpeak.image];
    [strongImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Placeholder.jpeg"]];
    strongImgView.layer.cornerRadius = strongImgView.frame.size.width / 2;
    strongImgView.clipsToBounds = YES;
    [cell.contentView addSubview:strongImgView];
    
    UILabel *churchLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 35, 180, 70)];
    [churchLabel setTextAlignment:NSTextAlignmentCenter];
    [churchLabel setNumberOfLines:2];
    churchLabel.text = [NSString stringWithFormat:@"%@",[[speakersArray objectAtIndex:indexPath.row]valueForKey:@"organization"]];
    [cell.contentView addSubview:churchLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpeakerDetailsViewController *speDet = [story instantiateViewControllerWithIdentifier:@"SpeakerDetailsViewController"];
    //    speDet.speakersDetailsArray = speakersArray;
    speDet.speakersDetailsArray = [speakersArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:speDet animated:YES];;
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
