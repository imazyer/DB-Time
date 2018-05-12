//
//  DBCelebrityModel.swift
//  DB-Time
//
//  Created by Mazy on 2018/5/12.
//  Copyright © 2018年 Mazy. All rights reserved.
//

import UIKit
import ObjectMapper

struct DBCelebrityModel: Mappable {
    
    var mobileUrl: String = ""
    var name: String = ""
    var works: [DBWorkModel] = []
    var gender: String = ""
    var avatars: DBAvatar!
    var id: String = ""
    var aka: [String] = []
    var nameEN: String = ""
    var bornPlace: String = ""
    var alt: String = ""
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        mobileUrl <- map["mobile_url"]
        name <- map["name"]
        works <- map["works"]
        gender <- map["gender"]
        avatars <- map["avatars"]
        id <- map["id"]
        aka <- map["aka"]
        nameEN <- map["name_en"]
        bornPlace <- map["born_place"]
        alt <- map["alt"]
    }
}

struct DBWorkModel: Mappable {
    
    var roles: [String] = []
    var movie: DBMovieSubject!
    
    init?(map: Map) {
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        roles <- map["roles"]
        movie <- map["subject"]
    }
}
