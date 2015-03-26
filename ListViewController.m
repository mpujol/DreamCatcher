//
//  ListViewController.m
//  DreamCatcher
//
//  Created by Michael Andrew Pujol on 3/21/15.
//  Copyright (c) 2015 Michael Pujol. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *titlesArray;
@property NSMutableArray *descriptionArray;
@property (nonatomic) NSSet *possibleTitles;


@end

@implementation ListViewController

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNavigationBarItems];
    self.titlesArray = [NSMutableArray new];
    self.descriptionArray = [NSMutableArray new];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Actions

- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender
{
    [self presentDreamEntry];
}

- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender
{
    self.possibleTitles = [NSSet setWithObjects:@"Edit",@"Done", nil];

    if (self.editing) {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    } else {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";

    }
}

#pragma mark - UITableView Delegate methods

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *titleItem = [self.titlesArray objectAtIndex:sourceIndexPath.row];
    [self.titlesArray removeObject:titleItem];
    [self.titlesArray insertObject:titleItem atIndex:destinationIndexPath.row];

    NSString *descriptionItem = [self.descriptionArray objectAtIndex:sourceIndexPath.row];
    [self.descriptionArray removeObject:descriptionItem];
    [self.descriptionArray insertObject:descriptionItem atIndex:destinationIndexPath.row];

    [self.tableView reloadData];

}

#pragma mark - helper methods

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.titlesArray removeObjectAtIndex:indexPath.row];
    [self.descriptionArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.titlesArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)initializeNavigationBarItems
{
    //Right nav bar button
    UIBarButtonItem *barButton;

    //left nav bar button
    barButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(onEditButtonTapped:)];
    barButton.style = UIBarButtonItemStylePlain;
    barButton.possibleTitles = [NSSet setWithObjects:@"Edit", @"Done", nil];

    self.navigationItem.leftBarButtonItem = barButton;

}


-(void)presentDreamEntry
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter New Dream" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream Title";
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream Description";
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textFieldOne = alertController.textFields[0];
        UITextField *textfieldTwo = alertController.textFields[1];
        [self.titlesArray addObject:textFieldOne.text];
        [self.descriptionArray addObject:textfieldTwo.text];

        [self.tableView reloadData];
        
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];

    [self presentViewController:alertController animated:true completion:nil];

}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailVC = segue.destinationViewController;
    detailVC.titleString = [self.titlesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    detailVC.descriptionString = [self.descriptionArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

@end
