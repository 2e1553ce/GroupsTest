//
//  AVStudentCell.m
//  StudentDatabase
//
//  Created by aiuar on 10.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import "AVStudentCell.h"
#import <Masonry.h>

@implementation AVStudentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.firstNameLabel = [[UILabel alloc] init];
        self.firstNameLabel.textAlignment = NSTextAlignmentLeft;
        self.firstNameLabel.font = [UIFont systemFontOfSize:14];
        
        self.lastNameLabel = [[UILabel alloc] init];
        self.lastNameLabel.textAlignment = NSTextAlignmentLeft;
        self.lastNameLabel.font = [UIFont systemFontOfSize:14];
        
        self.birthdayLabel = [[UILabel alloc] init];
        self.birthdayLabel.textAlignment = NSTextAlignmentLeft;
        self.birthdayLabel.font = [UIFont systemFontOfSize:10];
        
        self.photoImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.firstNameLabel];
        [self.contentView addSubview:self.lastNameLabel];
        [self.contentView addSubview:self.birthdayLabel];
        [self.contentView addSubview:self.photoImageView];
        
        UIView *superview = self.contentView;
        
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(60));
            make.width.equalTo(@(60));
            
            make.centerY.equalTo(@((self.contentView.center.y / 2) - 10)); // cell.height = 80, imageView.height = 60, // +-10 at top/bot
            make.left.equalTo(superview).with.offset(5);
        }];

        
        [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(15));
            
            make.left.equalTo(self.photoImageView.mas_right).with.offset(10);
            make.right.equalTo(superview).with.offset(-10);
            make.top.equalTo(superview).with.offset(15);
        }];
        
        [self.lastNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(15));
            
            make.left.equalTo(self.photoImageView.mas_right).with.offset(10);
            make.right.equalTo(superview).with.offset(-10);
            make.top.equalTo(self.firstNameLabel.mas_bottom).with.offset(5);
        }];

        [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(10));
            
            make.left.equalTo(self.photoImageView.mas_right).with.offset(10);
            make.right.equalTo(superview).with.offset(-10);
            make.top.equalTo(self.lastNameLabel.mas_bottom).with.offset(5);
        }];

        
    }
    return self;

}

/*
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    
    CGRect frame;
    
    frame = CGRectMake(boundsX + 10 ,0, 50, 50);
    self.photoImageView.frame = frame;
    
    frame = CGRectMake(boundsX + 70 ,5, 200, 25);
    self.firstNameLabel.frame = frame;
    
    frame = CGRectMake(boundsX + 70 ,30, 200, 25);
    self.lastNameLabel.frame = frame;
    
    frame = CGRectMake(boundsX + 70 ,55, 200, 20);
    self.birthdayLabel.frame = frame;
}
*/
- (BOOL)needsUpdateConstraints {
    return YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
