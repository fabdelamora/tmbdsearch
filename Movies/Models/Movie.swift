//
//  Movie.swift
//  Movies
//
//  Created by Fabriccio De la Mora on 3/7/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import UIKit
import ObjectMapper

class Movie: Mappable{
    var id: String = ""
    var title: String = ""
    var posterPath: String = ""
    var overview: String = ""
    var releaseDate: String = ""
    var voteAverage: Double = 0.0
    
    required public convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id             <- map["id"]
        title          <- map["title"]
        posterPath     <- map["poster_path"]
        overview       <- map["overview"]
        releaseDate    <- map["release_date"]
        voteAverage    <- map["vote_average"]
    }
}

