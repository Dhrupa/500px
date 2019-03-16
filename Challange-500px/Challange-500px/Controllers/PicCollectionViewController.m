//
//  PicCollectionViewController.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-14.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "PicCollectionViewController.h"
#import "PicDetailViewController.h"
#import "PicCollectionViewCell.h"
#import "BaseHttp.h"
#import "UIHelper.h"
#import "AppDelegate.h"

#define BASE_URL @"https://api.500px.com/v1/photos?feature="
#define FEATURE  @"popular"
#define CONSUMER_KEY @"Use your consumerkey here"

@interface PicCollectionViewController ()
@property (strong, nonatomic) NSMutableArray *objectChanges;
@property (strong, nonatomic)NSMutableArray *sectionChanges;
@property (nonatomic) UIHelper *myUIHelper;
@end

@implementation PicCollectionViewController

static NSString * const reuseIdentifier = @"PicCollectionViewCell";

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Popular-500px";
    _objectChanges = [[NSMutableArray alloc]init];
    _sectionChanges = [[NSMutableArray alloc]init];
    self.myUIHelper = [[UIHelper alloc] init];
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self getPopularImage];
}

-(void)getPopularImage
{
    NSString *url = [NSString stringWithFormat:@"%@%@%s%@%s",BASE_URL,FEATURE,"&consumer_key=",CONSUMER_KEY,"&image_size=3"];
    
    BaseHttp *baseHttp = [[BaseHttp alloc] init];
    
    [baseHttp sendHTTPGetWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        long statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSDictionary *jsonData = nil;
        if(statusCode==200 && !error)
        {
            jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error: &error];
            [self userDataFromDictionary:jsonData];
        }else{
            [self.myUIHelper showSimpleAlertController:@"Couldn't fetch from 500px." errorMessage:error.localizedDescription viewController:self];
            return;
        }
    }];
}

-(void)userDataFromDictionary:(NSDictionary *)dictionary
{
    NSArray *photoArray = dictionary[@"photos"];
    for (NSDictionary *photoDictionary in photoArray)
    {
         NSManagedObject *photoModel = [NSEntityDescription insertNewObjectForEntityForName:@"PXPhotoModel" inManagedObjectContext:self.managedObjectContext];
        
        [photoModel setValue:[photoDictionary valueForKey:@"rating"] forKey:@"imgRating"];
        [photoModel setValue:[photoDictionary valueForKey:@"name"] forKey:@"imgName"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString *urlString = [[[photoDictionary valueForKey:@"images"] objectAtIndex:0] valueForKey:@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoModel setValue:imageData forKey:@"imgUrlData"];
            });
        });
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        PicDetailViewController *vc =[segue destinationViewController];
        vc.imgName = [object valueForKey:@"imgName"];
        vc.imgData = [object valueForKey:@"imgUrlData"];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicCollectionViewCell *cell = (PicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setImage:[UIImage imageWithData:[object valueForKey:@"imgUrlData"]]];
    long itemCount = [self.fetchedResultsController.fetchedObjects count];
    
    if(indexPath.row == itemCount-1) {
       [self getPopularImage];
    }
    
    return cell;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PXPhotoModel" inManagedObjectContext:self.managedObjectContext];
    //Edit the sortkey
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"imgName" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    // Set Entity,batch size and sorting
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in self.sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeMove:
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in self.objectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

@end
