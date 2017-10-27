//
//  MovieModel.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import Foundation

class MovieModel : NSObject, NSCoding {
    
    
    var adult = true
    var backdrop_path = ""
    //var genre_ids = [String]()
    var id = 0
    var original_language = ""
    var original_title = ""
    var overview = ""
    var popularity = 0
    var poster_path = ""
    var release_date = ""
    var video = true
    var title = ""
    var year = 0
    var vote_average = 0.0
    var vote_count = 0
    
    var movieArr = [String]()
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(adult, forKey: "")
        aCoder.encode(backdrop_path, forKey: "backdrop_path")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(original_language, forKey: "original_language")
        aCoder.encode(original_title, forKey: "original_title")
        aCoder.encode(overview, forKey: "overview")
        aCoder.encode(popularity, forKey: "popularity")
        aCoder.encode(poster_path, forKey: "poster_path")
        aCoder.encode(release_date, forKey: "release_date")
        aCoder.encode(video, forKey: "video")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(vote_average, forKey: "vote_average")
        aCoder.encode(vote_count, forKey: "vote_count")
        
        //aCoder.encode(genre_ids, forKey: "genre_ids")
    }
    
    override init() {
        adult = true
        backdrop_path = " "
        id = 0
        original_language = ""
        original_title = " "
        overview = ""
        popularity = 0
        poster_path = ""
        release_date = ""
        video = true
        title = ""
        vote_average = 0
        vote_count = 0
        //genre_ids = [String]()
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(adult, forKey: "")
        aCoder.encode(backdrop_path, forKey: "backdrop_path")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(original_language, forKey: "original_language")
        aCoder.encode(original_title, forKey: "original_title")
        aCoder.encode(overview, forKey: "overview")
        aCoder.encode(popularity, forKey: "popularity")
        aCoder.encode(poster_path, forKey: "poster_path")
        aCoder.encode(release_date, forKey: "release_date")
        aCoder.encode(video, forKey: "video")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(vote_average, forKey: "vote_average")
        aCoder.encode(vote_count, forKey: "vote_count")
        aCoder.encode(vote_count, forKey: "year")
        //aCoder.encode(genre_ids, forKey: "genre_ids")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! Int
        backdrop_path = aDecoder.decodeObject(forKey: "backdrop_path") as! String
        adult = aDecoder.decodeObject(forKey: "adult") as! Bool
        original_language = aDecoder.decodeObject(forKey: "original_language") as! String
        original_title = aDecoder.decodeObject(forKey: "original_title") as! String
        overview = aDecoder.decodeObject(forKey: "overview") as! String
        popularity = aDecoder.decodeObject(forKey: "popularity") as! Int
        poster_path = aDecoder.decodeObject(forKey: "poster_path") as! String
        release_date = aDecoder.decodeObject(forKey: "release_date") as! String
        video = aDecoder.decodeObject(forKey: "video") as! Bool
        title = aDecoder.decodeObject(forKey: "title") as! String
        vote_average = aDecoder.decodeObject(forKey: "vote_average") as! Double
        vote_count = aDecoder.decodeObject(forKey: "vote_count") as! Int
        vote_count = aDecoder.decodeObject(forKey: "year") as! Int
        //genre_ids = aDecoder.decodeObject(forKey: "genre_ids") as! Array
        
    }
    
    
    class func createMovieArray(movieArray : NSArray) -> [MovieModel] {
        var movieModelArray = [MovieModel]()
        for movie in (movieArray as? [[String:Any]])! {
            let model = MovieModel()
            
            model.id = movie["id"] as! Int
            
            if let backdrop_path = movie["backdrop_path"] as? String {
                model.backdrop_path = "https://image.tmdb.org/t/p/w500/" + backdrop_path
            }
            if let adult = movie["adult"] as? Bool {
                model.adult = adult
            }
            if let original_language = movie["original_language"] as? String {
                model.original_language = original_language
            }
            if let overview = movie["overview"] as? String {
                model.overview = overview
            }
            if let popularity = movie["popularity"] as? Int {
                model.popularity = popularity
            }
            if let poster_path = movie["poster_path"] as? String {
                model.poster_path = "https://image.tmdb.org/t/p/w800/" + poster_path
            }
            if let release_date = movie["release_date"] as? String {
                model.release_date = release_date
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let newDate = formatter.date(from: movie["release_date"] as! String )
            
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: newDate!)
            model.year = Int(year)!
            
            if let video = movie["video"] as? Bool {
                model.video = video
            }
            if let title = movie["title"] as? String {
                model.title = title
            }
            if let vote_average = movie["vote_average"] as? Double {
                model.vote_average = vote_average
            }
            if let vote_count = movie["vote_count"] as? Int {
                model.vote_count = vote_count
            }
            //for ids in movie["genre_ids"] as? Array {
            //  model.genre_ids.append(ids)
            //}
            
            movieModelArray.append(model)
        }
        
        return movieModelArray
    }
    
}


