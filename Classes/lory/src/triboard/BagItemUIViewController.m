//
//  BagItemUIViewController.m
//  ChipmunkWrapper
//
//  Created by Mac on 10/06/12.
//  Copyright (c) 2012 Sodeso. All rights reserved.
//

#import "BagItemUIViewController.h"
#import "BagScrollItemUIViewController.h"

@interface BagItemUIViewController ()

@end

@implementation BagItemUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)awakeFromNib{


}

///////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate	  	
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    /*[[NSNotificationCenter defaultCenter] postNotificationName:@"itemSelectedFromBag" 
                                                        object:[NSNumber numberWithInt:1]];
    self.tabBarController.selectedIndex = 0;*/
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView

{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(320, 80);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
        
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        
        BagScrollItemUIViewController *vc=[[BagScrollItemUIViewController alloc] initWithNibName:@"BagScrollItemUIViewController" bundle:nil];
       // [self.view addSubview:vc.view];
        
        cell.contentView = vc.view;
        cell.autoresizesSubviews = NO;
        cell.clipsToBounds = YES;
        cell.bounds = vc.view.bounds;
        cell.frame = vc.view.frame;
    }
    
   // [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"awakeFromNib");
    NSInteger spacing = 5;
    
    _data = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 25; i ++) 
    {
        [_data addObject:[NSString stringWithFormat:@"A %d", i]];
    }
    _currentData = _data;
    CGRect rect = self.view.bounds;
    rect.size.height -= 80;
    rect.size.width -= 50;
    rect.origin.x = 10;
    rect.origin.y = 5;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:rect];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    
    _gmGridView.mainSuperView = self.view;
    _gmGridView.clipsToBounds = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
