//
//  BMKMapViewController.swift
//  LoveExpress
//
//  Created by chenxi on 2017/10/19.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit
import PopupDialog

class BMKMapViewController: UIViewController, BMKLocationServiceDelegate, BMKMapViewDelegate, ENSideMenuProtocol, ENSideMenuDelegate {

    var locationService: BMKLocationService?
    
    //var mapView: BMKMapView?
    
    //var userCoordinate: CLLocationCoordinate2D?
    
    var userRegion: BMKCoordinateRegion?
    
    var sideMenu: ENSideMenu?
    
    var sideMenuAnimationType : ENSideMenuAnimation = .default
    
    var moreBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置个性化地图
        setCustomMap()
        
        //初始化地图视图
        initMapView()
        
        //开启定位
        startLocation()
        
        //自定义定位精度圈
        customLocationCircle()
        
        //加载地图标注数据
        loadAnnotationData()
        
        //右上角列表按钮
        initBuildsButton()
        
        self.view.addSubview(SingletonCoordinate.mapView!)
    }
    
    //设置个性化地图
    func setCustomMap() {
        let path = Bundle.main.path(forResource: "custom_config", ofType: "")
        BMKMapView.customMapStyle(path)
    }
    
    //初始化地图视图
    func initMapView() {
        //初始化地图视图
        SingletonCoordinate.mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        //设置定位模式（普通定位模式）
        SingletonCoordinate.mapView?.userTrackingMode = BMKUserTrackingModeNone
        
        //开启标尺显示
        SingletonCoordinate.mapView?.showMapScaleBar = true
        
        SingletonCoordinate.mapView?.delegate = self
        
        //开启自定义样式
        BMKMapView.enableCustomMapStyle(true)
        
    }
    
    //开启定位
    func startLocation() {
        locationService = BMKLocationService()
        locationService?.delegate = self
        locationService?.startUserLocationService()
    }
    
    //自定义定位精度圈
    func customLocationCircle() {
        let displayParam = BMKLocationViewDisplayParam()
        displayParam.isAccuracyCircleShow = false
        SingletonCoordinate.mapView?.updateLocationView(with: displayParam)
        
    }
    
    func loadAnnotationData() {
        var annotationArr: Array = Array<Any>()
        for build in Build.builds() {
            let annotation = BMKPointAnnotation()
            annotation.coordinate.latitude = build.latitude
            annotation.coordinate.longitude = build.longitude
            annotation.title = build.title
            
            annotationArr.append(annotation)
        }
        
        SingletonCoordinate.mapView?.addAnnotations(annotationArr)
    }
    
    func initBuildsButton() {
        
        moreBtn = UIButton(frame: CGRect(x: self.view.bounds.size.width - 75, y: 25, width: 60, height: 73))
        
        moreBtn?.setImage(#imageLiteral(resourceName: "love_more"), for: .normal)
        
        moreBtn?.addTarget(self, action: #selector(clickMore), for: .touchUpInside)
        
        SingletonCoordinate.mapView?.addSubview(moreBtn!)
    }
    
    //加载侧边栏
    func loadSideMenu() {
        
        let buildsVC = storyboard?.instantiateViewController(withIdentifier: "BUILDS_CONTROLLER") as! BuildsTableViewController
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: buildsVC, menuPosition:.right)
        sideMenu?.delegate = self
        sideMenu?.menuWidth = 210
        //sideMenu?.bouncingEnabled = false
        sideMenu?.allowLeftSwipe = false
    }
    
    @objc func clickMore() {

        if sideMenu == nil {
            //加载右侧列表
            loadSideMenu()
        }
        
        if sideMenu!.isMenuOpen {
            hideSideMenuView()
        } else {
            showSideMenuView()
        }
    }
    
    // MARK: - BMKLocationServiceDelegate
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        print("更新定位：userLocation【\(userLocation)】")
        
        SingletonCoordinate.mapView?.showsUserLocation = true
        SingletonCoordinate.mapView?.updateLocationData(userLocation)
        
        SingletonCoordinate.userCoordinate = userLocation.location.coordinate
        
        let coorSpan = BMKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        userRegion = BMKCoordinateRegion(center: SingletonCoordinate.userCoordinate!, span: coorSpan)
        
        SingletonCoordinate.mapView?.setRegion(userRegion!, animated: true)
        
        locationService?.stopUserLocationService()

    }
    
    func didFailToLocateUserWithError(_ error: Error!) {
        print("定位失败，错误代码：\(error)")
    }
    
    func didStopLocatingUser() {
        print("已停止定位！")
    }
    
    // MARK: - BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        let annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation_View_Id")
        
        //标注点自定义
        annotationView?.annotation = annotation
        
        let pointImg = imageScaleToSize(image: UIImage(named: "love_icon")!, size: CGSize(width: 40, height: 40))
        annotationView?.image = pointImg
        
        let lable = UILabel(frame: CGRect(x: -50, y: 30, width: 140, height: 35))
        lable.text = annotation.title!()
        lable.textColor = UIColor.orange
        lable.textAlignment = NSTextAlignment.center
        annotationView?.addSubview(lable)
        
        //关闭气泡显示
        annotationView?.isEnabled = true
        annotationView?.canShowCallout = false
        
        return annotationView
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        
        view.setSelected(false, animated: true)
        
        var buildImg = #imageLiteral(resourceName: "build")
        for build in Build.builds() {
            if view.annotation.title!() == build.title {
                buildImg = UIImage(named: build.image)!
                break
            }
        }
        
        let popImg = imageScaleToSize(image: buildImg, size: CGSize(width: 985, height: 1000))
        
        //计算距离
        //let attrStr = getDistanceAttributedString(type: 1, buildCoord: view.annotation.coordinate)
        let singleCoor = SingletonCoordinate.shareInstance
        let attrStr = singleCoor.getDistanceAttributedString(type: 1, buildCoord: view.annotation.coordinate)
        
        let popup = PopupDialog(title: view.annotation.title!(), message: "", image: popImg)
        
        //UI自定义设置
        setDialogAppearance(attrStr: attrStr)
        
        let btnOk = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        btnOk.center.x = (popup.view.center.x)
        btnOk.frame.origin.y = popup.view.bounds.size.height - 145
        btnOk.setBackgroundImage(#imageLiteral(resourceName: "love_find_bg"), for: .normal)
        btnOk.addTarget(self, action: #selector(clickBtnGaoBai(_:)), for: .touchUpInside)
        let okImg = imageScaleToSize(image: #imageLiteral(resourceName: "love_find"), size: CGSize(width: 30, height: 25))
        btnOk.setImage(okImg, for: .normal)
        btnOk.setTitle("  找告白", for: .normal)

        popup.view.addSubview(btnOk)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    //弹出UI自定义设置
    func setDialogAppearance(attrStr: NSMutableAttributedString) {
        
        PopupDialogDefaultView.appearance().messageAttributedText = attrStr
        
        PopupDialogDefaultView.appearance().titleFont = UIFont.systemFont(ofSize: 18)
        
        PopupDialogContainerView.appearance().cornerRadius = 15
        PopupDialogContainerView.appearance().backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 0.9)
        PopupDialogContainerView.appearance().shadowEnabled = true
    }
    
    //MARK: - 修改图片尺寸
    func imageScaleToSize(image: UIImage, size: CGSize) -> UIImage{
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        // Determine whether the screen is retina
        if UIScreen.main.scale == 2.0{
            UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        }else{
            UIGraphicsBeginImageContext(size)
        }
        
        // 绘制改变大小的图片
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 从当前context中创建一个改变大小后的图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext()
        
        // 返回新的改变大小后的图片
        return scaledImage!
    }

    //调用Unity接口
    @objc func clickBtnGaoBai(_ sender:UIButton) {
        print("-------点击-------")
    }
    
    // MARK: - ENSideMenuProtocol, ENSideMenuDelegate
    func setContentViewController(_ contentViewController: UIViewController) {
        
    }
    
    func sideMenuWillOpen() {
        
        UIView.animate(withDuration: 0.6) {
            self.moreBtn?.frame = CGRect(x: self.view.bounds.size.width - 255, y: 25, width: 35, height: 35)
            self.moreBtn?.setImage(#imageLiteral(resourceName: "hideMore"), for: .normal)
        }
        
    }
    
    func sideMenuWillClose() {
        
        UIView.animate(withDuration: 0.6) {
            self.moreBtn?.setImage(#imageLiteral(resourceName: "love_more"), for: .normal)
            self.moreBtn?.frame = CGRect(x: self.view.bounds.size.width - 75, y: 25, width: 60, height: 73)
        }
        
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func sideMenuDidOpen() {

    }
    
    func sideMenuDidClose() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SingletonCoordinate.mapView?.viewWillAppear()
        SingletonCoordinate.mapView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SingletonCoordinate.mapView?.viewWillDisappear()
        SingletonCoordinate.mapView?.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
