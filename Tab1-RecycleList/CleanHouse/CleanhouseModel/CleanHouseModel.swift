//
//  CleanHouse.swift
//  GarbageAlarm
//
//  Created by WonIk on 2018. 1. 3..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import Foundation

class CleanHouseModel: CleanHouseAPIProtocol{
    var currentElement: String = ""
    var passData: Bool = false
    var parseAddress: Bool = false
    var parseDong: Bool = false
    var parseLocation: Bool = false
    var parseMapx: Bool = false
    var parseMapy: Bool = false
    
    var address: String = ""
    var dong: String = ""
    var location: String = ""
//    var mapx: Double = 0.0
//    var mapy: Double = 0.0
    var mapx: String = ""
    var mapy: String = ""
 
    
    var list = [CleanHouseModel]()
    init(){
        
    }
    
    init (address: String, dong: String, location: String, mapx: String, mapy: String){
        self.address = address
        self.dong = dong
        self.location = location
        self.mapx = mapx
        self.mapy = mapy

    }
}
