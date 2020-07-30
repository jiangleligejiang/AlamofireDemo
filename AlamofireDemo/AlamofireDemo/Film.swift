//
//  Film.swift
//  AlamofireDemo
//
//  Created by jams on 2020/7/24.
//  Copyright © 2020 jams. All rights reserved.
//

import Foundation

class Films: Codable {
    let all: [Film]
    
    enum CodingKeys: String, CodingKey {
        case all = "results"
    }
}

class Film: Codable {
    let title: String
    let episodeId: Int
    let director: String
    let producer: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeId = "episode_id"
        case director
        case producer
        case date = "release_date"
    }
    
    init(title: String, episodeId: Int, director: String, producer: String, date: String) {
        self.title = title
        self.episodeId = episodeId
        self.director = director
        self.producer = producer
        self.date = date
    }
}

extension Film: CustomStringConvertible {
    var description: String {
        return "title:\(title), episodeId:\(episodeId), director:\(director) producer:\(producer), date:\(date)\n"
    }
}
