//
//  FilterViewController.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import UIKit
import Foundation
import SwiftRangeSlider

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var filterArray = [MovieModel]()
    var MovieArray = [MovieModel]()
    var minYear = 2000;
    var maxYear = 2000;
    @IBOutlet var rangeSlider:RangeSlider? = RangeSlider()
    @IBOutlet var okBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = URLSession.shared
        self.title = "Filter"
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MovieArray = filterArray
        
        for (index, element) in filterArray.enumerated() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let newDate = formatter.date(from: element.release_date)
            
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: newDate!)
            
            if(self.minYear > Int(year)!){
                self.minYear = Int(year)!
            }
            if(self.maxYear < Int(year)!) {
                self.maxYear = Int(year)!
            }
            rangeSlider?.minimumValue = Double(minYear)
            rangeSlider?.maximumValue = Double(maxYear)
            rangeSlider?.lowerValue = Double(minYear)
            rangeSlider?.upperValue = Double(maxYear)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"mvCellIdentifier", for: indexPath as IndexPath) as! CustomCell
        
        let Dict: MovieModel = self.MovieArray[indexPath.row]
        cell.titleLbl.text = Dict.title
        cell.imageVw?.image = UIImage(named: "placeholder")
        let artworkUrl = Dict.backdrop_path
        if (self.cache.object(forKey: artworkUrl as AnyObject) != nil){
            // 2
            // Use cache
            cell.imageView?.image = self.cache.object(forKey: artworkUrl as AnyObject) as? UIImage
            
        }else{
            // 3
            let artworkUrl = Dict.backdrop_path
            let url:URL! = URL(string: artworkUrl)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    let img:UIImage! = UIImage(data: data)
                    self.cache.setObject(img, forKey: artworkUrl as AnyObject)
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
//                        if let updateCell: CustomCell = self.tableView.cellForRow(at: indexPath as IndexPath) as! CustomCell? {
//                            updateCell.imageVw?.image = img
                            self.tableView.beginUpdates()
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                            self.tableView.endUpdates()
                            
                            
//                        }
                    })
                }
            })
            task.resume()
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.movieObject =  self.MovieArray[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
        minYear = Int(rangeSlider.lowerValue)
        maxYear = Int(rangeSlider.upperValue)
        MovieArray = filterArray.filter({m in (m.year > minYear && m.year < maxYear) })        
        
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.tableView.reloadData()
//        })
    }
    
    @IBAction func showFilterOption(_ sender: Any?) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.reloadData()
        })
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

