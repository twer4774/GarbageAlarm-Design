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
    
    @IBAction func memoClicked(_ sender: UIButton) {
        let reload = self.superview! as! UICollectionView
        var indexPathCell: IndexPath!
        indexPathCell = (self.superview! as! UICollectionView).indexPath(for: self)! as IndexPath
        
        
        
        
        _ = SweetAlert().showAlert("메모", subTitle: "메모하세요",style: AlertStyle.none, buttonTitle: "저장", buttonColor: UIColor.colorFromRGB(0xDD6B55), otherButtonTitle: "취소", theOtherButtonTitle: "삭제", index: indexPathCell)
        { (isOtherButton, isTheOtherButton) -> Void in
            
            if isOtherButton == true && isTheOtherButton == false {
                _ = SweetAlert().showAlert("취소!", subTitle: "취소되었습니다", style: AlertStyle.error)
            } else if isTheOtherButton == true && isOtherButton == false{
                _ = SweetAlert().showAlert("메모지우기!", subTitle:"메모가 지워졌습니다.", style: AlertStyle.warning)
                 reload.reloadData()
            } else if isOtherButton == false && isTheOtherButton == false{
                _ = SweetAlert().showAlert("저장!", subTitle: "저장되었습니다.!", style: AlertStyle.success)
                reload.reloadData()
            }
        }
        
    }
    
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
