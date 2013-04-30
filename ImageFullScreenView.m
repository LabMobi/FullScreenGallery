//
//  ImageFullScreenView.m
//  Munchrs
//
//  Created by Mikk Pavelson on 4/25/13.
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
//

#import "ImageFullScreenView.h"
#import "UIView + Extensions.h"
#import <AFNetworking/AFNetworking.h>
#import <Parse/Parse.h>

@interface ImageFullScreenView ()

- (void)getImagesAndSetSelectedImageToFrame:(CGRect)frame;
- (UIImageView *)imageViewForIndex:(NSInteger)index withObject:(PFObject *)object;
- (void)layoutScrollImages;

@end

@implementation ImageFullScreenView

@synthesize scrollView = scrollView_;
@synthesize selectedImage = selectedImage_;
@synthesize imageView = imageView_;
@synthesize initialImageViewFrame = initialImageViewFrame_;
@synthesize selectedImageIndex = selectedImageIndex_;
@synthesize objectArray = objectArray_;
@synthesize imageDictionary = imageDictionary_;
@synthesize objectImageURLKey = objectImageURLKey_;

- (id)initWithImage:(UIImage *)image selectionIndex:(NSInteger)index
{
  self = (ImageFullScreenView *)[ImageFullScreenView loadViewFromXib:@"ImageFullScreenView"];
  if (self)
  {
    [self setSelectedImageIndex:index];
    [self setSelectedImage:image];
    [imageView_ setImage:image];
    [self setImageDictionary:[NSMutableDictionary dictionary]];
  }
  
  return self;
}

- (void)showOnView:(UIView *)baseView withOriginalImageViewFrame:(CGRect)originalFrame
{
  [self setInitialImageViewFrame:originalFrame];
  [self setFrame:baseView.frame];
  [baseView addSubview:self];
  [self setBackgroundColor:[UIColor clearColor]];
  
  CGRect newFrame = imageView_.frame;
  newFrame.size.height = newFrame.size.width;
  newFrame.origin.y = (self.frame.size.height - newFrame.size.height) / 2;
  
  [imageView_ setFrame:originalFrame];
  [UIView animateWithDuration:0.2 animations:^{
    [imageView_ setFrame:newFrame];
    [self setBackgroundColor:[UIColor blackColor]];
  }];
  
  [self getImagesAndSetSelectedImageToFrame:newFrame];
}

- (void)getImagesAndSetSelectedImageToFrame:(CGRect)frame
{
  for (PFObject *object in objectArray_) {
    NSInteger index = [objectArray_ indexOfObject:object];
    UIImageView *imageView = [self imageViewForIndex:index withObject:object];
    
    if (selectedImageIndex_ == index)
    {
      [imageView setImage:selectedImage_];
      [imageView setFrame:frame];
      [self setImageView:imageView];
    }
  }
  
  [self layoutScrollImages];
}

- (UIImageView *)imageViewForIndex:(NSInteger)index withObject:(PFObject *)object
{
  UIScrollView *scrollInScroll = [[UIScrollView alloc] initWithFrame:self.frame];
  [scrollInScroll setContentSize:scrollView_.frame.size];
  [scrollInScroll setTag:index + 1];
  [scrollInScroll setDelegate:self];
  [scrollInScroll setContentMode:UIViewContentModeScaleAspectFit];
  [scrollInScroll setMaximumZoomScale:10.0];
  [scrollInScroll setMinimumZoomScale:1.0];
  [scrollInScroll setDirectionalLockEnabled:YES];
  [scrollInScroll setShowsHorizontalScrollIndicator:NO];
  [scrollInScroll setShowsVerticalScrollIndicator:NO];
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageFullScreen)];
  [scrollInScroll addGestureRecognizer:tapRecognizer];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
  [imageView setTag:index + 1];
  [imageView setContentMode:UIViewContentModeScaleAspectFit];
  
  [scrollInScroll addSubview:imageView];
  [scrollView_ addSubview:scrollInScroll];
  
  if (selectedImageIndex_ != index)
  {
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [imageView addSubview:activity];
    [activity setCenter:self.center];
    [activity startAnimating];
    
    __weak UIImageView *weakImageView = imageView;
    NSURL *imageURL = [NSURL URLWithString:[object objectForKey:objectImageURLKey_]];
    
    [imageView setImageWithURL:imageURL
              placeholderImage:nil
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                         [activity removeFromSuperview];
                         [imageDictionary_ setObject:weakImageView forKey:object.objectId];
                       }
                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                         MSLog(@"imageDownloadErrorWithURL: %@", imageURL);
                       }];

  }
  
  return imageView;
}

- (void)layoutScrollImages
{
	CGFloat currentXLocation = 0;
  NSInteger indexCount = 1;
  CGRect frameToSelect;
  
	for (UIView *view in scrollView_.subviews)
	{
		if ([view isKindOfClass:[UIScrollView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(currentXLocation, 0);
			view.frame = frame;
			
			currentXLocation += (scrollView_.frame.size.width);
      if (indexCount == selectedImageIndex_ + 1) {
        frameToSelect = frame;
      }
      
      indexCount++;
		}
	}
	
	[scrollView_ setContentSize:CGSizeMake((objectArray_.count * scrollView_.frame.size.width), scrollView_.bounds.size.height)];
  
  [scrollView_ scrollRectToVisible:frameToSelect animated:NO];
}


- (IBAction)dismissImageFullScreen
{
  [UIView animateWithDuration:0.2 animations:^{
    [imageView_ setFrame:initialImageViewFrame_];
    [self setBackgroundColor:[UIColor clearColor]];
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if (![scrollView isEqual:scrollView_]) {
    return;
  }
  
  CGFloat offset = scrollView.contentOffset.x;
  CGFloat selectedIndexFloat = offset / scrollView.frame.size.width;
  NSInteger selectedIndex = [[NSNumber numberWithFloat:selectedIndexFloat] integerValue];
  PFObject *object = [objectArray_ objectAtIndex:selectedIndex];
  UIImageView *selectedImageView = [imageDictionary_ objectForKey:object.objectId];
  [self setImageView:selectedImageView];
}

#pragma mark - Scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  UIView *returnView;
  
  if (![scrollView isEqual:scrollView_]) {
    for (UIView *view in scrollView.subviews) {
      if ([view isKindOfClass:[UIImageView class]] && view.tag == scrollView.tag)
      {
        returnView = view;
      }
    }
  }
  
  return returnView;
}

@end
