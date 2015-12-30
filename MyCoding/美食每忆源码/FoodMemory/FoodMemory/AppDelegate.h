//
//  AppDelegate.h
//  FoodMemory
//
//  Created by morplcp on 15/12/2.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MMDrawerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)MMDrawerController *mmdVC;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) CLLocation * location;
@property (nonatomic,strong) CLLocationManager * locationManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

