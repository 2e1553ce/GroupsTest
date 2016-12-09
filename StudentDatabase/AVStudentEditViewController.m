//
//  AVStudentEditViewController.m
//  StudentDatabase
//
//  Created by aiuar on 09.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import "AVStudentEditViewController.h"

#import <Masonry.h>
#import <View+MASShorthandAdditions.h>
#import <IQUIView+Hierarchy.h>
#import <CoreData/CoreData.h>

@interface AVStudentEditViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

@end

@implementation AVStudentEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"StudentDatabase"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Редактирование";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createStudentFields];
    [self parseStudent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create interface

- (void)createStudentFields {
    
    self.firstNameTexField = [[UITextField alloc] init];
    [self.firstNameTexField setBorderStyle:UITextBorderStyleRoundedRect];
    self.firstNameTexField.placeholder = @"Введите имя";
    self.firstNameTexField.textAlignment = NSTextAlignmentCenter;
    
    self.lastNameTextField = [[UITextField alloc] init];
    [self.lastNameTextField setBorderStyle:UITextBorderStyleRoundedRect];
    self.lastNameTextField.placeholder = @"Введите фамилию";
    self.lastNameTextField.textAlignment = NSTextAlignmentCenter;
    
    self.birthdayTextField = [[UITextField alloc] init];
    [self.birthdayTextField setBorderStyle:UITextBorderStyleRoundedRect];
    self.birthdayPicker = [[UIDatePicker alloc] init];
    [self.birthdayPicker setDatePickerMode:UIDatePickerModeDate];
    [self.birthdayPicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthdayTextField.inputView = self.birthdayPicker;
    self.birthdayTextField.delegate = self;
    self.birthdayTextField.placeholder = @"Введите дату рождения";
    self.birthdayTextField.textAlignment = NSTextAlignmentCenter;
    
    self.photoMakeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.photoMakeButton addTarget:self
                             action:@selector(photoMakeButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.photoMakeButton setTitle:@"Камера" forState:UIControlStateNormal];
    [[self.photoMakeButton layer] setBorderWidth:1.0f];
    [[self.photoMakeButton layer] setCornerRadius:5.0f];
    [[self.photoMakeButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.photoLibraryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.photoLibraryButton addTarget:self
                                action:@selector(photoLibraryButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.photoLibraryButton setTitle:@"Фото библиотека" forState:UIControlStateNormal];
    [[self.photoLibraryButton layer] setBorderWidth:1.0f];
    [[self.photoLibraryButton layer] setCornerRadius:5.0f];
    [[self.photoLibraryButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.updateButton addTarget:self
                        action:@selector(updateButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.updateButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    [[self.updateButton layer] setBorderWidth:1.0f];
    [[self.updateButton layer] setCornerRadius:5.0f];
    [[self.updateButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.view addSubview:self.firstNameTexField];
    [self.view addSubview:self.lastNameTextField];
    [self.view addSubview:self.birthdayTextField];
    [self.view addSubview:self.photoMakeButton];
    [self.view addSubview:self.photoLibraryButton];
    [self.view addSubview:self.updateButton];
    
    // Autolayout
    UIView *superview = self.view;
    
    [self.firstNameTexField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
        make.top.equalTo(superview).with.offset(10);
    }];
    
    [self.lastNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
        make.top.equalTo(self.firstNameTexField.mas_bottom).with.offset(10);
    }];
    
    [self.birthdayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
        make.top.equalTo(self.lastNameTextField.mas_bottom).with.offset(10);
    }];
    
    [self.photoMakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.width.equalTo(self.photoLibraryButton);
        
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(self.photoLibraryButton.mas_left).with.offset(-10);
        make.top.equalTo(self.birthdayTextField.mas_bottom).with.offset(10);
    }];
    
    [self.photoLibraryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.width.equalTo(self.photoMakeButton);
        
        make.left.equalTo(self.photoMakeButton.mas_right).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
        make.top.equalTo(self.birthdayTextField.mas_bottom).with.offset(10);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        
        make.left.equalTo(superview).with.offset(10);
        make.right.equalTo(superview).with.offset(-10);
        make.top.equalTo(self.photoMakeButton.mas_bottom).with.offset(10);
    }];
}

#pragma mark - Actions
- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    self.birthdayTextField.text = [formatter stringFromDate:datePicker.date];
}

- (void)photoMakeButtonAction:(UIButton *)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                             message:@"На симуляторе не возможно выполнить данную функцию"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:nil];
        [myAlertView addAction:ok];
        [self presentViewController:myAlertView animated:YES completion: nil];
        
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)photoLibraryButtonAction:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)updateButtonAction:(UIButton *)sender {
    
    NSString *firstName = self.firstNameTexField.text;
    NSString *lastName = self.lastNameTextField.text;
    
    if([firstName isEqualToString:@""] || [lastName isEqualToString:@""]) {
        UIAlertController *myAlertView = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                             message:@"Имя и фамилия не могут быть пустыми!"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler: nil];
        [myAlertView addAction:ok];
        
        [self presentViewController:myAlertView animated:YES completion: nil];
        
    } else {
        
        [self.student setValue:firstName forKey:@"firstName"];
        [self.student setValue:lastName forKey:@"lastName"];
        
        if(![self.birthdayTextField.text isEqualToString:@""]) {
            [self.student setValue:self.birthdayTextField.text forKey:@"birthday"];
        }
        
        // Update image
        if(self.photoImage) {
            NSString *prefixString = @"Image";
            
            NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
            NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%@.png", prefixString, guid];
            
            NSData *pngData = UIImagePNGRepresentation(self.photoImage);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *filePath = [documentsPath stringByAppendingPathComponent:uniqueFileName]; //Add the file name
            [pngData writeToFile:filePath atomically:YES]; //Write the file
            self.photoPath = uniqueFileName;
            
            if(self.photoPath != nil || ![self.photoPath isEqualToString:@""]) {
                [self.student setValue:self.photoPath forKey:@"photoPath"];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.photoImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if([self.birthdayTextField.text isEqualToString:@""]) {
        self.birthdayTextField.text = @"2016-12-08";
    }
}


#pragma mark - Parse fetched student

- (void)parseStudent {
    self.firstNameTexField.text = [self.student valueForKey:@"firstName"];
    self.lastNameTextField.text = [self.student valueForKey:@"lastName"];
    self.birthdayTextField.text = [self.student valueForKey:@"birthday"];
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
