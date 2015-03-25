//
//  GCSpeakerModel.m
//  Deals4You
//
//  Created by Teja Swaroop on 14/01/15.
//  Copyright (c) 2015 SaiTeja. All rights reserved.
//

#import "GCModel.h"

@implementation GCModel

+(NSArray *)defaultTableContents
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"menuContents"
                                                     ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

//+(NSMutableArray *)filteredTableContents:(NSArray *)allContents
//{
//    NSMutableArray *filteredContents = [[NSMutableArray alloc] init];
//    for (int i=0; i < [allContents count]; i++)
//    {
//        BOOL isExpandable = [allContents count] > 0;
//        GCModel *model = [[GCModel alloc] init];
//        model.title = model.sessionDay;
//        model.isExpandable = isExpandable;
//        model.expanded = NO;
//        model.parent = nil;
//        [filteredContents addObject:model];
//    }
//    return filteredContents;
//}

+(NSArray *) addChildrenFromArray:(NSArray *)parentArray to:(NSMutableArray *)filteredArray atIndex:(NSInteger) parentIndex
{
    GCModel *currentCell = filteredArray[parentIndex];
    NSMutableArray *insertIndexes = [@[]mutableCopy];
    NSString *parentId  = parentArray[parentIndex] [@"title"];
    NSDictionary *parentObject = [[parentArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",@"title",parentId]] firstObject];
    [parentObject[@"children"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GCModel *child = [[GCModel alloc] init];
        child.title = obj[@"title"];
        child.isExpandable = NO;
        child.parent = parentId;
        if(parentIndex < filteredArray.count )
        {
            [filteredArray insertObject:child atIndex:parentIndex + idx+1];
            [insertIndexes addObject:[NSIndexPath indexPathForRow:parentIndex + idx +1 inSection:0]];
        }
        else
        {
            [filteredArray addObject:child];
            [insertIndexes addObject:[NSIndexPath indexPathForRow:parentIndex + idx +1 inSection:0]];
        }
        
    }];
    currentCell.expanded = YES;
    return insertIndexes;
}

+(NSArray *) removeChildrenUsingArray:(NSArray *)parentArray to:(NSMutableArray *)filteredArray atIndex:(NSInteger) parentIndex
{
    GCModel *currentCell = filteredArray[parentIndex];
    NSMutableArray *removeIndexPaths = [@[]mutableCopy];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    NSString *parentId  = parentArray[parentIndex] [@"title"];
    [filteredArray enumerateObjectsUsingBlock:^(GCModel *obj, NSUInteger idx, BOOL *stop) {
        if([obj.parent isEqualToString:parentId])
        {
            [removeIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            [indexSet addIndex:idx];
        }
    }];
    currentCell.expanded = NO;
    [filteredArray removeObjectsAtIndexes:indexSet];
    return removeIndexPaths;
}

@end
