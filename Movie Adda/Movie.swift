//
//  Movie.swift
//  Movie Adda
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation

enum MovieType {
    case Unknown
    case Movie
    case Series
    case Episode
}

class Movie {
    var title: String
    var year: String
    var imdbID: String
    var type: MovieType
    var posterImgURL: NSURL
    var rating: String?
    var plot: String?
    var genres: [String]?
    var releaseDate: String?
    var duration: String?
    
    convenience init(){
        self.init(title: "", year: "", imdbID: "", type:"", poster:NSURL())
    }
    
    init(title: String, year: String, imdbID: String, type typeString:String, poster:NSURL) {
        self.title = title
        self.year = year
        self.imdbID = imdbID
        self.posterImgURL = poster
        switch typeString {
        case "movie":
            self.type = .Movie
        case "episode":
           self.type = .Episode
        case "series":
            self.type = .Series
        default:
            self.type = .Unknown
        }
    }
    
    convenience init(dict: Dictionary<String, String>) {
        let url = NSURL.init(string: dict["Poster"]! as String!)
        let title = dict["Title"] as String!
        let year = dict["Year"] as String!
        let id = dict["imdbID"] as String!
        let type = dict["Type"] as String!
        self.init(title: title, year: year, imdbID: id, type: type, poster: url!)
    }
    
    
    static func fetchMovieListForQuery(query:String, completion:(movieArray: [Movie]?) -> ()){

        let escapedString = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let str = Constants.OMDBBaseURL+"s=\(escapedString)"
        let url = NSURL.init(string: str)!
        
        let request = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) -> Void in
           
            if let error = error {
                print("\(error.description)")
                //error
                completion(movieArray: nil)
                return
            }
            
            guard let data = data,
                let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: [.MutableLeaves, .AllowFragments])  else {
                    //no data
                    completion(movieArray: nil)
                    return
            }
            var moviesArray = [Movie]()
            
            if let movies = jsonDict["Search"] as? [[String:String]] {
                for movieDict in movies {
                    let movie = Movie.init(dict: movieDict)
                    moviesArray.append(movie)
                }
            }
            completion(movieArray: moviesArray)
        }
        dataTask.resume()
    }
    
    func updateWithMoreDetils(completion:(updated: Bool) -> ()){
        
        let str = Constants.OMDBBaseURL+"i=\(imdbID)"
        let url = NSURL.init(string: str)!
        
        let request = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 45)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) -> Void in
            
            if let error = error {
                print("\(error.description)")
                //error
                completion(updated: false)
                return
            }
            
            guard let data = data,
                let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data, options: [.MutableLeaves, .AllowFragments])  else {
                    //no data
                    completion(updated: false)
                    return
            }
            self.rating = jsonDict["Rated"] as? String
            self.plot = jsonDict["Plot"] as? String
            self.duration = jsonDict["Runtime"] as? String
            self.releaseDate = jsonDict["Released"] as? String
            if let str = jsonDict["Genre"] {
                let geneString = str as! String
                let arr = geneString.componentsSeparatedByString(", ")
                self.genres = arr
            }
            completion(updated: true)
        }
        dataTask.resume()
    }
    
}