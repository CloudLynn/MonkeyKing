//
//  ContactViewController.m
//  MonkeyKing
//
//  Created by Apple on 2017/2/6.
//  Copyright © 2017年 Shengwukong. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initailizeUserInterface];
    
}

- (void)initailizeUserInterface {
    self.tableView.tableFooterView = [UIView new];
    //    [self.tableView registerNib:[UINib nibWithNibName:@"PeopelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"kPeopleCell"];
    //    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    //    NSLog(@"====%@",buddyList);
    
    
    
}

#pragma mark -- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
}
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PeopelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPeopleCell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"PeopelTableViewCell" owner:self options:nil] lastObject];
//    }
//    cell.userName.text = @"123";
//    return cell;
    return nil;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- initUI --
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
