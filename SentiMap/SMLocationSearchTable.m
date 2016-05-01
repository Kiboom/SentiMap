//
//  SMLocationSearchTable.m
//  SentiMap
//
//  Created by 김기범 on 2016. 5. 1..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "SMLocationSearchTable.h"

@interface SMLocationSearchTable ()

@end

@implementation SMLocationSearchTable

- (void)viewDidLoad {
    [super viewDidLoad];
    _notiCenter = [NSNotificationCenter defaultCenter];
}


/* search address */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchBarText = searchController.searchBar.text;
    if (_map == nil || searchBarText == nil) {
        return;
    }
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBarText;
    request.region = _map.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(response == nil) {
            return;
        }
        _matchingItems = response.mapItems;
        [self.tableView reloadData];
    }];
}

- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" " : @"";

    // put a comma between street and city/state
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @" ";

    // put a space between "Washington" and "DC"
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @" ";
    
    NSString *streetNumber = (selectedItem.subThoroughfare)?selectedItem.subThoroughfare:@"";
    NSString *streetName = (selectedItem.thoroughfare)?selectedItem.thoroughfare:@"";
    NSString *city = (selectedItem.locality)?selectedItem.locality:@"";
    NSString *state = (selectedItem.administrativeArea)?selectedItem.administrativeArea:@"";
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             streetNumber,
                             firstSpace,
                             streetName,
                             comma,
                             city,
                             secondSpace,
                             state];
    return addressLine;
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MKPlacemark *selectedItem = _matchingItems[indexPath.row].placemark;
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = [self parseAddress:selectedItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKPlacemark *selectedItem = _matchingItems[indexPath.row].placemark;
    [_delegate goToSearchedLocation:selectedItem];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_notiCenter postNotificationName:@"search complete" object:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
