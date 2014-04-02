//
//  MBaseTableViewController.m
//  MrMoney
//
//  Created by xingyong on 14-3-24.
//  Copyright (c) 2014年 xingyong. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MLogoView.h"
@interface MBaseTableViewController ()

@end

@implementation MBaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [self contentTableView];
    
    [self.view addSubview:_tableView];
    
}

- (void) dealloc {
    
    [self removeObserver:self
              forKeyPath:@"dataArray"];
    
    [self removeObserver:self
              forKeyPath:@"tableViewStyle"];
    
    
    self.tableView = nil;
    
    self.dataArray = nil;
    
}

- (id) init {
    
    if (self = [super init]) {
        
        _tableViewStyle = UITableViewStylePlain;
         
        
        [self addObserver:self forKeyPath:@"dataArray" options:0 context:NULL];
        
        [self addObserver:self forKeyPath:@"tableViewStyle" options:0 context:NULL];
        
    }
    
    return self;
}
#pragma mark - Observing

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context {
//    NSLog(@"keyPath-------------------------------%@ \n\n",keyPath);
    if ([keyPath isEqualToString:@"dataArray"]) {
        
        [_tableView reloadData];
    }
    else if ([keyPath isEqualToString:@"tableViewStyle"]) {
        
        if (_tableView.style != _tableViewStyle) {
            
            [_tableView removeFromSuperview];
             
            _tableView = [self contentTableView];
            [self.view addSubview:_tableView];
        }
    }
}


- (void)setTableDataArray:(NSArray *)items{
    
    [self.dataArray addObjectsFromArray:items];
    [_tableView reloadData];
    
}
#pragma mark - UITableView

- (UITableView *) contentTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:self.tableViewStyle];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask = self.view.autoresizingMask;
    tableView.backgroundColor = KVIEW_BACKGROUND_COLOR;
    tableView.backgroundView = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    
//    CGSize logoSize = CGSizeMake(90, 90);
//    
//    MLogoView * logo = [[MLogoView alloc] initWithFrame:Rect(0, -logoSize.height,CGRectGetWidth(tableView.bounds), logoSize.height)];
//    [tableView addSubview:logo];
    
    return tableView;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject* tableObject = [self.dataArray objectAtIndex:indexPath.row];
    NSAssert([tableObject isKindOfClass:NSClassFromString(@"NSString")], @"Table object is not an NSString. Override this method in your subclass", nil);
    
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = cellIdentifier;
    
    return cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
