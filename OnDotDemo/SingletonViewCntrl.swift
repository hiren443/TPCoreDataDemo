//
//  SingletonViewCntrl.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 25/10/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import Foundation
import SwiftyJSON

class SingletonViewCntrl: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var items = [UserObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width, height: 50))
        btn.backgroundColor = UIColor.red
        btn.setTitle("Add new Dummy", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(SingletonViewCntrl.addDummyData), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
    }
    
    func addDummyData() {
        APIHelperSingleton.sharedInstance.getRandomUser { (json: JSON) in
            if let results = json["results"].array {
                for entry in results {
                    self.items.append(UserObject(json: entry))
                }
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        let user = self.items[indexPath.row]
        
        if let url = NSURL(string: user.pictureURL) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.imageView?.image = UIImage(data: data as Data)
            }
        }
        cell!.textLabel?.text = user.username
        return cell!
    }
}
