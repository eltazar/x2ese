//
//  FirstViewController.m
//  PerDueEse
//
//  Created by mario greco on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Contatti.h"
#import "CardViewController.h"
#import "CartaPerDue.h"
@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"pd.png"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - bottoni view

-(IBAction)showInfo:(id)sender{
    NSLog(@"show info: %@",self.navigationController);
    
    Contatti *info = [[Contatti alloc] initWithNibName:@"Contatti" bundle:nil];
    [self.navigationController pushViewController:info animated:YES];
    [info release];
}

-(IBAction)showCard:(id)sender{
 
    CardViewController *cardController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
    
    CartaPerDue *card = [[CartaPerDue alloc] init];
    card.name = @"prova";
    card.surname = @"ciao";
    card.number = @"123";
    card.state = @"non esistente";
    
    [cardController fillCardInfo:card];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cardController];
    
    [cardController release];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.navigationBar.barStyle = UIBarStyleBlack;
    [[self.tabBarController selectedViewController] presentModalViewController:navController animated:YES];
    
    [navController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"PerDue";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
   
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
