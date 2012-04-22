//
//  AppDelegate.m
//  PerDueEse
//
//  Created by mario greco on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import <CoreData/CoreData.h>
#import "SecondViewController.h"
#import "Utilita.h"
#import "CardViewController.h"
#import "ReceivedCardsController.h"
#import "CartaPerDue.h"
#import "LocalDatabaseAccess.h"

@interface AppDelegate()
-(void)showModalCardDetail:(NSDictionary*)userInfo;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize isPutPin;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
//    CardViewController *cardViewController = [[[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil] autorelease];
    
    ReceivedCardsController *receivedCardsCtrl = [[ReceivedCardsController alloc] initWithNibName:@"ReceivedCardsController" bundle:nil];
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:receivedCardsCtrl] autorelease];
    [receivedCardsCtrl release]; 
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, navController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notification
    
    isPutPin = FALSE;
    
#if !TARGET_IPHONE_SIMULATOR
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
#endif
    
    // Clear application badge when app launches
    application.applicationIconBadgeNumber = 0;
    
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			//NSLog(@"Launched from push notification in didFinishLaunching: %@", dictionary);
			[self showModalCardDetail:dictionary];
		}
	}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //controlla tra le impostazioni dell'iphone se l'app ha le notifiche attive
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types == UIRemoteNotificationTypeNone) 
        NSLog(@"push disabilitate");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark - push delegate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(isPutPin){
        
        SecondViewController *tab2 = [[self.tabBarController viewControllers] objectAtIndex:1];
//        tab2.token = newToken;
        [tab2 launchQuery:newToken];
        isPutPin = FALSE;
    }   
}

-(void)showModalCardDetail:(NSDictionary*)userInfo{
    
    [userInfo retain];
    
    CartaPerDue *card = [[CartaPerDue alloc] init];
    
    if([[[userInfo objectForKey:@"userData"] objectAtIndex:4] isEqualToString:@"not_exsisting"]){
        
        card.name = @"";
        card.surname = @"";
        card.number = @"";
        card.expiryString = @" ";
        card.state = @"Non esistente";
        
    }
    else{
        card.name = [[userInfo objectForKey:@"userData"] objectAtIndex:0];
        card.surname = [[userInfo objectForKey:@"userData"] objectAtIndex:1];
        card.number = [[userInfo objectForKey:@"userData"] objectAtIndex:2];
        card.expiryString = [[userInfo objectForKey:@"userData"] objectAtIndex:3];
        
        if([[[userInfo objectForKey:@"userData"] objectAtIndex:4] isEqualToString:@"valid"]){
            card.state = @"Valida";
        }
        else if([[[userInfo objectForKey:@"userData"] objectAtIndex:4] isEqualToString:@"expired"]){
            card.state = @"Scaduta";
        }
        
        //Effettuiamo il salvataggio gestendo eventuali errori
        NSError *error;
        if (![[LocalDatabaseAccess getInstance]storeCard:card AndWriteErrorIn:&error]) {
            NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
        }
        else{
            NSLog(@"carta salvata su db locale");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kReceivedPushNotification object:nil userInfo:nil];
        }/* else if (self.delegate && [self.delegate respondsToSelector:@selector(didAssociateNewCard)]) {
          [self.delegate didAssociateNewCard];
          }    
        */
    }
    
    //lancio una view modale con il riassunto della notifica
    
    CardViewController *cardController = [[CardViewController alloc] initWithNibName:@"CardViewController" bundle:nil];
    [cardController fillCardInfo:card];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cardController];
    
    [cardController release];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     navController.navigationBar.barStyle = UIBarStyleBlack;
    [[self.tabBarController selectedViewController] presentModalViewController:navController animated:YES];
    
    [navController release];

    [card release];
    [userInfo release];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err{
    
    NSLog(@"ERROR PUSH : %@, %@, %@", [err localizedDescription], [err localizedFailureReason], [err localizedRecoverySuggestion]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{       
    NSLog(@"dizionario ricevuto da push = %@",userInfo);
    
    [self showModalCardDetail:userInfo];
}

#pragma mark - DatabaseAccessDelegate

-(void)didReceiveResponsFromServer:(NSString *)receivedData{
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Error connection = %@", [error description]);
}

#pragma mark - CORE DATA

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] & ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"cardsReceivedModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cardsReceivedModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
