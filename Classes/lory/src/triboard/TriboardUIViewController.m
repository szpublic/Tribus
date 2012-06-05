//
//  TriboardUIViewController.m
//  StoryTest
//
//  Created by lbineau on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TriboardUIViewController.h"
#import "USave.h"
#import "SBJsonParser.h"
#import "TriboardItemUIViewController.h"
#import "UImage.h"

@implementation TriboardUIViewController
@synthesize itemsContainer;
@synthesize gestureOutlet;
@synthesize itemDatas;

- (id)init {
	if (self = [super init]) {
        
	}
	return self;
}
- (void)awakeFromNib
{
    // Creation du parser
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"triboard" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    // On récupère le JSON en NSString depuis la réponse
    NSString *json_string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // on parse la reponse JSON
    NSArray *res = [parser objectWithString:json_string error:nil];
    
    self.itemDatas = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *obj in res)
    {
        NSInteger i = [(NSString*)[obj objectForKey:@"id"]integerValue];
        [self.itemDatas setObject:[[NSMutableDictionary alloc] initWithObjects:
                                   [[NSArray alloc] initWithObjects:[obj objectForKey:@"id"],[obj objectForKey:@"title"],nil] forKeys:
                                   [[NSArray alloc] initWithObjects:@"id", @"title",nil]]
                           forKey:[obj objectForKey:@"id"]];
        
        UIImageView *view = [[itemsContainer subviews] objectAtIndex:i];
        
        TriboardItemUIViewController *item = [[TriboardItemUIViewController alloc] initWithNibName:@"TriboardItemUIViewController" bundle:nil];
        item.image = view;
        UIView *coloredView = [[UImage alloc] image: view.image WithTint: [UIColor colorWithWhite:1.0 alpha:1.0]];
        //item.del
        [itemsContainer addSubview:item.view];
        //coloredView.frame.origin = CGPointMake(0.0f, 0.0f);
        item.view.frame = view.frame;
        [self.view addSubview:coloredView];
    }

    for (NSDictionary *obj in [USave getItemIdsforType:@"inventory"])
    {
        NSLog(@"Inventory item : %@",obj);
    }
}
-(IBAction)busIncoming:(UIGestureRecognizer *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"busIncoming" object:nil];    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(itemFromBagUsed:) 
                                                 name:@"itemFromBagUsed" 
                                               object:nil];
    
    for (UIImageView * view in [itemsContainer subviews]) {
         
        TriboardItemUIViewController *item = [[TriboardItemUIViewController alloc] initWithNibName:@"TriboardItemUIViewController" bundle:nil];
        item.image = view;
        [itemsContainer addSubview:item.view];
        item.view.frame = view.frame;
    }
}
- (void)itemFromBagUsed:(NSNotification *)notification {
    NSObject *foo;
    foo = [notification object];
    NSLog(@"Object received : %@",foo);
    //do something else
}

- (void)viewDidUnload
{
    [self setGestureOutlet:nil];
    [self setItemsContainer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
