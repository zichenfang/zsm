//
//  UIImage+MyCustomImage.m
//  Unity-iPhone
//
//  Created by zichenfang on 15/11/27.
//
//

#import "UIImage+MyCustomImage.h"

@implementation UIImage (MyCustomImage)


-(UIImage*)sizeImage :(CGSize)size
{
    //要截取的宽高比例
    float subScale = size.width/size.height;
    float imageSizeScale = self.size.width/self.size.height;
    
    CGSize subSize;
    if (subScale<=imageSizeScale) {
        subSize.height = self.size.height;
        subSize.width = self.size.height*subScale;
    }
    else
    {
        subSize.width = self.size.width;
        subSize.height = self.size.width/subScale;
    }
    
    
    CGRect subRect = CGRectMake((self.size.width-subSize.width)*0.5, (self.size.height-subSize.height)*0.5, subSize.width, subSize.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, subRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return subImage;
}
+ (UIImage *)imageWithColor :(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
