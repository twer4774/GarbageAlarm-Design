//
//  DayCardCollectionViewCell.swift
//  GarbageAlarm-Design
//
//  Created by WonIk on 2018. 2. 1..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit

class DayCardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var innerView: GradientView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    
    @IBOutlet weak var memo: UILabel!
    
    
    //초기화
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //셀이 재사용 되므로 색이 바뀌는 현상이 있음. 재사용되는 셀의 색을 지정하여 해결
    override func prepareForReuse() {
//        self.innerView.FirstColor = UIColor(red: 52.0/255.0, green: 120.0/255.0, blue: 246.0/255.0, alpha: 1.0)

//        self.innerView.SecondColor = UIColor(red: 115.0/255.0, green: 246.0/255.0, blue: 156.0/255.0, alpha: 1.0)

        self.innerView.FirstColor = UIColor.green
        self.innerView.SecondColor = UIColor.clear
    }
}
