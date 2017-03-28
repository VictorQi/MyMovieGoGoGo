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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MainViewModel *viewModel;

@end

@implementation ViewController

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) { return nil; }
    
    self.viewModel = [MainViewModel new];
    
    return self;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;

    [self bindViewModel];
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
    
    [[self
      rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)
      fromProtocol:@protocol(UITableViewDelegate)]
     subscribeNext:^(RACTuple * arguments __unused) {
         @strongify(self);
         [self performSegueWithIdentifier:kSegueIdentifier sender:self];
     }];
    self.tableView.delegate = self;
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
    NSURL *posterUrl = nil;
    if (self.viewModel.movieResults[indexPath.row].posterPath) {
        posterUrl = [NSURL URLWithString:[self.viewModel.posterBaseUrl stringByAppendingString:self.viewModel.movieResults[indexPath.row].posterPath]];
    }
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    [cell.imageView sd_setImageWithURL:posterUrl placeholderImage:[UIImage imageNamed:@"poster_placeholder"]];
    
    return cell;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueIdentifier]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        MovieModel *viewModel = self.viewModel.movieResults[indexPath.row];
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
