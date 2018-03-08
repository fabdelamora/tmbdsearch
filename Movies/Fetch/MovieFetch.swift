//
//  MovieFetch.swift
//  Movies
//
//  Created by Fabriccio De la Mora on 3/7/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

var apiKey = "b80b8621cba3cd202c848c47de944123"

class MovieFetch: NSObject {
    private let searchMovieString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&page=1&include_adult=false"
    private let discoverMoviesString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
    
    func getMovies(success:@escaping ([Movie])-> Void){
        Alamofire.request(discoverMoviesString).responseJSON {response in
            switch response.result {
            case .success(let value):
                let results = ((value as! [String : Any])["results"] as! [[String : Any]])
                print(results)
                self.mapItems(results, success: { movies in
                    success(movies)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func mapItems(_ items: [[String: Any]], success:(([Movie])->(Void))?){
        var movies: [Movie] = []
        
        for movie : [String:Any] in items {
            let entry: Movie = Mapper<Movie>().map(JSONObject: movie)!
            movies.append(entry)
        }
        
        success?(movies)
    }
    
    func searchMovie(_ title: String, success:@escaping ([Movie])-> Void){
        let parameters: Parameters = [
            "query": title
        ]
        
        Alamofire.request(searchMovieString,
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding(destination: .queryString),
                          headers: nil).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if let results = (value as! [String : Any])["results"]{
                                    self.mapItems(results  as! [[String : Any]], success: { movies in
                                        success(movies)
                                    })
                                }
                            case .failure(let error):
                                print(error)
                            }
        }
    }
    
    func noResultsList() -> [Movie] {
        var results: [Movie] = []
        let entry: Movie = Mapper<Movie>().map(JSONObject: ["title":"No results found"])!
        results.append(entry)
        return results
    }
    
    func posterUrlForResource(_ path: String, width:Int) -> URL {
        return URL(string: "http://image.tmdb.org/t/p/w\(width)/\(path)")!
    }
}

