//
//  Build.swift
//  LoveExpress
//
//  Created by chenxi on 2017/10/30.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit

struct Build {
    
    let latitude: CLLocationDegrees
    
    let longitude: CLLocationDegrees
    
    let title: String
    
    let image: String
}

extension Build {
    
    static func builds() -> [Build] {

        return [
            Build(latitude: 31.2162650000, longitude: 121.6350630000, title: "展想广场", image: "build"),
            Build(latitude: 31.2140760000, longitude: 121.6345960000, title: "895创业基地", image: "icon"),
            Build(latitude: 31.2125130000, longitude: 121.6356560000, title: "天主教集贤桥堂", image: "launcher_pic"),
            Build(latitude: 31.2134860000, longitude: 121.6347490000, title: "欢乐互娱", image: "love_icon"),
            Build(latitude: 31.2451210000, longitude: 121.5145100000, title: "东方明珠", image: "love_find"),
        ]
        
    }
    
}
