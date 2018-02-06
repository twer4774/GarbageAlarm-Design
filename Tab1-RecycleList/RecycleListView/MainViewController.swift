//
//  MainViewController.swift
//  GarbageAlarm-Design
//
//  Created by WonIk on 2018. 2. 1..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class MainViewController: UIViewController {
    
    //스크롤에 표시되는 현재 카드, 스크롤 시 애니메이션을 정한 설정
    fileprivate var currentPage: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    @IBOutlet weak var bigContentsView: GradientView!
    @IBOutlet weak var lbBigViewImage: UIImageView!
    @IBOutlet weak var lbBigViewDay: UILabel!
    @IBOutlet weak var lbBigViewComment: UILabel!
    @IBOutlet weak var lbBigViewMemo: UILabel!
    
    var cellIndex = ""
   
    fileprivate var cardSize: CGSize{
        let layout = collectionView.collectionViewLayout as! ScrollCardCollectionViewLayout
        var cardSize = layout.itemSize
        cardSize.width = cardSize.width + layout.minimumLineSpacing
        return cardSize
    }
    
    var flag = false //현재 요일 이동을 한번만 하기 위한 플래그
    
    //Sample.json파싱 후 데이터 매핑
    var dayModel = DayModel()
    let dataController = DataController()
    
    
    //FloatingButton
    @IBOutlet weak var floatingButton: JJFloatingActionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dayModel.getJSON()
        
        bigContentsView.FirstColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 146.0/255.0, alpha: 1.0)
        bigContentsView.SecondColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        collectionView.register(UINib(nibName: "DayCardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DayCardCollectionViewCellIdentifier")
        collectionView.clipsToBounds = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        //FloatingButton설정
        floatingButton.addItem(title: "알람", image: #imageLiteral(resourceName: "ic_alarm_white_24dp")) { item in
            Helper.showAlert(for: item)
        }
        
        floatingButton.addItem(title: "Like", image: #imageLiteral(resourceName: "Like")) { item in
            Helper.showAlert(for: item)
        }
        
        floatingButton.addItem(title: "Balloon", image: #imageLiteral(resourceName: "Baloon")) { item in
            Helper.showAlert(for: item)
        }
        
        floatingButton.defaultButtonImage = UIImage(named: "cans")
        
    
        floatingButton.display(inViewController: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let ud = UserDefaults.standard
        let row = dayModel.list[indexPath.row]
        let dayCardCollectionViewCell = DayCardCollectionViewCell()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCardCollectionViewCellIdentifier", for: indexPath) as! DayCardCollectionViewCell
        
        cell.imageView.image = UIImage(named: "\(row.image!)")
        cell.lbDay.text = row.day
        cell.lbComment.text = row.comment
        
        if ud.string(forKey: "memo\(indexPath)") != nil{
            cell.memo.text = ud.string(forKey: "memo\(indexPath)")
        } else if ud.string(forKey: "memo\(indexPath)") == nil {
            cell.memo.text = "메모가 없습니다."
        }
     
        
        cell.contentView.layer.cornerRadius = 15.0
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 10, height: 10)
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
        
        //콜렉션뷰 중앙으로 현재 날짜 카드뷰 보여주기
        if(flag == false){
            collectionView.scrollToItem(at: IndexPath(item: dataController.calDay()-1, section: 0), at: .centeredHorizontally, animated: true)
            
            flag = true
        }
        if(dataController.getDay() == row.day){
            cell.innerView.FirstColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.innerView.SecondColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            
            self.lbBigViewImage.image = UIImage(named: "\(row.image!)")
            self.lbBigViewDay.text = "\"\(row.day!)\""
            self.lbBigViewComment.text = row.comment
            
            if ud.string(forKey: "memo\(indexPath)") == nil{
                self.lbBigViewMemo.text = "메모가 없습니다."
            } else {
                  self.lbBigViewMemo.text = "\(ud.string(forKey: "memo\(indexPath)")!)"
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayModel.list.count
    }
}

extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cardSide = self.cardSize.width
        let offset = scrollView.contentOffset.x
        currentPage = Int(floor((offset - cardSide / 2) / cardSide) + 1)
    }
}
