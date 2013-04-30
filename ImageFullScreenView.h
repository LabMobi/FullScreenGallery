//
//  ImageFullScreenView.h
//  Munchrs
//
//  Created by Mikk Pavelson on 4/25/13.
//  Copyright (c) 2013 Mobi Solutions O√ú. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>

@class PFQuery;

@interface ImageFullScreenView : UIView <UIScrollViewDelegate>
{
  UIScrollView *scrollView_;
  UIImage *selectedImage_;
  UIImageView *imageView_;
  CGRect initialImageViewFrame_;
  NSInteger selectedImageIndex_;
  NSArray *objectArray_;
  NSMutableDictionary *imageDictionary_;
  NSString *objectImageURLKey_;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) CGRect initialImageViewFrame;
@property (nonatomic, assign) NSInteger selectedImageIndex;
@property (nonatomic, strong) NSArray *objectArray;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;
@property (nonatomic, strong) NSString *objectImageURLKey;

- (id)initWithImage:(UIImage *)image selectionIndex:(NSInteger)index;
- (void)showOnView:(UIView *)baseView withOriginalImageViewFrame:(CGRect)originalFrame;
- (IBAction)dismissImageFullScreen;

@end
