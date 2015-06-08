#import "TPTableViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "TPShowInfoViewController.h"
#import "TPTableViewInformations.h"

@interface TPTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *recordArray;

@end

@implementation TPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordArray = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"AnnotationStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    if([objects count] == 0){
        
        NSLog(@"No matches");
    } else {
        
        for(int i = 0; i < [objects count]; i++){
            
            matches = objects[i];
            TPSaveInformationContainer *record = [TPSaveInformationContainer new];
            record.imageName = [matches valueForKey:@"name"];
            record.annotationsImage = [UIImage imageWithData:[matches valueForKey:@"picture"]];
            record.soundRecord = [matches valueForKey:@"sound"];
            record.coordinateLat = [matches valueForKey:@"coordinateLat"];
            record.coordinateLong = [matches valueForKey:@"coordinateLong"];
            
            [self.recordArray addObject:record];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    TPSaveInformationContainer *tmpRecord = [self.recordArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpRecord.imageName;
    cell.imageView.image = tmpRecord.annotationsImage;
    return cell;    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TPTableViewInformations *tmpRecord = [self.recordArray objectAtIndex:indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TPShowInfoViewController *SIVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"DetalTable"];
    SIVC.containerView = tmpRecord;
    [self.navigationController pushViewController:SIVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"AnnotationStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    [context deleteObject:objects[indexPath.row]];
    [self.recordArray removeObjectAtIndex: indexPath.row];
    [context save:&error];
    [tableView reloadData];
}
@end