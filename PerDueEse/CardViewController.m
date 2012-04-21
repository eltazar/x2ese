//
//  CardViewController.m
//  PerDueEse
//
//  Created by mario greco on 07/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "CartaPerDue.h"

@interface CardViewController ()

@end

@implementation CardViewController
@synthesize validateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fillCardInfo:(CartaPerDue*)card{
    //NSLog(@"user data = %@",userData);

    //$userData = array($nameCard,$surnameCard,$numCard,$expCard,$valid);
    
    UITextField *user = (UITextField*)[self.view viewWithTag:5];
    
    user.text = [NSString stringWithFormat:@"%@ %@",card.name, card.surname];
    
    UITextField *cardNumber = (UITextField*)[self.view viewWithTag:4];
    
    cardNumber.text = card.number;
    
    UITextField *expiration = (UITextField*)[self.view viewWithTag:3];
    
    expiration.text = card.expiryString;
    
    validateLabel.text = card.state;
    
}

#pragma mark - bottoni view

-(void)close{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View life cicle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Carta cliente";

   // self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = closeBtn;

    [closeBtn release];
    
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 25, 300, 180)];
    
    
    //    
    //    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
    //    titolareTextField.tag = 5;
    //    
    //    [self.view addSubview:titolareTextField];
    //    [self.view addSubview:cartaView];
    
    CGFloat padding = 10;
    CGFloat boundsWidth = cartaView.frame.size.width;
    
    UITextField *titolareLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + padding, boundsWidth-2*padding, 28)];
    titolareLabel.font = [UIFont systemFontOfSize:15];
   // titolareLabel.text = [NSString stringWithFormat:@"%@ %@", self.card.name, self.card.surname];
    titolareLabel.backgroundColor = [UIColor clearColor];
    titolareLabel.tag = 5;
    
    
    UITextField *numeroCartaLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+2*padding, boundsWidth-2*padding, 28)];
    numeroCartaLabel.font = [UIFont systemFontOfSize:15];
   // numeroCartaLabel.text = self.card.number;
    numeroCartaLabel.backgroundColor = [UIColor clearColor];
    numeroCartaLabel.tag = 4;
    
    UITextField *scadenzaLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+2*padding, boundsWidth-2*padding, 28)];
    scadenzaLabel.font = [UIFont systemFontOfSize:15];
    //scadenzaLabel.text = self.card.expiryString;
    scadenzaLabel.textAlignment = UITextAlignmentRight;
    scadenzaLabel.backgroundColor = [UIColor clearColor];
    scadenzaLabel.tag = 3;
    
    [cartaView addSubview:scadenzaLabel];
    [cartaView addSubview:numeroCartaLabel];
    [cartaView addSubview:titolareLabel];
    
    [self.view addSubview:cartaView];
    
    [cartaView release];
    [numeroCartaLabel release];
    [titolareLabel release];
    [scadenzaLabel release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.validateLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    self.validateLabel = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
