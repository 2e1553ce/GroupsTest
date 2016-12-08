//
//  AVStudentAddViewController.h
//  StudentDatabase
//
//  Created by aiuar on 07.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVStudentAddViewController : UIViewController

@property (strong, nonatomic) NSString *groupName;

@property (strong, nonatomic) UITextField   *firstNameTexField;
@property (strong, nonatomic) UITextField   *lastNameTextField;
@property (strong, nonatomic) UITextField   *birthdayTextField;
@property (strong, nonatomic) UIDatePicker  *birthdayPicker;
@property (strong, nonatomic) UIButton      *photoMakeButton;
@property (strong, nonatomic) UIButton      *photoLibraryButton;
@property (strong, nonatomic) NSString      *photoPath;
@property (strong, nonatomic) UIImage       *photoImage;
@property (strong, nonatomic) UIButton      *saveButton;

@end
