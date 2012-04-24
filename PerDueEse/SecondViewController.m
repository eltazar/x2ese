//
//  SecondViewController.m
//  PerDueEse
//
//  Created by mario greco on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "SecondViewController.h"
#import "AppDelegate.h"
#import "Utilita.h"


@interface SecondViewController() {
    NSString *_pin;
}
@property(nonatomic, retain) NSString *pin;
@end

@implementation SecondViewController
@synthesize pin = _pin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Attivazione";
        self.tabBarItem.image = [UIImage imageNamed:@"active.png"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    NSLog(@"PIN INSERITO = %@",txtField.text);
    self.pin = txtField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - metodi bottoni view

-(IBAction)sendPinBtnClicked:(id)sender{
    
    //dismette la tastiera e prende i salva i dati nelle variabili quando si preme il button
    [self.view endEditing:TRUE];
    
    if(! [Utilita isStringEmptyOrWhite:self.pin]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pin errato" message:@"Il pin inserito non è valido, riprovare" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    AppDelegate *appDelegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isPutPin = TRUE;
    
    //chiamo registrazione token 
    
#if !TARGET_IPHONE_SIMULATOR
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
#endif
    
    
    
}

-(void)launchQuery:(NSString *)token{
    
    [dbAccess registerCompany:self.pin token:token];
    
}

#pragma mark - databaseAccess delegate

-(void)didReceiveResponsFromServer:(NSString *)receivedData{
    NSLog(@"%@",receivedData);

    UIAlertView *alert = [[UIAlertView alloc] init];
    
    if([receivedData isEqualToString:@"token_updated"]){
        alert.title = @"Complimenti";
        alert.message = @"Il tuo dispositivo è ora bilitato alla ricezione delle notifiche push";
        
    }
    else if([receivedData isEqualToString:@"write_token_error"]){
        alert.title = @"Errore";
        alert.message = @"Non è stato possibile associare il tuo dispositivo";
    
    }
    else if([receivedData isEqualToString:@"wrong_pin"]){
        alert.title = @"Pin errato";
        alert.message = @"Il pin inserito non è valido, riprovare";
    }
    [alert  addButtonWithTitle:@"Chiudi"];
    [alert show];
    [alert release];
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"errore = %@",[error description]);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;

    // create the button object
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //[b setBackgroundColor:[UIColor grayColor]];
    
    b.frame = CGRectMake(78.0, 300.0, 164.0, 37.0);
    b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [b setTitle:@"Invia" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [b setBackgroundImage:[UIImage imageNamed:@"grayButton2.png"] forState:UIControlStateNormal];
    
    // give it a tag in case you need it later
    //b.tag = 1;
    
    // this sets up the callback for when the user hits the button
    [b addTarget:self action:@selector(sendPinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    b.layer.cornerRadius = 6.0;
    b.layer.masksToBounds = YES;

    [self.view addSubview:b];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    self.pin = nil;    
    dbAccess.delegate = nil;
    [dbAccess release];
    [super dealloc];
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
