//
//  ViewController.m
//  historySearch
//
//  Created by Mister_Sun on 16/12/15.
//  Copyright © 2016年 SurSen. All rights reserved.
//

#import "ViewController.h"
#import "DPSearchViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义各种历史搜索样式";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (indexPath.section == 0) { // 选择热门搜索风格
        cell.textLabel.text = @[@"默认风格（标签）", @"随机颜色标签风格", @"有边框风格", @"有圆角风格", @"排名风格", @"矩阵风格"][indexPath.row];
    } else { // 选择搜索历史风格
        cell.textLabel.text = @[@"默认风格（cell）", @"标签风格", @"随机颜色标签风格", @"有边框风格", @"有圆角风格"][indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{

    return section ? 5 : 6;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return section ? @"选择搜索历史风格（热门搜索为默认风格）" : @"选择热门搜索风格（搜索历史为默认风格）";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    NSMutableArray *arr= [NSMutableArray arrayWithArray:hotSeaches];
    DPSearchViewController *search = [DPSearchViewController historySearchWithSeatchTextArray:arr andSearchBarPlaceholderText:@"搜索热门语言" andSearchBlock:^(DPSearchViewController *searchController, UISearchBar *searchBar, NSString *searchText) {
        
    }];
    if (indexPath.section == 0) {
        search.HotSearchType = indexPath.row;
        search.HistorySearchType = DPHistorySearchStypeTypeCell;
    }
    else{
    
        search.HotSearchType = DPHotSeatchStypeTypeDefault;
        search.HistorySearchType = indexPath.row;
    }
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:search] animated:NO completion:nil];

}
@end
