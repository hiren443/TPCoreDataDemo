//
//  DetailViewController.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    
    @IBOutlet var imageVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var userScore: UILabel!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var releaseDtLbl: UILabel!
    @IBOutlet weak var circleVw: CircleChartView!
    
    
    var movieObject = MovieModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(movieObject)
        self.title = movieObject.title
        let artworkUrl = movieObject.backdrop_path
        let url:URL! = URL(string: artworkUrl)
        var task: URLSessionDownloadTask!
        let session: URLSession!
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            if let data = try? Data(contentsOf: url){
                // 4
                let img:UIImage! = UIImage(data: data)
                DispatchQueue.main.async(execute: { () -> Void in
                    // 5
                    // Before we assign the image, check whether the current cell is visible
                    self.imageVw?.image = img
                })
            }
        })
        task.resume()
        
        titleLbl.text = movieObject.title
        userScore.text = String(movieObject.vote_average * 10) + "%"
        descLbl.text = movieObject.overview
        releaseDtLbl.text = movieObject.release_date
        
        circleVw.arcBackgroundColor = UIColor(red: 33.0/255.0, green: 208.0/255.0, blue: 122/255.0, alpha: 1.0)
        circleVw.arcColor = UIColor(red: 32.0/255.0, green: 69.0/255.0, blue: 41/255.0, alpha: 0.4)
        circleVw.arcWidth = 7.0
        circleVw.isPie = false
        circleVw.endArc = CGFloat(movieObject.vote_average/10)
        
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

