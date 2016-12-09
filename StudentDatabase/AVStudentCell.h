//
//  AVStudentCell.h
//  StudentDatabase
//
//  Created by aiuar on 10.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVStudentCell : UITableViewCell

@property (strong, nonatomic) UILabel *firstNameLabel;
@property (strong, nonatomic) UILabel *lastNameLabel;
@property (strong, nonatomic) UILabel *birthdayLabel;
@property (strong, nonatomic) UIImageView *photoImageView;

@end
