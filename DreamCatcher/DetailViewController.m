//
//  DetailViewController.m
//  DreamCatcher
//
//  Created by Michael Andrew Pujol on 3/23/15.
//  Copyright (c) 2015 Michael Pujol. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    self.textView.text = self.descriptionString;
}


@end
