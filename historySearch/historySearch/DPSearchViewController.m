//
//  DPSearchViewController.m
//  historySearch
//
//  Created by Mister_Sun on 16/12/15.
//  Copyright © 2016年 SurSen. All rights reserved.
//

#import "DPSearchViewController.h"
#import "DPSearchConstFile.h"
#import "UIView+Frame.h"
@interface DPSearchViewController ()

@end

@implementation DPSearchViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
    
}
#pragma mark - 初始化的时候，就进行默认配置.
-(instancetype)init{

    if (self = [super init]) {
        [self normalSetUp];
    }
    return self;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        [self normalSetUp];
    }
    return self;
}
+(DPSearchViewController *)historySearchWithSeatchTextArray:(NSMutableArray *)searchArray andSearchBarPlaceholderText:(NSString *)placehoderText{

    DPSearchViewController *searchVc = [[DPSearchViewController alloc]init];
    searchVc.hotSearchArray = searchArray;
    searchVc.searchBar.placeholder = placehoderText;
    return searchVc;
}
+(DPSearchViewController *)historySearchWithSeatchTextArray:(NSMutableArray *)searchArray andSearchBarPlaceholderText:(NSString *)placehoderText andSearchBlock:(SearchBlock)historySearchBlock{

    DPSearchViewController *searchVC = [self historySearchWithSeatchTextArray:searchArray andSearchBarPlaceholderText:placehoderText];
    searchVC.searchBlock = historySearchBlock;
    return searchVC;

}
#pragma mark - 基本配置
- (void)normalSetUp{
   
    self.view.userInteractionEnabled = YES;
    // 添加tableView
    [self.view addSubview:self.searchTableView];
    
    // 风格默认配置
    self.HotSearchType = DPHotSeatchStypeTypeDefault;
    self.HistorySearchType = DPHistorySearchStypeTypeDefault;
    self.searchSuggestionHidden = NO;
    self.SearchResultMode = DPSearchResultShowModeDefault;
    
    // 历史搜索缓存路径
    self.searchStoryPath = DPSearchHistoriesPath;
    
    // 添加键盘弹出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    // 设置搜索框左边的取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClick)];
    
    // 添加titleView和搜索框
    UIView *titleView = [[UIView alloc]init];
    titleView.X(DPMargin *0.5).Y(7).Width(self.view.width - 64 - DPMargin*2).Height(30);
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:titleView.bounds];
    self.searchBar = searchBar;
    searchBar.Width(titleView.width - DPMargin*1.5);
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    // 添加headerView，存放热门tag
    UIView *headerView = [[UIView alloc]init];
    UIView *contentView = [[UIView alloc]init];
    
    headerView.userInteractionEnabled = YES;
    contentView.userInteractionEnabled = YES;
    //[headerView setBackgroundColor:[UIColor grayColor]];
    // 热门搜索那个Label
    UILabel *titleLabel = [self setupTitleLabel:DPHotSearchText];
    self.hotTitlelabel = titleLabel;
    [contentView addSubview:titleLabel];
    contentView.Y(DPMargin * 2).X(DPMargin ).Width(SCREEN_WIDTH - DPMargin * 2);
    [headerView addSubview:contentView];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    self.hotSearchView = contentView;
    
    // 热门搜索标签总
    UIView *allTagsView = [[UIView alloc]init];
    allTagsView.userInteractionEnabled = YES;
    allTagsView.X(contentView.x).Y(CGRectGetMaxY(titleLabel.frame) + DPMargin *2).Width(contentView.width);
    [contentView addSubview:allTagsView];
    headerView.Height(CGRectGetMaxY(allTagsView.frame)+ DPMargin);
    self.allTagsView = allTagsView;
    self.allTagsView.userInteractionEnabled = YES;
    self.searchTableView.userInteractionEnabled = YES;
    //[headerView setBackgroundColor:[UIColor redColor]];
    //[self.allTagsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotTagClick:)]];
    self.searchTableView.tableHeaderView = headerView;
    self.searchTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.searchTableView.backgroundColor = [UIColor whiteColor];
    // 设置底部清除历史搜索按钮
    UIView *footerView = [[UIView alloc]init];
    footerView.Height(30);
    self.searchTableView.tableFooterView = footerView;
    //footerView.backgroundColor = [UIColor redColor];
    UILabel * footerLabel = [[UILabel alloc]init];
    [footerView addSubview:footerLabel];
    footerLabel.text = DPClearSearchText;
    footerLabel.textColor = [UIColor darkGrayColor];
    [footerLabel setFont:[UIFont systemFontOfSize:13]];
    [footerLabel setTextAlignment:NSTextAlignmentCenter];
    footerView.userInteractionEnabled = YES;
    footerLabel.userInteractionEnabled = YES;
    footerLabel.Height(footerView.height);
    footerView.Width(SCREEN_WIDTH);
    footerLabel.Width(SCREEN_WIDTH);
    [footerView addSubview:footerLabel];
    [footerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearClick)]];
    self.hotSearchArray = nil;
    
}

/** 创建并设置标题 */
- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.tag = 1;
    titleLabel.textColor = DPTextColor;
    [titleLabel sizeToFit];
    titleLabel.X(0).Y(0);
    return titleLabel;
}
#pragma mark - 设置热门搜索风格
- (void)setHotSearchType:(DPHotSeatchStypeType)HotSearchType{

    
    _HotSearchType = HotSearchType;
    switch (HotSearchType) {
            // 有颜色的tag
        case DPHotSeatchStypeTypeColorTag:
            for (UILabel *label in self.allTagsView.subviews) {
                label.textColor = [UIColor whiteColor];
                [label setBackgroundColor:[UIColor orangeColor]];
                label.layer.borderWidth = 0.0;
                label.layer.borderColor = nil;
                
            }
            break;
            // 有边框的tag
            case DPHotSeatchStypeTypeBorderTag:
            for (UILabel *tag in self.allTagsView.subviews) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = [UIColor colorWithRed:223 green:223 blue:223 alpha:1].CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
            }
            break;
            // 圆角
            case DPHotSeatchStypeTypeRoundedTag:
            for (UILabel *tag in self.allTagsView.subviews) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = [UIColor colorWithRed:223 green:223 blue:223 alpha:1].CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
                // 设置边框弧度为圆弧
                tag.layer.cornerRadius = tag.height * 0.5;
            }
            break;
            // 矩阵式
            case DPHotSeatchStypeTypeMatrixTag:
            self.hotSearchArray = self.hotSearchArray;
            break;
            // 排名
            case DPHotSeatchStypeTypeRankingTag:
            self.rankColorArray = nil;
            break;
        default:
            break;
    }


}
#pragma mark - 设置热门搜索数据
-(void)setHotSearchArray:(NSMutableArray *)hotSearchArray{

    _hotSearchArray = hotSearchArray;
    
    // 没有热门搜索数据，将头部视图和标签隐藏
    if (_hotSearchArray.count == 0) {
        self.searchTableView.tableHeaderView.hidden = YES;
        self.hotSearchView.hidden = YES;
        self.hotTitlelabel.hidden = YES;
        return;
    }

    // 有数据的话
    self.searchTableView.tableHeaderView.hidden = NO;
    self.hotSearchView.hidden = NO;
    self.hotTitlelabel.hidden = NO;
    
    // 根据风格配置不同的风格视图
    switch (self.HotSearchType) {
        case DPHotSeatchStypeTypeRankingTag:
            NSLog(@"排名风格");
            [self setUpHotSearchRankingStyle];
            break;
            case DPHotSeatchStypeTypeMatrixTag:
            NSLog(@"矩阵风格");
            [self setUpHotSearchMatrixlStyle];
            break;
        default:
            NSLog(@"默认风格，包括颜色圆角等");
            [self setUpHotSearchNormalStyle];
            break;
    }
    
    // 配置不同历史搜索风格
    [self setHistorySearchType:self.HistorySearchType];
}
#pragma mark - 配置热门搜索默认风格
- (void)setUpHotSearchNormalStyle{
    
    // 根据所有Label的名字数组布局所有的Label，存放所有的Label
    self.hotSearchLabelArray = [self addLayoutFromContentView:self.allTagsView andHotSearchArray:self.hotSearchArray];
    
    // 配置样式
    [self setHotSearchType:self.HotSearchType];
}
#pragma mark - 配置热门搜索排名风格
- (void)setUpHotSearchRankingStyle{
    UIView *contentView = self.allTagsView;
    [self.allTagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 存放排名文字
    NSMutableArray *labelsArray = [NSMutableArray array];
    // 存放排名
     NSMutableArray *tagsArray = [NSMutableArray array];
    // 存放每一个排名
    NSMutableArray *rankViewArr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.hotSearchArray.count; i ++) {
        
        // 容器
        UIView *rankView = [[UIView alloc]init];
        [contentView addSubview:rankView];
        rankView.Height(RankViewHeight);
        rankView.Width((SCREEN_WIDTH - RankViewHeight * 3) * 0.5);
        
        // 排名Tag
        UILabel *rankTag = [[UILabel alloc] init];
        rankTag.textAlignment = NSTextAlignmentCenter;
        rankTag.font = [UIFont systemFontOfSize:13];
        rankTag.layer.cornerRadius = 3;
        rankTag.clipsToBounds = YES;
        rankTag.text = [NSString stringWithFormat:@"%ld", i + 1];
        [rankTag sizeToFit];
        rankTag.Width(rankTag.width + DPMargin * 1);
        rankTag.Height(rankTag.width);
        rankTag.Y((rankView.height - rankTag.height ) * 0.5);
        [tagsArray addObject:rankTag];
        [rankView addSubview:rankTag];
        
        // 内容
        UILabel *rankTextLabel = [[UILabel alloc] init];
        rankTextLabel.text = self.hotSearchArray[i];
        rankTextLabel.userInteractionEnabled = YES;
        [rankTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotTagClick:)]];
        rankTextLabel.tag = 1;
        rankTextLabel.textAlignment = NSTextAlignmentLeft;
        rankTextLabel.backgroundColor = [UIColor clearColor];
        rankTextLabel.textColor = DPTextColor;
        rankTextLabel.font = [UIFont systemFontOfSize:14];
        rankTextLabel.X(CGRectGetMaxX(rankTag.frame) + DPMargin);
        rankTextLabel.Width((SCREEN_WIDTH - DPMargin * 3) * 0.5 - rankTextLabel.x);
        rankTextLabel.Height(rankView.height);;
        [labelsArray addObject:rankTextLabel];
        [rankView addSubview:rankTextLabel];
        
        // 添加分割线
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-content-line"]];
        line.Height( 0.5);
        line.alpha = 0.7;
        line.X (-SCREEN_WIDTH * 0.5);
        line.Y( rankView.height - 1);
        line.Width(SCREEN_WIDTH);
        [rankView addSubview:line];
        [rankViewArr addObject:rankView];
        switch (i) {
            case 0:
                rankTag.backgroundColor = [UIColor DP_colorWithHexString:self.rankColorArray[0]];
                rankTag.textColor = [UIColor whiteColor];
                break;
                case 1:
                rankTag.backgroundColor = [UIColor DP_colorWithHexString:self.rankColorArray[1]];
                rankTag.textColor = [UIColor whiteColor];
                break;
                case 2:
                rankTag.backgroundColor = [UIColor DP_colorWithHexString:self.rankColorArray[2]];
                rankTag.textColor = [UIColor whiteColor];
                break;
                
            default:
                rankTag.backgroundColor = [UIColor DP_colorWithHexString:self.rankColorArray[3]];
                rankTag.textColor = DPTextColor;
                break;
        }
        
    }
    self.rankViewArr = rankViewArr;
    self.rankTagArr = tagsArray;
    self.rankTextArr = labelsArray;
    
    // 布局
    for (NSInteger i = 0; i<self.rankViewArr.count; i++) {
        UIView *rankView = self.rankViewArr[i];
        rankView.X((DPMargin + rankView.width) * (i % 2));
        rankView.Y((rankView.height) * (i / 2));
    }
    
    // 设置容器的高度
    contentView.Height(CGRectGetMaxY(self.allTagsView.subviews.lastObject.frame) );
    self.hotSearchView.Height(CGRectGetMaxY(self.allTagsView.frame));
    self.searchTableView.tableHeaderView.Height(CGRectGetMaxY(self.hotSearchView.frame) ) ;
    self.searchTableView.tableHeaderView.hidden = NO;
    [self.searchTableView setTableHeaderView:self.searchTableView.tableHeaderView];
    
}
#pragma mark - 配置热门搜索矩阵风格
- (void)setUpHotSearchMatrixlStyle{
    
}
#pragma mark - 配置历史搜索风格
-(void)setHistorySearchType:(DPHistorySearchStypeType)HistorySearchType{

    if (HistorySearchType == DPSearchResultShowModeDefault) {
        return;
    }
    

}
#pragma mark - 设置排名布局
-(void)setRankColorArray:(NSMutableArray<NSString *> *)rankColorArray{

    // 颜色只取四个就行，前三名的颜色和默认的颜色
    if (rankColorArray.count < 4) {
        // 如果传入的数组颜色少于四个，那么给默认的颜色
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankColorArray = [NSMutableArray arrayWithArray:colorStrings];
    }
    else{
    
        NSArray *arr = @[rankColorArray[0],rankColorArray[1],rankColorArray[2],rankColorArray[3] ];
        _rankColorArray = [NSMutableArray arrayWithArray:arr];
    }
    // 开始布局
    self.hotSearchArray = self.hotSearchArray;
}

#pragma mark - 添加热门标签布局,普通布局
- (NSMutableArray *)addLayoutFromContentView:(UIView *)contentView andHotSearchArray:(NSMutableArray <NSString *>*)hotSearchArray{
    
    // 数组里的元素都会调用的方法，都会调用removeFromSuperView
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    contentView.userInteractionEnabled = YES;
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (NSString *title in hotSearchArray) {
        UILabel *label = [self labelWithTitle:title];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotTagClick:)];
        [label addGestureRecognizer:tap];
        label.tag = 1;
        [contentView addSubview:label];
        [tagsArray addObject:label];
    }
    
    // 动态计算每个Label的位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat currentRow = 0;
    CGFloat currentCol = 0;
    
    for (NSInteger i = 0 ; i < contentView.subviews.count; i ++) {
        UILabel *label = contentView.subviews[i];
        // 当Label的宽度大于屏幕的宽的的时候，让Label的宽度等于屏幕的宽度
        if (label.width > contentView.width) {
            label.Width(contentView.width);
        }
        // 当排到最后一个Label需要换行的时候
        if ((currentX + label.width + DPMargin * currentRow) > contentView.width) {
            label.X(0);
            label.Y((currentY += label.height) + DPMargin * (++currentCol));
            currentX = label.width;
            currentRow = 1;
        }
        // 不换行
        else {
            label.X((currentX += label.width) - label.width + DPMargin * currentRow);
            label.Y(currentY + DPMargin * currentCol );
            currentRow ++;
        }
        
    }
    // 标签总视图的总高度
    contentView.Y(CGRectGetMaxY(self.hotTitlelabel.frame )+ DPMargin);
    self.allTagsView.Height(CGRectGetMaxY(contentView.subviews.lastObject.frame) +   + DPMargin * 2);
    self.hotSearchView.Height(CGRectGetMaxY(self.allTagsView.frame) );
    self.searchTableView.tableHeaderView.Height(CGRectGetMaxY(self.allTagsView.frame ) + DPMargin * 2);
    self.searchTableView.tableHeaderView.hidden = NO;
    [self.searchTableView setTableHeaderView:self.searchTableView.tableHeaderView];
    self.searchTableView.tableHeaderView.userInteractionEnabled = YES;
    return tagsArray;
    

}/** 添加标签 */
- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor DP_colorWithHexString:@"#fafafa"];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.Width(label.width + 20);
    label.Height(label.height + 14);
    return label;
}
#pragma mark - 懒加载
-(UITableView *)searchTableView{

    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _searchTableView.userInteractionEnabled = YES;
        //_searchTableView.backgroundColor = [UIColor orangeColor];
        self.view.backgroundColor = [UIColor whiteColor];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    }
    return _searchTableView;
    
}

-(NSMutableArray<NSString *> *)historyArray{

    if (!_historyArray) {
        _historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.searchStoryPath];
        if (!_historyArray) {
            _historyArray = [NSMutableArray array];
        }
    }
    return _historyArray;

}
-(UITableViewController *)searchResultTableViewController{

    if (!_searchResultTableViewController) {
        _searchResultTableViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.searchResultTableView = _searchResultTableViewController.tableView;
    }
    return _searchResultTableViewController;
}
#pragma mark - 键盘弹出监听方法
- (void)keyBoardShow:(NSNotification *)no{
    NSDictionary *userInfo = no.userInfo;
    CGFloat height = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardHeight = height;
    self.keyboardShowing = YES;
}
#pragma mark - 搜索取消按钮点击事件 
- (void)cancelButtonClick{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 清空历史搜索
- (void)clearClick{
    [self.historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchStoryPath];
    if (self.HistorySearchType == DPHistorySearchStypeTypeCell) {
        [self.searchTableView reloadData];
    }
    else{
    
        self.HistorySearchType = self.HistorySearchType;
    }
}

#pragma mark -- 点击热门标签调用的方法
- (void)hotTagClick:(UITapGestureRecognizer *)tap{

    UILabel *label = (UILabel *)tap.view;
    self.searchBar.text = label.text;
    // 如果是cell样式就不用再布局了，直接用tableView的方式刷新列表就行了
    if (self.HistorySearchType == DPHistorySearchStypeTypeCell) {
        [self.searchTableView reloadData];
    }
    else {
    
        self.HistorySearchType = self.HistorySearchType;
    }
    // 当点击热门搜索Label时候
    if (label.tag == 1) {
        // 当遵循了代理方法的时候
        if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectHotTagAtIndex:searchText:)]) {
            [self.delegate searchViewController:self didSelectHotTagAtIndex:[self.hotSearchLabelArray indexOfObject:label] searchText:label.text];
        }
        else{
            [self searchBarBeginSearch:self.searchBar];
        }
    }
    else{
    
        
    }
}
#pragma mark - 开始搜索
- (void)searchBarBeginSearch:(UISearchBar *)searchBar{
    // 收起键盘
    [self.searchBar resignFirstResponder];
    
    
    // 移除tag
    [self.historyArray removeObject:searchBar.text];
    
    // 重新添加
    [self.historyArray insertObject:searchBar.text atIndex:0];
    
    // 刷新列表
    if (self.HistorySearchType == DPHistorySearchStypeTypeCell) {
        [self.searchTableView reloadData];
    }
    else{
        self.HistorySearchType = self.HistorySearchType;
        
    }
    
    // 存档
    [NSKeyedArchiver archiveRootObject:self.historyArray toFile:self.searchStoryPath];
    
    // 弹出搜索结果页
    switch (self.SearchResultMode) {
        case DPSearchResultShowModePush:
            [self.navigationController pushViewController:self.searchResultTableViewController animated:YES];
            break;
            case DPSearchResultShowModeEmbed:
            [self.view addSubview:self.searchResultTableView];
            [self addChildViewController:self.searchResultTableViewController];
            
        default:
            break;
    }
    
    // 代理方法回调
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchBar:searchText:)]) {
        [self.delegate searchViewController:self didSelectSearchBar:self.searchBar searchText:searchBar.text];
        return;
    }
    if (self.searchBlock) {
        self.searchBlock(self , self.searchBar , searchBar.text);
    }
}
#pragma mark - tableView代理方法 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    cell.textLabel.text = self.historyArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.searchTableView.tableFooterView.hidden = !self.historyArray.count;
    return self.HistorySearchType == DPHistorySearchStypeTypeCell ? self.historyArray.count : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return self.historyArray.count && self.HistorySearchType == DPHistorySearchStypeTypeCell ? DPHistorySearchText : nil;
}
@end
