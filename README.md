FullScreenGallery
=================

<h4>An objective-C class for viewing images in full screen with zooming and scrolling. Depends on the Parse framework.</h4>
<br>
<br>
Setup:<br>
<ol>
<li>Add and import the class files.</li>
<li>Initialize the class with the original UIImage and the index of the image in the array of images it's contained in.
   <ul><li>The image is used for the transition to full screen mode.</li>
   <li>The index of the image is used to open the correct image.</li></ul>
<li>Set the <b>objectArray</b> property for the ImageFullScreenView instance. This is an array of PFObjects downloaded from the
   Parse framework.</li>
<li>Set the <b>objectImageURLKey</b> property for the the ImageFullScreenView instance. This is a NSString property used to fetch
   the URL string for image associated with the PFObject.</li>
<li>Call <i>- (void)showOnView:(UIView *)baseView withOriginalImageViewFrame:(CGRect)originalFrame</i>
   <ul><li><i>baseView</i> is the view on top of which the full screen image gallery is situated.</li>
   <li><i>originalFrame</i> is the The original UIImageView's frame that is used to animate the transition to full screen mode.</li></ul>
   </ol>
