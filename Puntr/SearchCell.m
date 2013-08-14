//
//  SearchCell.m
//  Puntr
//
//  Created by Eugene Tulushev on 08.07.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "SearchCell.h"

@interface SearchCell ()

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchCell

- (void)loadSearchWithQuery:(NSString *)query
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:self.frame];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage imageNamed:@"clear"];
    self.searchBar.userInteractionEnabled = NO;
    if (query)
    {
        self.searchBar.text = query;
    }
    else
    {
        self.searchBar.placeholder = @"Быстрый поиск...";
    }
    [self addSubview:_searchBar];
}

- (BOOL)resignFirstResponder
{
    return [super resignFirstResponder];
    [self.searchBar resignFirstResponder];
}

- (void)prepareForReuse
{
    
}

@end
