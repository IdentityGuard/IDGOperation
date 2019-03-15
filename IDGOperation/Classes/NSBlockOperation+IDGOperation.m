//  NSBlockOperation+IDGOperation.m
//
// Copyright (c) 2019 Intersections, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.



#import "NSBlockOperation+IDGOperation.h"

NSString * const kIDGOperationErrorDomain = @"com.operation.error.domain";

@implementation NSBlockOperation (IDGOperation)

+ (instancetype)completionBlockForOperations:(NSArray *)operations completionBlock:(void (^)(NSArray <NSError *> *errors))completionBlock
{
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
    __weak typeof(blockOperation) weakBlockOperation = blockOperation;
    __block typeof(completionBlock) completionBlockRef = completionBlock;
    [blockOperation addExecutionBlock:^{
        NSMutableArray *errorArray = [NSMutableArray arrayWithCapacity:weakBlockOperation.dependencies.count];
        BOOL isCancceled = NO;
        for (NSOperation *op in weakBlockOperation.dependencies) {
            if (!op.isCancelled) continue;
            isCancceled = YES;
            if ([op isKindOfClass:[IDGOperation class]] && [(IDGOperation *)op error]) {
                [errorArray addObject:[(IDGOperation *)op error]];
            }
        }
        
        if (!errorArray.count && isCancceled) {
            NSString *desc = NSLocalizedString(@"Operation cancelled", @"Unknown Operation Error Message");
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: desc};
            NSError *genericError = [NSError errorWithDomain:kIDGOperationErrorDomain code:0 userInfo:userInfo];
            [errorArray addObject:genericError];
        }
        completionBlockRef([errorArray copy]);
        completionBlockRef = nil;
    }];
    
    for (NSOperation *op in operations) {
        [blockOperation addDependency:op];
    }
    return blockOperation;
}

@end
