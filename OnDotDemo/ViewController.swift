//
//  ViewController.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

import CoreData


class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    
    var MovieArray = [MovieModel]()
    var pageCount = 0
    var totalPages = 0
    var totalResults = 0
    let apiKey:String = "0f5caabcb4b7fe1f135b5036334575b8"
    let accessToken:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZjVjYWFiY2I0YjdmZTFmMTM1YjUwMzYzMzQ1NzViOCIsInN1YiI6IjU5NDc3MzBiOTI1MTQxM2ZmNDAzOTQ0OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HgniT1rbRj1EHFORmOljn9S3MgMZL1-0J9uD5d3uwX8"
    @IBOutlet weak var tableView: UITableView!
    var lastContentOffset = 0
    var refreshCtrl: UIRefreshControl!
    var tableData:[AnyObject]!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    
    var minYear = 0
    var maxYear = 0
    var filterBtn: UIButton!
    
    
    var Movie: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "On Dot Movies"
        filterBtn = UIButton(type: .custom)
        filterBtn.setTitle("Filter", for: .normal)
        filterBtn.backgroundColor = UIColor.darkGray
        filterBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        filterBtn.addTarget(self, action: #selector(showFilterOption), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: filterBtn)
        getPopularMovieAPICall()
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()

        self.tableView.tableFooterView = UIView()
        activityIndicator = LoadMoreActivityIndicator(tableView: self.tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellIdentifier") as! CustomCell
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
            let url:URL! = URL(string: artworkUrl)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    let img:UIImage! = UIImage(data: data)
                    self.cache.setObject(img, forKey: artworkUrl as AnyObject)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(
                            at: [indexPath],
                            with: .fade)
                        self.tableView.endUpdates()
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getPopularMovieAPICall () {
        if(!isInternetAvailable()) {
            let alert = UIAlertController(title: "Warning!", message: "Please check your internet connection!", preferredStyle: UIAlertControllerStyle.alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(defaultAction)
            DispatchQueue.main.async {
                () -> Void in
                self.present(alert, animated: true, completion: {})
            }
            
        }
        if(self.totalPages > 0) {
            if(self.totalPages == pageCount){
                // SHOW Alert View
                return;
            }
        }
        pageCount += 1;
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        let pageCountStr = String(pageCount);
        let apiURL: String = "https://api.themoviedb.org/3/movie/top_rated?&api_key=" + apiKey + "&language=en-US&page=" + pageCountStr;
        
        let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {

                self.pageCount -= 1
                let alert = UIAlertController(title: "Warning!", message: "We are facing some issues right now. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(defaultAction)
                DispatchQueue.main.async {
                    () -> Void in
                    self.present(alert, animated: true, completion: {})
                }
                
            } else {
                let httpResponse = response as? HTTPURLResponse
                if((data) != nil) {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    let Results = (json as? [String : AnyObject])?["results"]
                    self.totalPages = (json as? [String : AnyObject])?["total_pages"] as! Int
                    self.totalResults = (json as? [String : AnyObject])?["total_results"] as! Int
                    var newAr = [MovieModel]()
                    newAr = MovieModel.createMovieArray(movieArray: Results as! NSArray)
                    self.MovieArray.append(contentsOf: newAr)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
        })
        
        dataTask.resume()
    }
    func showFilterOption() {
        let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        filterVC.filterArray =  self.MovieArray
        navigationController?.pushViewController(filterVC, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.scrollViewDidScroll(scrollView: scrollView) {
            DispatchQueue.global(qos: .utility).async {
                self.getPopularMovieAPICall()
                for i in 0..<3 {
                    sleep(1)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                }
            }
        }
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
}

