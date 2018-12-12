//
//  ViewController.m
//  AppearanceLister
//
//  Created by Florian Lücke on 28.10.18.
//  Copyright © 2018 Florian Lücke. All rights reserved.
//

#import "ViewController.h"

#import "NSCompositeAppearance.h"
#import <objc/runtime.h>

@implementation ViewController
{
    NSBundle *_appearanceBundle;
    NSArray<NSAppearance *> *_apperances;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    NSURL *url = [NSURL URLWithString: @"file:///System/Library/CoreServices/SystemAppearance.bundle"];
    _appearanceBundle = [NSBundle bundleWithURL: url];

    NSMutableArray *appearances = [NSMutableArray new];
    NSURL *resourceURL = [url URLByAppendingPathComponent: @"Contents/Resources"];

    NSEnumerator *appearancesEnumerator = [NSFileManager.defaultManager enumeratorAtURL:resourceURL includingPropertiesForKeys:nil options:0 errorHandler:nil];

    for (NSURL *url in appearancesEnumerator) {
        if ([url.absoluteString containsString: @"car"]) {
            NSString *appearanceName = [url URLByDeletingPathExtension].lastPathComponent;
            NSAppearance *appearance = [[NSAppearance alloc] initWithAppearanceNamed:appearanceName bundle:_appearanceBundle];

            [appearances addObject: appearance];
        }
    }

    _apperances = [appearances sortedArrayUsingComparator:^NSComparisonResult(NSAppearance *obj1, NSAppearance *obj2) {
        return [obj1.name compare: obj2.name];
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _apperances.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:@"nameView" owner:nil];
    view.textField.stringValue = _apperances[row].name;

    return view;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return _apperances[row].name;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;

    NSMutableArray *selectedAppearances = [NSMutableArray new];
    [tableView.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedAppearances addObject: self->_apperances[idx]];
    }];

    NSCompositeAppearance *compositeAppearance = [NSClassFromString(@"NSCompositeAppearance") new];
    compositeAppearance.appearances = [selectedAppearances sortedArrayUsingComparator:^NSComparisonResult(NSAppearance *obj1, NSAppearance *obj2) {
        NSInteger result = obj2.name.length - obj1.name.length;

        if (result < -1)
            result = -1;

        if (result > 1)
            result = 1;

        return result;
    }];
    self.view.window.appearance = compositeAppearance;
}

@end
