//  IDGOperation.h
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



#import <Foundation/Foundation.h>

@interface IDGOperation : NSOperation

/**
 Indicateds whether the operation is failed.
 */
@property (nonatomic, strong) NSError *error;

/**
 Display text for activity indicator. Subclasses must override this method. Default implemntation asserts.
 */
@property (nonatomic, readonly) NSString *displayText;

/**
 Number of seconds the operation needs to wait before it gets ready.
 @warning Delay timer will start after all dependencies are cleared.
 */
@property (nonatomic, assign) NSTimeInterval delay;


// Override to get cancel/failed logic.
- (void)run;

@end
