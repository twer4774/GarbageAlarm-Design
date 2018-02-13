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
    
    
    //ActionSheetMap
    var innerView: UIView!
    var mapView: NMapView?
    var changeStateButton: UIButton?
    var myLongitude: Double = 0.0
    var myLatitude: Double = 0.0
    
    var minLongitude: Double = 0.0
    var maxLongitude: Double = 0.0
    var minLatitude: Double = 0.0
    var maxLatitude: Double = 0.0
    
    let cleanHM = CleanHouseModel()
    
    var address = ""
    var dong = ""
    var location = ""
    var mapx = ""
    var mapy = ""
    
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    var currentState: state = .disabled
 
    
    @IBOutlet var calloutView: UIView!
    @IBOutlet weak var calloutLabel: UILabel!
    
    
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
        
        floatingButtonSetup()

        //현재 위치 표시
        if let lm = NMapLocationManager.getSharedInstance() {
            // set delegate
            lm.setDelegate(self)
            
            // start updating location
            lm.startContinuousLocationInfo()
            
            mapView?.setAutoRotateEnabled(true, animate: true)
            
            // start updating heading
            //            lm.startUpdatingHeading()
            
            //내 위치 중심으로 클린하우스 표시
            myLatitude = (lm.locationManager.location?.coordinate.latitude)!
            myLongitude = (lm.locationManager.location?.coordinate.longitude)!
            print(myLatitude)
            
            minLongitude = myLongitude - 0.002
            maxLongitude = myLongitude + 0.002
            
            minLatitude = myLatitude - 0.002
            maxLatitude = myLatitude + 0.002
            
            
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView?.viewDidAppear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        stopLocationUpdating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.viewDidDisappear()
        
    }
    
    func floatingButtonSetup(){
        //FloatingButton설정
        floatingButton.addItem(title: "알람", image: #imageLiteral(resourceName: "alarm-clock white")){
            item in
            Helper.showAlert(for: item)
        }
        floatingButton.addItem(title: "지도", image: #imageLiteral(resourceName: "map")) {
            (_) in
            self.setMap()
        }
        
        floatingButton.display(inViewController: self)
    }
    
    
    func setMap(){
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: 350 - margin*3, height: 350)
      
        innerView = UIView(frame: rect)
        mapView = NMapView(frame: rect)
        

        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("YourNaverClientID")
      
            alertController.view.addSubview(innerView)
            innerView.addSubview(mapView)

            mapView.setMapEnlarged(false, mapHD: true) //지도를 정밀하게 보여줌
        }
        
        // Add Controls.
        changeStateButton = createButton()
        currentState = .disabled
        
        if let button = changeStateButton {
            alertController.view.addSubview(button)
        }
        
        
        
        //공공데이터 불러오기
        getAPI()
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: {(alert: UIAlertAction!) in
            self.stopLocationUpdating()
            print("cancel")})
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
        
        
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCardCollectionViewCellIdentifier", for: indexPath) as! DayCardCollectionViewCell
        
        cell.imageView.image = UIImage(named: "\(row.image!)")
        cell.lbDay.text = row.day
        cell.lbComment.text = row.comment
        
        if ud.string(forKey: "memo\(indexPath.row)") != nil{
            cell.memo.text = ud.string(forKey: "memo\(indexPath.row)")
        } else if ud.string(forKey: "memo\(indexPath.row)") == nil {
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
            collectionView.scrollToItem(at: IndexPath(item: dataController.calDay(), section: 1), at: .centeredHorizontally, animated: true)
            
            flag = true
        }
        if(dataController.getDay() == row.day){
            cell.innerView.FirstColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            cell.innerView.SecondColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            
            self.lbBigViewImage.image = UIImage(named: "\(row.image!)")
            self.lbBigViewDay.text = "\"\(row.day!)\""
            self.lbBigViewComment.text = row.comment
            
            if ud.string(forKey: "memo\(indexPath.row)") == nil{
                self.lbBigViewMemo.text = "메모가 없습니다."
            } else {
                  self.lbBigViewMemo.text = "\(ud.string(forKey: "memo\(indexPath.row)")!)"
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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

//Naver지도를 액션시트에 띄움
extension MainViewController: NMapPOIdataOverlayDelegate, NMapViewDelegate, NMapLocationManagerDelegate, XMLParserDelegate{
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
        
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return NMapViewResources.anchorPoint(withType: poiFlagType)
        
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        
        return CGPoint(x: 0, y: 0)
        
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        
        return nil
        
    }
    
    //calloutView를 이용해 위치정보 표시
    func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, viewForCalloutOverlayItem poiItem: NMapPOIitem!, calloutPosition: UnsafeMutablePointer<CGPoint>!) -> UIView! {
        calloutLabel.text = poiItem.title
        
        calloutPosition.pointee.x = round(calloutView.bounds.size.width / 2) + 1
        return calloutView
    }
    
    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        mapView.setMapEnlarged(true, mapHD: true)
        mapView.mapViewMode = .vector
        mapView.setMapCenter(NGeoPoint(longitude: myLongitude,latitude: myLatitude), atLevel: 11)
    }
    
    // MARK: - NMapLocationManagerDelegate Methods
    
    
    //현재 내 위치 표시
    open func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        
        myLatitude = myLocation.latitude
        myLongitude = myLocation.longitude
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
//        mapView?.setMapCenter(myLocation)
        print("dddddddd")
    }
    
    open func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"NMapViewer", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
    func locationManager(_ locationManager: NMapLocationManager!, didUpdate heading: CLHeading!) {
        let headingValue = heading.trueHeading < 0.0 ? heading.magneticHeading : heading.trueHeading
        setCompassHeadingValue(headingValue)
    }
    
    func onMapViewIsGPSTracking(_ mapView: NMapView!) -> Bool {
        return NMapLocationManager.getSharedInstance().isTrackingEnabled()
    }
    
    func findCurrentLocation() {
        enableLocationUpdate()
    }
    
    func setCompassHeadingValue(_ headingValue: Double) {
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setRotateAngle(Float(headingValue), animate: true)
        }
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    // MARK: - My Location
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
            
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    // MARK: - Button Control
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 30, y: 50, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
                print("Disabled")
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                print("tracking")
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                print("trackingHEading")
                stopLocationUpdating()
                updateState(.disabled)
                
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
    
    func getAPI(){
        var parser = XMLParser()
        let url = "http://openapi.jejusi.go.kr/rest/cleanhouseinfoservice/getCleanHouseInfoList?serviceKey=YourAPIKEY&pageNo=1&startPage=1&numOfRows=1877&pageSize=1877"
        
        let urlToSend: URL = URL(string: url)!
        
        //parse the xml
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        
        //가장 먼저 실행되어 delegate에 속한 4개의 parser함수를 실행함
        let success: Bool = parser.parse()
        
        if success {
            print("parse success!")
            //  print(strXMLData)
            
        } else {
            print("parse failure!")
        }
    }
    //parser가 시작태그를 만나면 호출
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        cleanHM.currentElement = elementName
        
        if elementName == "list" {
            address = ""
            dong = ""
            location = ""
            mapx = ""
            mapy = ""
        }
    }
    
    //parser가 닫는 태그를 만나면 호출
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        cleanHM.currentElement = ""
        
        if elementName == "list" {
            cleanHM.address = address
            cleanHM.dong = dong
            cleanHM.location = location
            cleanHM.mapx = mapx
            cleanHM.mapy = mapy
            
            if let mapOverlayManager = mapView?.mapOverlayManager {
                
                // create POI data overlay
                if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                    
                    poiDataOverlay.initPOIdata(1877)
                    
                    if let long: Double = Double("\(cleanHM.mapy)"), let lati: Double = Double("\(cleanHM.mapx)") {
                        if(long >= minLongitude && long <= maxLongitude && lati >= minLatitude && lati <= maxLatitude){
                            poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: long, latitude:  lati), title: "\(cleanHM.location)", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)
                        }
                    }
                    
                    poiDataOverlay.endPOIdata()
                    
                    // show all POI data
                    poiDataOverlay.showAllPOIdata()
                    poiDataOverlay.selectPOIitem(at: 2, moveToCenter: false, focusedBySelectItem: true)
                }
            }
        }
    }
    
    //현재 태그에 담겨 있는 string 전달
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //        if(passName){
        //            strXMLData = strXMLData + "\n\n"+string
        //        }
        let eName = cleanHM.currentElement
        
        if eName == "address"{
            address = address + string
        } else if eName == "dong" {
            dong = dong + string
        } else if eName == "location" {
            location = location + string
        } else if eName == "mapx"{
            mapx = mapx + string
        } else if eName == "mapy"{
            mapy = mapy + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
