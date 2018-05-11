//
//  DBRatingModel.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/4.
//  Copyright © 2018 Mazy. All rights reserved.
//

import UIKit
import ObjectMapper

struct DBMovie: Mappable {
    
    var count: Int = 0
    var start: Int = 0
    var total: Int = 0
    var subjects: [DBMovieSubject] = []
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        subjects <- map["subjects"]
    }
}

struct DBMovieSubject: Mappable {
    
    var rating: DBRatingModel!
    var genres: [String] = []
    var title: String = ""
    var casts: [DBCastModel]!
    var collectCount: Int64 = 0
    var originalTitle: String = ""
    var subtype: String = ""
    var directors: [DBCastModel]!
    var year: String = ""
    var images: DBAvatar!
    var alt: String = ""
    var id: String = ""
    
    var wishCount: Int64 = 0
    var ratingsCount: Int64 = 0
    var mobileUrl: String?
    var countries: [String]?
    var summary: String?
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        rating <- map["rating"]
        genres <- map["genres"]
        title <- map["title"]
        casts <- map["casts"]
        collectCount <- map["collect_count"]
        originalTitle <- map["original_title"]
        subtype <- map["subtype"]
        directors <- map["directors"]
        year <- map["year"]
        images <- map["images"]
        alt <- map["alt"]
        id <- map["id"]
        
        wishCount <- map["wish_count"]
        ratingsCount <- map["ratings_count"]
        mobileUrl <- map["mobile_url"]
        countries <- map["countries"]
        summary <- map["summary"]
    }
}

class DBCastModel: Mappable {
    
    var alt: String = ""
    var name: String = ""
    var id: String = ""
    var avatars: DBAvatar!
    var role: String = "演员"
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        alt <- map["alt"]
        name <- map["name"]
        id <- map["id"]
        avatars <- map["avatars"]
    }
}

struct DBAvatar: Mappable {
    var small: String = ""
    var large: String = ""
    var medium: String = ""
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        small <- map["small"]
        large <- map["large"]
        medium <- map["medium"]
    }
}

struct DBRatingModel: Mappable {
    var max: Int = 0
    var min: Int = 0
    var average: Double = 0
    var stars: String = ""

    init?(map: Map) { }
    
    // Mappable
    mutating func mapping(map: Map) {
        max <- map["max"]
        min <- map["min"]
        average <- map["average"]
        stars <- map["stars"]
    }
}



struct DBUSBox: Mappable {
    
    var date: String = ""
    var title: String = ""
    var subjects: [DBUSBoxSubject] = []
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        date <- map["date"]
        title <- map["title"]
        subjects <- map["subjects"]
    }
}

struct DBUSBoxSubject: Mappable {
    var box: Int = 0
    var new: Bool = false
    var rank: Int = 0
    var subject: DBMovieSubject!
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        box <- map["box"]
        new <- map["new"]
        rank <- map["rank"]
        subject <- map["subject"]
    }
}
