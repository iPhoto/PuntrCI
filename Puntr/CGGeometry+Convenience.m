//
//  CGGeometry+Convenience.m
//  Puntr
//
//  Created by Eugene Tulushev on 14.08.13.
//  Copyright (c) 2013 2Nova Interactive. All rights reserved.
//

#import "CGGeometry+Convenience.h"

CGRect CGRectResize(CGRect rect, CGFloat dx, CGFloat dy)
{
    return CGRectOffset(CGRectInset(rect, dx, dy), -dx, -dy);
}

CGRect CGRectSetX(CGRect rect, CGFloat x)
{
    return CGRectMake(x, CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}

CGRect CGRectSetY(CGRect rect, CGFloat y)
{
    return CGRectMake(CGRectGetMinX(rect), y, CGRectGetWidth(rect), CGRectGetHeight(rect));
}

CGRect CGRectSetWidth(CGRect rect, CGFloat width)
{
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), width, CGRectGetHeight(rect));
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height)
{
    return CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), height);
}