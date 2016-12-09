//
//  AVStudentsTableView.m
//  StudentDatabase
//
//  Created by aiuar on 07.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import "AVStudentsTableView.h"
#import "AVStudentAddViewController.h"
#import "AVStudentEditViewController.h"
#import "AVStudentCell.h"

#import <Masonry.h>
#import <CoreData/CoreData.h>
#import "AVStudent.h"

@interface AVStudentsTableView ()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSArray *arrayOfStudents;
@property (strong, nonatomic) NSMutableArray *fetchedArrayOfStudents;

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
    
    [self.persistentContainer.viewContext save:nil];
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
    self.fetchedArrayOfStudents = [NSMutableArray arrayWithArray: [context executeFetchRequest:request error:&error]];
    
    for(id student in self.fetchedArrayOfStudents)
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
    
    AVStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        cell = [[AVStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    
    CALayer *cellImageLayer = cell.photoImageView.layer;
    [cellImageLayer setCornerRadius:9];
    [cellImageLayer setMasksToBounds:YES];
    
    if(![[self.arrayOfStudents objectAtIndex:indexPath.row] photo]) {
        cell.photoImageView.image = [UIImage imageNamed:@"noavatar"];
    } else {
        cell.photoImageView.image = [[self.arrayOfStudents objectAtIndex:indexPath.row] photo];
    }
    
    //cell.textLabel.numberOfLines = 0;
    //cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSString *date = [[self.arrayOfStudents objectAtIndex:indexPath.row] birthday];
    if(!date) {
        date = @"Не указана";
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Имя: %@ \nФамилия: %@\nДата: %@", [[self.arrayOfStudents objectAtIndex:indexPath.row] firstName],
      //                                                                                            [[self.arrayOfStudents objectAtIndex:indexPath.row] lastName],
        //                                                                                          date];
    
    cell.firstNameLabel.text = [[self.arrayOfStudents objectAtIndex:indexPath.row] firstName];
    cell.lastNameLabel.text = [[self.arrayOfStudents objectAtIndex:indexPath.row] lastName];
    cell.birthdayLabel.text = date;
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.persistentContainer.viewContext deleteObject:[self.fetchedArrayOfStudents objectAtIndex:indexPath.row]];
        [self.persistentContainer.viewContext save:nil];
        [self.fetchedArrayOfStudents removeObjectAtIndex:indexPath.row];

        self.arrayOfStudents = [NSArray arrayWithArray:self.fetchedArrayOfStudents];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVStudentEditViewController *vc = [[AVStudentEditViewController alloc] init];
    vc.student = [self.fetchedArrayOfStudents objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
