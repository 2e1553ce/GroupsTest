//
//  AVStudent.h
//  StudentDatabase
//
//  Created by aiuar on 08.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AVStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) UIImage  *photo;

@end
