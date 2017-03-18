//
//  DPSearchViewController.h
//  historySearch
//
//  Created by Mister_Sun on 16/12/15.
//  Copyright © 2016年 SurSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@class DPSearchViewController;
@protocol DPSearchViewControllerDelegate;

/**  开始搜索时调用的block  */
typedef void(^SearchBlock)(DPSearchViewController *searchController , UISearchBar *searchBar , NSString *searchText);

/**  热门搜索种类  */
typedef NS_ENUM(NSInteger , DPHotSeatchStypeType) {\
    DPHotSeatchStypeTypeTag = 0 ,           // 普通样式为标签样式
    DPHotSeatchStypeTypeColorTag ,          //带有颜色的标签样式，颜色为随机颜色
    DPHotSeatchStypeTypeBorderTag ,         // 带有边框的标签样式，背景颜色为clearColor
    DPHotSeatchStypeTypeRoundedTag ,        // 带有圆角的标签样式 ， 背景颜色为clearColor
    DPHotSeatchStypeTypeRankingTag ,        // 排名样式
    DPHotSeatchStypeTypeMatrixTag ,          // 矩阵样式
    DPHotSeatchStypeTypeDefault = DPHotSeatchStypeTypeTag // 默认为普通标签样式

};

/**  历史搜索种类  */
typedef NS_ENUM(NSInteger , DPHistorySearchStypeType) {
    DPHistorySearchStypeTypeCell = 0,           // cell类型
    DPHistorySearchStypeTypeTag,                // 标签风格
    DPHistorySearchStypeTypeColorTag ,           // 带有颜色的标签风格(没有边框，颜色为随机颜色,可自定义指定颜色)
    DPHistorySearchStypeTypeBorderTag ,          // 带有边框的标签样式，背景色为clearColor
    DPHistorySearchStypeTypeRoundedTag ,         // 带有圆角的标签样式，背景颜色为clearcolor
    DPHistorySearchStypeTypeDefault = DPHistorySearchStypeTypeCell     // 默认样式为cell样式，如果用户不设置的话就为默认样式
    
};

/**  搜索结果显示样式  */
typedef NS_ENUM(NSInteger , DPSearchResultShowMode) {
    DPSearchResultShowModeCustom ,              // 自定义样式
    DPSearchResultShowModePush ,                // 通过push的形式显示
    DPSearchResultShowModeEmbed ,              // 通过内嵌的形式显示
    DPSearchResultShowModeDefault = DPSearchResultShowModeCustom , // 默认为自定义的样式

};
@interface DPSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
/**  热门搜索样式  */
@property(nonatomic,assign)DPHotSeatchStypeType HotSearchType;

/**  历史搜索样式  */
@property(nonatomic,assign)DPHistorySearchStypeType HistorySearchType;

/**  搜索结果展示样式  */
@property(nonatomic,assign)DPSearchResultShowMode SearchResultMode;

/**  是否显示搜索建议  */
@property(nonatomic,assign)BOOL searchSuggestionHidden;

/**  历史搜索保存的路径  */
@property(nonatomic,copy)NSString *searchStoryPath;

/**  搜索页tableView  */
@property(nonatomic,strong)UITableView *searchTableView;

/**  搜索页tableView  */
@property(nonatomic,assign)CGFloat keyboardHeight;

/**  搜索页tableView  */
@property(nonatomic,assign)BOOL keyboardShowing;

/**  搜索页tableView  */
@property(nonatomic,weak)UISearchBar *searchBar;

/**  热门搜索标题Label  */
@property(nonatomic,weak)UILabel *hotTitlelabel;

/**  热门搜索总  */
@property(nonatomic,weak)UIView *hotSearchView;

/**  所有热门标签汇总View  */
@property(nonatomic,weak)UIView *allTagsView;

/**  热门搜索搜索数组(存放每一个Label的名字)  */
@property(nonatomic,strong)NSMutableArray <NSString *> *hotSearchArray;

/**  热门搜索搜索数组（存放Label）  */
@property(nonatomic,strong)NSMutableArray <UILabel *> *hotSearchLabelArray;

/**  搜索历史数组  */
@property(nonatomic,strong)NSMutableArray <NSString *> *historyArray;

/**  排名布局对应的颜色  */
@property(nonatomic,strong)NSMutableArray <NSString *> *rankColorArray;

/**  搜索历史数组  */
@property(nonatomic,strong)NSMutableArray  *rankViewArr;

/**  搜索历史数组  */
@property(nonatomic,strong)NSMutableArray *rankTagArr;

/**  搜索历史数组  */
@property(nonatomic,strong)NSMutableArray *rankTextArr;

/**  搜索block  */
@property(nonatomic,copy)SearchBlock searchBlock;

/**  搜索结果列表  */
@property(nonatomic,weak)UITableView *searchResultTableView;

/**  搜索结果列表  */
@property(nonatomic,strong)UITableViewController *searchResultTableViewController;

/**  搜索block  */
@property(nonatomic,weak)id <DPSearchViewControllerDelegate> delegate;

/**************************************************/

/**  初始化  */
+ (DPSearchViewController *)historySearchWithSeatchTextArray:(NSMutableArray *)searchArray andSearchBarPlaceholderText:(NSString *)placehoderText andSearchBlock:(SearchBlock)historySearchBlock;

+ (DPSearchViewController *)historySearchWithSeatchTextArray:(NSMutableArray *)searchArray andSearchBarPlaceholderText:(NSString *)placehoderText;

@end

@protocol DPSearchViewControllerDelegate <NSObject>

/**  点击开始搜索  */
- (void)searchViewController:(DPSearchViewController *)searchViewController didSelectSearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText;

/**  点击热门搜索某一个标签的时候调用的方法  */
- (void)searchViewController:(DPSearchViewController *)searchViewController didSelectHotTagAtIndex:(NSInteger )index searchText:(NSString *)searchText;


@end




