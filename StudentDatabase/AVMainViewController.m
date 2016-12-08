//
//  AVMainViewController.m
//  StudentDatabase
//
//  Created by aiuar on 07.12.16.
//  Copyright © 2016 A.V. All rights reserved.
//

#import "AVMainViewController.h"
#import "AVStudentsTableView.h"

#import <Masonry.h>

@interface AVMainViewController ()

@end

@implementation AVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Группы студентов";
    [self createGroupButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create buttons

- (void)createGroupButtons {
    
    // Lorem group button
    self.loremGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loremGroupButton addTarget:self
                              action:@selector(loremButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.loremGroupButton setTitle:@"Lorem группа" forState:UIControlStateNormal];
    
    // Ipsum group button
    self.ipsumGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.ipsumGroupButton addTarget:self
                              action:@selector(ipsumButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.ipsumGroupButton setTitle:@"Ipsum группа" forState:UIControlStateNormal];

    [self.view addSubview: self.ipsumGroupButton];
    [self.view addSubview: self.loremGroupButton];
    
    // Autolayout
    UIView *superview = self.view;
    
    [self.loremGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120.f));
        make.height.equalTo(@(30.f));
        make.center.equalTo(superview).centerOffset(CGPointMake(0.f, -15.f));
        //make.bottom.equalTo(self.ipsumGroupButton.mas_top).offset(-padding);
    }];
    
    [self.ipsumGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120.f));
        make.height.equalTo(@(30.f));
        make.center.equalTo(superview).centerOffset(CGPointMake(0.f, 15.f));
        //make.top.equalTo(self.loremGroupButton.mas_bottom).offset(padding);
    }];

}

#pragma mark - Actions

- (void)loremButtonAction:(UIButton *)sender {
    AVStudentsTableView *vc = [[AVStudentsTableView alloc] init];
    vc.groupName = @"Lorem";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ipsumButtonAction:(UIButton *)sender {
    AVStudentsTableView *vc = [[AVStudentsTableView alloc] init];
    vc.groupName = @"Ipsum";
    [self.navigationController pushViewController:vc animated:YES];
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
