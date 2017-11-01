//
//  SingletonCoordinate.swift
//  LoveExpress
//
//  Created by chenxi on 2017/10/31.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit

final class SingletonCoordinate: NSObject {
    
    static let shareInstance = SingletonCoordinate()
    
    static var userCoordinate: CLLocationCoordinate2D?
    
    static var mapView: BMKMapView?
    
    func getDistanceAttributedString(type: Int, buildCoord: CLLocationCoordinate2D) -> NSMutableAttributedString {
        //计算距离
        let userPoint = BMKMapPointForCoordinate(SingletonCoordinate.userCoordinate!)
        let buildPoint = BMKMapPointForCoordinate(buildCoord)
        let distance = BMKMetersBetweenMapPoints(userPoint, buildPoint)
        
        var ranStr: String!
        var buildStr: String!
        if type == 1 {
            ranStr = "\(lround(distance))"
            buildStr = "AR告白点距离 \(ranStr!) 米\n\n\n"
        } else {
            if distance > 1000 {
                ranStr = ">1000"
            } else {
                ranStr = "\(lround(distance))"
            }
            buildStr = "距离 \(ranStr!) 米"
        }
        
        let attrStr: NSMutableAttributedString = NSMutableAttributedString(string: buildStr)
        
        let str = NSString(string: buildStr)
        
        let theRange = str.range(of: ranStr)
        
        attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: theRange)
        
        attrStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: theRange)
        
        return attrStr
    }
}
