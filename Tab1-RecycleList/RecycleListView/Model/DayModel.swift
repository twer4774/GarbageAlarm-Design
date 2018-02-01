//
//  DayModel.swift
//  GarbageAlarm-Design
//
//  Created by WonIk on 2018. 1. 29..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import Foundation

/*
struct DayModel: DayMoelProtocol{
    var day: String?
    var comment: String?
    var image: String?
}
*/

class DayModel: DayMoelProtocol, JsonParserProtocol{
    var day: String?
    var comment: String?
    var image: String?
    
    var list = [DayModel]()
    
    init(){
        
    }
    
    init(day: String?, comment: String?, image: String?){
        self.day = day
        self.comment = comment
        self.image = image
    }
 
}
