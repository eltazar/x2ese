//
//  ReceivedCardsController.m
//  PerDueEse
//
//  Created by mario greco on 21/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReceivedCardsController.h"
#import "LocalDatabaseAccess.h"
#import "AppDelegate.h"

@interface ReceivedCardsController ()

@end

@implementation ReceivedCardsController
@synthesize sectionData,sectionDescription;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Notifiche";
        self.tabBarItem.image = [UIImage imageNamed:@"push.png"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Notifiche ricevute";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.title = @"Notifiche";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataSource) name:kReceivedPushNotification object:nil];
    
    self.sectionDescription = [[[NSMutableArray alloc] init] autorelease];
    [self.sectionDescription insertObject:@"Carte" atIndex:0];
    
    NSMutableArray *cardsSection  = [[self creaDataContent] retain];
    
    if (cardsSection && cardsSection.count > 0) {        
        self.sectionData = [[[NSMutableArray alloc] initWithObjects:cardsSection, nil] autorelease];
    }
    else {
        //self.sectionData = [NSMutableArray *alarm(<#unsigned int#>)
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReceivedPushNotification object:nil];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDescription.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {  
    return [self.sectionDescription objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{   
    if(self.sectionData){
        //NSLog(@"section n = %d",section);
        return [[self.sectionData objectAtIndex: section] count];
    } 
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"UserCardCell"];
	if (!cell) {
        // TODO: controllare il reuse identifier di CellaHome.
		cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCardCell" owner:self options:NULL] objectAtIndex:0];
	}
	
    CartaPerDue *card = (CartaPerDue*)[[sectionData objectAtIndex:0] objectAtIndex:indexPath.row];
    NSLog(@"LA CARTA é -> nome = %@,cognome = %@, numero = %@, scadenza = %@, stato = %@",card.name,card.surname,card.number,card.expiryString,card.state);
	
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    UILabel *number = (UILabel *)[cell viewWithTag:2];
    UILabel *state = (UILabel *)[cell viewWithTag:3];
    UIImageView *stateImg = (UIImageView*)[cell viewWithTag:4];
    
    name.text = [NSString stringWithFormat:@"%@ %@", card.name,card.surname];
    ;
    number.text = card.number;
    state.text = card.state;
    
    if([card.state isEqualToString:@"Valida"]){
        stateImg.image = [UIImage imageNamed:@"checkV.png"];
    }
    else{
        stateImg.image = [UIImage imageNamed:@"checkX.png"];
    }
    
	//cat.text = [[self.dataModel objectAtIndex:indexPath.row] objectForKey:@"title"];
	//img.image = [UIImage imageNamed:cat.text];
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (NSArray*)creaDataContent {
    NSError *error;
    NSArray *cardsArray = [[LocalDatabaseAccess getInstance]fetchStoredCardsAndWriteErrorIn:&error];
    //NSMutableArray *dataContent = [[NSMutableArray alloc] init];
    
    if(cardsArray.count > 0)
        NSLog(@"CARD ARRAY = %@",((CartaPerDue*)[cardsArray objectAtIndex:0]).name);
    
    return cardsArray;
    /*
    // TODO: controllare errori
    for(int i = 0; i < cardsArray.count ; i++){
        //creo l'array di dizionari per le righe della sezione "carte"            
        CartaPerDue *card = [cardsArray objectAtIndex:i];
        
        NSMutableDictionary *tempDict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"card",               @"DataKey",
                                          @"UserCardCell", @"kind",
                                          card,                  @"card",
                                          nil] autorelease];
        
        [dataContent insertObject: tempDict atIndex: i];
    }
    return [dataContent autorelease];
     */
}

-(void)updateDataSource{
    
    [self.sectionData removeAllObjects];
    [self.sectionData insertObject:[self creaDataContent] atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES or NO
    return(YES);
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell editing");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *state = (UILabel *)[cell viewWithTag:3];
    UIImageView *stateImg = (UIImageView*)[cell viewWithTag:4];
    
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         state.alpha = 0.0;
                         stateImg.alpha = 0.0;
                     }
     
     ];

}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath     *)indexPath
{    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *state = (UILabel *)[cell viewWithTag:3];
    UIImageView *stateImg = (UIImageView*)[cell viewWithTag:4];
    
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         state.alpha = 1.0;
                         stateImg.alpha = 1.0;
                     }
     
     ];

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@"BOOOOOOOOOO");
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *number = (UILabel *)[cell viewWithTag:2];
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSLog(@"delete premuto");
        NSError *error;
                
        [[LocalDatabaseAccess getInstance] removeStoredCardByNumber:number.text error:&error ];
        [self updateDataSource];
    }    


}


//- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
//{
//    NSLog(@"CANCELLATO RIGA CORE DATA");
//    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
//}
//
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView endUpdates];
//    
//}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
