//
//  AVStudentsTableView.m
//  StudentDatabase
//
//  Created by aiuar on 07.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import "AVStudentsTableView.h"
#import "AVStudentAddViewController.h"

#import <Masonry.h>
#import <CoreData/CoreData.h>
#import "AVStudent.h"

@interface AVStudentsTableView ()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSArray *arrayOfStudents;

@end

@implementation AVStudentsTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"StudentDatabase"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        
    }];
    
    self.title = self.groupName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                                          target:self
                                                                          action:@selector(addNewStudent:)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    [self getStudens];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getStudens];
    [self.tableView reloadData];
}

#pragma mark - Get all students

- (void)getStudens {
    
    NSMutableArray *array = [[NSMutableArray  alloc] init];
    
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Students" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName==%@",
                              self.groupName];
    [request setPredicate:predicate];
    
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:request error:&error];
    
    for(id student in resultArray)
    {
        AVStudent *stud = [[AVStudent alloc] init];
        stud.firstName = [student valueForKey:@"firstName"];
        stud.lastName = [student valueForKey:@"lastName"];
        stud.birthday = [student valueForKey:@"birthday"];
        
        if([student valueForKey:@"photoPath"]) {
            NSLog(@"%@",[student valueForKey:@"photoPath"]);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *filePath = [documentsPath stringByAppendingPathComponent:[student valueForKey:@"photoPath"]]; //Add the file name
            
            NSData *pngData = [NSData dataWithContentsOfFile:filePath];
            stud.photo = [UIImage imageWithData:pngData];
        }
        
        [array addObject:stud];
    }
    
    self.arrayOfStudents = [NSArray arrayWithArray:array];
}

#pragma mark - Actions

- (void)addNewStudent:(UIBarButtonItem *)sender {
    
    AVStudentAddViewController *vc = [[AVStudentAddViewController alloc] init];
    vc.groupName = self.groupName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfStudents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    
    CALayer *cellImageLayer = cell.imageView.layer;
    [cellImageLayer setCornerRadius:9];
    [cellImageLayer setMasksToBounds:YES];
    
    if(![[self.arrayOfStudents objectAtIndex:indexPath.row] photo]) {
        cell.imageView.image = [UIImage imageNamed:@"noavatar"];
    } else {
        cell.imageView.image = [[self.arrayOfStudents objectAtIndex:indexPath.row] photo];
    }
    
    cell.textLabel.numberOfLines = 3;
    NSString *date = [[self.arrayOfStudents objectAtIndex:indexPath.row] birthday];
    if(!date) {
        date = @"Не указана";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Имя: %@ \nФамилия: %@\nДата: %@", [[self.arrayOfStudents objectAtIndex:indexPath.row] firstName],
                                                                                                  [[self.arrayOfStudents objectAtIndex:indexPath.row] lastName],
                                                                                                  date];
    return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
