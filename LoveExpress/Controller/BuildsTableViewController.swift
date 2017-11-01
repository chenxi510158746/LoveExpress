//
//  BuildsTableViewController.swift
//  LoveExpress
//
//  Created by chenxi on 2017/10/27.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import UIKit

class BuildsTableViewController: UITableViewController {

    var selectedMenuItem : Int = 0
    
    let builds = Build.builds()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize apperance of table view
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) //64
        //tableView.backgroundColor = UIColor.clear
        // Preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        //tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 1)
        tableView.scrollsToTop = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return builds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BUILD_CELL", for: indexPath) as! BuildTableViewCell
        cell.backgroundColor = UIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 0.7)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        
        let buildObj = builds[indexPath.row]
        
        cell.buildName.text = buildObj.title
        cell.buildImg.image = UIImage(named: buildObj.image)
        
        let buildCoordinate = CLLocationCoordinate2D(latitude: buildObj.latitude, longitude: buildObj.longitude)
        
        let singleCoor = SingletonCoordinate.shareInstance
        
        let attrStr = singleCoor.getDistanceAttributedString(type: 2, buildCoord: buildCoordinate)
        
        cell.buildDistance.attributedText = attrStr
        
        cell.buildImg.layer.masksToBounds = true
        cell.buildImg.layer.cornerRadius = cell.buildImg.frame.size.height / 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        hideSideMenuView()
        
        let buildObj = builds[indexPath.row]
        
        let annotations = SingletonCoordinate.mapView?.annotations
        if annotations != nil {
            for annotation in annotations! {
                let anno = annotation as! BMKPointAnnotation
                
                if anno.coordinate.latitude == buildObj.latitude && anno.coordinate.longitude == buildObj.longitude {
                    
                    SingletonCoordinate.mapView?.selectAnnotation(anno, animated: true)
                    
                    print("===========build: \(buildObj.title)")
                    
                    break
                }
            }
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
