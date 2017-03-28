//
//  ViewController.m
//  MyMoviesGoGoGo
//
//  Created by v.q on 2017/3/22.
//  Copyright © 2017年 Victor Qi. All rights reserved.
//

#import "ViewController.h"
#import "MovieDetailViewController.h"
#import "MainViewModel.h"
#import "MovieResultsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *const kCellIdentifier = @"CELL";
static NSString *const kSegueIdentifier = @"showMovieDetail";
static NSString *const kImageCacheName = @"ImageCache";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MainViewModel *viewModel;
@property (nonatomic, strong) NSCache<NSString*, UIImage*> *imageCache;

@end

@implementation ViewController

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    
    self.viewModel = [MainViewModel new];
    self.imageCache = [[NSCache alloc] init];
    self.imageCache.name = kImageCacheName;
    
    return self;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.imageCache removeAllObjects];
}

#pragma mark - View Model Binding
- (void)bindViewModel {
    RAC(self.viewModel, searchText) = self.textField.rac_textSignal;
    
    @weakify(self);
    [[[RACObserve(self.viewModel, movieResults)
       ignore:nil]
      deliverOnMainThread]
     subscribeNext:^(NSArray<MovieModel *> * _Nullable movieResult) {
         @strongify(self);
         [self.tableView reloadData];
     } error:^(NSError * _Nullable error) {
         @strongify(self);
         [self showAlertWithTitle:@"Error" message:error.localizedDescription];
     }];
    
    RACSignal<MovieModel *> *tableViewSignal =
    [[self
      rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)
      fromProtocol:@protocol(UITableViewDelegate)]
     map:^MovieModel * _Nullable(RACTuple * _Nullable arguments) {
         @strongify(self);
         NSIndexPath *indexPath = (NSIndexPath *)arguments.second;
         return self.viewModel.movieResults[indexPath.row];
     }];
    self.tableView.delegate = self;
    
    [self
     rac_liftSelector:@selector(performSegueWithIdentifier:sender:)
     withSignalsFromArray:@[[RACSignal return:kSegueIdentifier], tableViewSignal]];
}

#pragma mark - Alert
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.movieResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    cell.textLabel.text = self.viewModel.movieResults[indexPath.row].originalTitle;
    
    /*
     * 下面这个RAC图片下载的方法，不断刷新时会引起图片丢失，
     * 解决的方法应该是自己创建一个cache
     */
    @weakify(self, tableView);
    [[[[RACObserve(self.viewModel, posterBaseUrl)
        subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]]
       map:^UIImage * _Nullable(NSString * _Nullable baseUrl) {
           @strongify(self);
           NSString *poster = self.viewModel.movieResults[indexPath.row].posterPath;
           if (poster != nil) {
               NSString *posterUrl = [baseUrl stringByAppendingString:poster];
               UIImage *cachedImage = [self.imageCache objectForKey:posterUrl];
               if (cachedImage != nil) {
                   return cachedImage;
               } else {
                   NSData *posterData = [NSData dataWithContentsOfURL:[NSURL URLWithString:posterUrl]];
                   UIImage *image = [UIImage imageWithData:posterData];
                   [self.imageCache setObject:image forKey:posterUrl];
                   return image;
               }
           }
           return [UIImage imageNamed:@"poster_placeholder"];
       }]
      deliverOnMainThread]
     subscribeNext:^(UIImage * _Nullable image) {
         @strongify(tableView);
         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         cell.imageView.image = image;
         [cell setNeedsLayout];
     }];
    //    NSURL *posterUrl = nil;
    //    if (self.viewModel.movieResults[indexPath.row].posterPath) {
    //        posterUrl = [NSURL URLWithString:[self.viewModel.posterBaseUrl stringByAppendingString:self.viewModel.movieResults[indexPath.row].posterPath]];
    //    }
    //    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    //    [cell.imageView sd_setImageWithURL:posterUrl placeholderImage:[UIImage imageNamed:@"poster_placeholder"]];
    
    return cell;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueIdentifier]) {
        MovieModel *viewModel = (MovieModel *)sender;
        if ([viewModel.posterPath rangeOfString:self.viewModel.posterBaseUrl].location == NSNotFound && viewModel.posterPath) {
            viewModel.posterPath = [self.viewModel.posterBaseUrl stringByAppendingString:viewModel.posterPath];
        }
        MovieDetailViewController *detailVC = (MovieDetailViewController *)segue.destinationViewController;
        detailVC.viewModel = viewModel;
    }
}

- (IBAction)myUnwindAction:(UIStoryboardSegue *)sender {
    // 不知道要做什么，一脸懵逼
}

@end
