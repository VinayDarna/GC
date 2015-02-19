//
//  DNSidebarAnnotatedPagerController.m
//  DoubleNode.com
//
//  Created by Darren Ehlers on 10/28/12.
//  Copyright (c) 2012 DoubleNode.com. All rights reserved.
//

#import "DNSidebarAnnotatedPagerController.h"

@interface DNSidebarAnnotatedPagerController ()
{
    BOOL    disableTitleScrollView;
    BOOL    disableScrollView;
}
@end

@implementation DNSidebarAnnotatedPagerController

@synthesize scrollView, titleScrollView;
@dynamic pageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withTitle:(NSString*)title
      withRevealBlock:(RevealBlock)revealBlock
        withHideBlock:(RevealBlock)hideBlock
      withToggleBlock:(RevealBlock)toggleBlock
   withIsShowingBlock:(RevealBlock_Bool)isShowingBlock
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil
                        withTitle:title
                  withRevealBlock:revealBlock
                    withHideBlock:hideBlock
                  withToggleBlock:toggleBlock
               withIsShowingBlock:isShowingBlock];
    if (self)
    {
        self.titleControlHeight     = 44;
        self.titleColor             = [UIColor lightGrayColor];
        self.titleSelectedColor     = [UIColor whiteColor];
        self.titleBackgroundColor   = [UIColor darkGrayColor];
        self.indicatorBarColor      = [UIColor lightGrayColor];
        self.titleFontName          = @"";
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = self.titleBackgroundColor;  // [UIColor scrollViewTexturedBackgroundColor];

    CGRect  frame       = CGRectMake(0, 0, self.view.bounds.size.width, self.titleControlHeight);
    //DLog(LL_Debug, @"colorView frame (%.2f, %.2f) - (%.2f, %.2f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    UIView* colorView   = [[UIView alloc] initWithFrame:frame];
    colorView.backgroundColor   = self.titleBackgroundColor;
    [self.view addSubview:colorView];

    frame = CGRectMake(self.view.bounds.size.width / 4, 0, self.view.bounds.size.width / 2.25, self.titleControlHeight);
    titleScrollView = [[DNSpecialWidthScrollView alloc] initWithFrame:frame];
    titleScrollView.delegate    = self;
    titleScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    titleScrollView.responseInsets      = UIEdgeInsetsMake(0, self.view.bounds.size.width / 4, 0.0, self.view.bounds.size.width / 4);
    
    titleScrollView.backgroundColor                 = self.titleBackgroundColor;
    titleScrollView.canCancelContentTouches         = NO;
    titleScrollView.showsHorizontalScrollIndicator  = NO;
    
    titleScrollView.clipsToBounds   = NO;
    titleScrollView.scrollEnabled   = YES;
    titleScrollView.pagingEnabled   = YES;
    
    frame = CGRectMake(0, self.titleControlHeight, self.view.bounds.size.width, self.view.bounds.size.height - self.titleControlHeight);
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.delegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    scrollView.autoresizesSubviews              = YES;
    scrollView.backgroundColor                  = [UIColor clearColor];
    scrollView.canCancelContentTouches          = NO;
    scrollView.showsHorizontalScrollIndicator   = NO;
    
    scrollView.clipsToBounds    = YES;
    scrollView.scrollEnabled    = YES;
    scrollView.pagingEnabled    = YES;
    
    [self.view addSubview:scrollView];
    [self.view addSubview:titleScrollView];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.titleControlHeight - 2.0f, self.view.bounds.size.width, 2.0f)];
    bottomBar.backgroundColor = self.indicatorBarColor;
    [self.view addSubview:bottomBar];
    
    NSInteger   width = self.view.bounds.size.width / 3;
    UIView *bottomBar2 = [[UIView alloc] initWithFrame:CGRectMake(width, self.titleControlHeight - 7.0f, width, 7.0f)];
    bottomBar2.backgroundColor = self.indicatorBarColor;
    [self.view addSubview:bottomBar2];
    
    UIImageView*    titleFadeView   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-fade.png"]];
    titleFadeView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.titleControlHeight);
    [self.view addSubview:titleFadeView];
    
    [self reloadPages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    _lockPageChange = YES;
    [self reloadPages];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _lockPageChange = NO;
    [self setPageIndex:self.pageIndex animated:NO];
}

#pragma mark Add and remove
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        self.pageIndex = 0;
        for (UIViewController *vC in self.childViewControllers)
        {
            [vC willMoveToParentViewController:nil];
            [vC removeFromParentViewController];
        }
    }
    
    for (UIViewController *vC in viewControllers)
    {
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    if (self.scrollView)
        [self reloadPages];
    //TODO animations
}

#pragma mark Properties
- (void)setPageIndex:(NSUInteger)pageIndex
{
    [self setPageIndex:pageIndex animated:NO];
}

- (void)setPageIndex:(NSUInteger)index animated:(BOOL)animated;
{
    _pageIndex = index;
    
    /*
     *	Change the scroll view
     */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    
    if (frame.origin.x < scrollView.contentSize.width)
    {
        [scrollView scrollRectToVisible:frame animated:animated];
    }
    
    [self updateTitleColors:index];
}

- (NSUInteger)pageIndex
{
    return _pageIndex;
}

- (void)updateTitleColors:(NSUInteger)index
{
    for (UIView *view in titleScrollView.subviews)
    {
        for (UIView *view2 in view.subviews)
        {
            UIButton*   b = (UIButton*)view2;
            if (b.tag == index)
            {
                [b setTitleColor:self.titleSelectedColor forState:UIControlStateNormal];
            }
            else
            {
                [b setTitleColor:self.titleColor forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    //The scrollview tends to scroll to a different page when the screen rotates
    if (_lockPageChange)
        return;
    
    if (_scrollView == titleScrollView)
    {
        if (!disableTitleScrollView)
        {
            //DLog(LL_Debug, @"titleScrollView (%.2f, %.2f, %.2f)", _scrollView.contentOffset.x, _scrollView.contentOffset.y, _scrollView.contentSize.width);
            
            CGFloat newXOff = (_scrollView.contentOffset.x * 2.25);
            if (newXOff > (scrollView.contentSize.width - scrollView.frame.size.width))
            {
                return;
            }
            //DLog(LL_Debug, @"newXOff (%.2f, %.2f)", newXOff, scrollView.contentSize.width);
            
            CGFloat pageWidth = _scrollView.frame.size.width;
            int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            _pageIndex = page;
            [self updateTitleColors:_pageIndex];
            
            disableScrollView = YES;
            [UIView animateWithDuration:0.3f
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 scrollView.contentOffset = CGPointMake(newXOff, 0);
             }
                             completion:^(BOOL finished)
             {
                 disableScrollView = NO;
             }];
        }
    }
    else
    {
        if (!disableScrollView)
        {
            //DLog(LL_Debug, @"scrollView (%.2f, %.2f)", _scrollView.contentOffset.x, _scrollView.contentOffset.y);

            /*
             *	We switch page at 50% across
             */
            CGFloat pageWidth = _scrollView.frame.size.width;
            int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            _pageIndex = page;
            [self updateTitleColors:_pageIndex];

            CGFloat newXOff = (_scrollView.contentOffset.x / 2.25);
            //DLog(LL_Debug, @"newXOff (%.2f)", newXOff);
            
            disableTitleScrollView = YES;
            [UIView animateWithDuration:0.3f
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^
             {
                 titleScrollView.contentOffset = CGPointMake(newXOff, 0);
             }
                             completion:^(BOOL finished)
             {
                 disableTitleScrollView = NO;
             }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    DLog(LL_Debug, @"scrollView.contentOffset.x=%.2f", scrollView.contentOffset.x);
    
    // The key is repositioning without animation
    if (scrollView.contentOffset.x == 0)
    {
        // user is scrolling to the left from image 1 to image 10.
        // reposition offset to show image 10 that is on the right in the scroll view
        [scrollView scrollRectToVisible:CGRectMake(960, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    }
    else if (scrollView.contentOffset.x == 1280)
    {
        // user is scrolling to the right from image 10 to image 1.
        // reposition offset to show image 1 that is on the left in the scroll view
        [scrollView scrollRectToVisible:CGRectMake(320, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
    }
}

- (void)reloadPages
{
    for (UIView *view in titleScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    for (UIView *view in scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
	CGFloat cx = 0;
    CGFloat titleItemWidth = titleScrollView.bounds.size.width;
    CGFloat dx = 0;
    
    NSUInteger count = self.childViewControllers.count;
	for (NSUInteger i = 0; i < count; i++)
    {
        UIViewController*   vC = [self.childViewControllers objectAtIndex:i];
        
        CGRect  frame   = CGRectMake(dx, 0, titleItemWidth, titleScrollView.bounds.size.height);
        //DLog(LL_Debug, @"titleView frame (%.2f, %.2f) - (%.2f, %.2f)", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        UIView* view    = [[UIView alloc]initWithFrame:frame];
        view.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
        view.backgroundColor    = self.titleBackgroundColor;
        
        UIFont* font = nil;
        if ([self.titleFontName length] > 0)
        {
            font = [UIFont fontWithName:self.titleFontName size:17.0f];
        }
        if (!font)
        {
            font = [UIFont boldSystemFontOfSize:17.0];
        }
        font = [font fontWithSize:17.0f];
        CGSize  size    = [vC.title sizeWithFont:font];
        
        frame = CGRectMake((frame.size.width - size.width)/1.70, 0.5*(frame.size.height - size.height), size.width, size.height);
        
        UIButton*   b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame     = frame;
        b.tag       = i;
        
        b.backgroundColor       = [UIColor clearColor];
        // TODO: Doesn't work
        // b.titleLabel.textColor  = [UIColor blackColor];
        b.titleLabel.font       = font;
        
        [b setTitle:vC.title forState:UIControlStateNormal];
        [b addTarget:self action:@selector(didTapLabel:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:b];
        
        [titleScrollView addSubview:view];
        dx += titleItemWidth;
        
		CGRect  rect    = vC.view.frame;
		rect.origin.x   = cx;
		rect.origin.y   = 0;
        
		vC.view.frame  = rect;
		[scrollView addSubview:vC.view];
        
		cx += scrollView.frame.size.width;
	}
	[titleScrollView setContentSize:CGSizeMake(dx+titleItemWidth/2.25, titleScrollView.bounds.size.height)];
	[titleScrollView setContentSize:CGSizeMake(dx, titleScrollView.bounds.size.height)];
    //DLog(LL_Debug, @"titleView contentSize (%.2f, %.2f)", titleScrollView.contentSize.width, titleScrollView.contentSize.height);
	[scrollView setContentSize:CGSizeMake(cx, scrollView.bounds.size.height)];
}

- (void)didTapLabel:(UIButton*)button
{
    [self setPageIndex:button.tag animated:YES];
}

@end
