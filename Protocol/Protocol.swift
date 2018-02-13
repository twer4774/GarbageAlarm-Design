//
//  Protocol.swift
//  GarbageAlarm-Design
//
//  Created by WonIk on 2018. 1. 28..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import Foundation
import UIKit

//DayModelProtocol정의
protocol DayMoelProtocol{
    var day: String? {get set}
    var comment: String? {get set}
    var image: String? {get set}
}
//Json불러오기
protocol JsonParserProtocol{
    var list: [DayModel] {get set}
}

extension JsonParserProtocol{
    mutating func getJSON(){
        //파일 경로불러오기
        let jsonFilePath = Bundle.main.url(forResource: "sample", withExtension: "json")
        //파일 경로를 Data객체에 넣기 - Data는 읽어들인 값들을 저장하는 역할.
        let jsonData = try! Data(contentsOf: jsonFilePath!)
        
        do {
            // JSON객체를 Data형태에서 NSDictionary형태로 타입 캐스팅(json구조에 맞추기)
            let jsonDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            
            //jsonDictionary에서 data에 속한 값들을 불러오기 위함
            let jsonObj = jsonDictionary["data"] as! NSArray
            
            for listIndex in jsonObj{
                let obj = listIndex as! NSDictionary
                
                
                let day = obj["day"]
                let comment = obj["comment"]
                let image = obj["img"]
                
                let dayModel = DayModel(day: day as! String?, comment: comment as! String?, image: image as! String?)
                list.append(dayModel)
                
            }
        }
    }
}

protocol CleanHouseAPIProtocol{
    var currentElement: String {get set}
    var passData: Bool {get set}
    
    var parseAddress: Bool {get set}
    var parseDong: Bool {get set}
    var parseLocation: Bool {get set}
    var parseMapx: Bool {get set}
    var parseMapy: Bool {get set}
    
    var address: String {get set}
    var dong: String {get set}
    var location: String {get set}
    //    var mapx: Double {get set}
    //    var mapy: Double {get set}
    
    var mapx: String {get set}
    var mapy: String {get set}
}

protocol CleanHouseAPIParser{
    
}

