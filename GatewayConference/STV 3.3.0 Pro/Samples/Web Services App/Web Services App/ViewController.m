//
//  ViewController.m
//  Web Services App
//
//  Copyright (c) 2013 Sensible Cocoa. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface ViewController ()
{
    SCWebServiceDefinition *_youtubeDef;
}
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    SCTheme *theme=nil;
    if([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0)  // use Foody theme only for pre iOS 7.0
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            theme = [SCTheme themeWithPath:@"foody-iphone.sct"];
        } else {
            theme = [SCTheme themeWithPath:@"foody-iPad-master.sct"];
        }
    }
    
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"YouTube Search";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [theme styleObject:titleLabel usingThemeStyle:@"navigationItemTitleLabel"];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    // Create the web service definition for a YouTube listing
    _youtubeDef = [SCWebServiceDefinition definitionWithBaseURL:@"https://gdata.youtube.com/feeds/api/" fetchObjectsAPI:@"videos" resultsKeyName:@"feed.entry" resultsDictionaryKeyNames:nil];
    
    // For the detailed list of parameters, visit: https://developers.google.com/youtube/2.0/developers_guide_protocol_api_query_parameters
    [_youtubeDef.fetchObjectsParameters setValue:@"json" forKey:@"alt"];  // make sure the result is returned in JSON format
    [_youtubeDef.fetchObjectsParameters setValue:@"iOS" forKey:@"q"];     // search for videos about 'iOS'
    _youtubeDef.batchSizeParameterName = @"max-results";
    _youtubeDef.batchStartIndexParameterName = @"start-index";
    _youtubeDef.batchInitialStartIndex = 1;  // YouTube uses a 1-based starting index
    
    
    
    // The table model definition
    self.tableViewModel.theme = theme;
    self.tableViewModel.enablePullToRefresh = TRUE;
    self.tableViewModel.pullToRefreshView.arrowImageView.image = [UIImage imageNamed:@"blueArrow.png"];
    
    
    SCArrayOfObjectsSection *webSection = [SCArrayOfObjectsSection sectionWithHeaderTitle:nil webServiceDefinition:_youtubeDef batchSize:10];
    webSection.itemsAccessoryType = UITableViewCellAccessoryNone;
    webSection.sectionActions.cellForRowAtIndexPath = ^SCCustomCell*(SCArrayOfItemsSection *itemsSection, NSIndexPath *indexPath)
    {
        NSString *bindingsString = @"1:media$group.media$thumbnail[1].url;2:media$group.media$title.$t;3:media$group.media$description.$t";
        SCCustomCell *customCell = [SCCustomCell cellWithText:nil objectBindingsString:bindingsString nibName:@"VideoCell"];
        
        return customCell;
    };
    webSection.cellActions.willDisplay = ^(SCTableViewCell *cell, NSIndexPath *indexPath)
    {
        // Round the image corners for better aesthetics
        UIImageView *customImageView = (UIImageView *)[cell viewWithTag:1];
        customImageView.layer.masksToBounds = YES;
        customImageView.layer.cornerRadius = 5;
    };
    // Set the navigation bar buttons for detail views
    webSection.detailViewControllerOptions.navigationBarType = SCNavigationBarTypeDoneRight;
    [self.tableViewModel addSection:webSection];
    
    
    // setup the searchBar
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.showsCancelButton = TRUE;
    self.searchBar.text = [_youtubeDef.fetchObjectsParameters valueForKey:@"q"];
    self.searchBar.delegate = self;
}


#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_youtubeDef.fetchObjectsParameters setValue:searchText forKey:@"q"];
    [self.tableViewModel reloadBoundValues];
    [self.tableViewModel.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


@end
