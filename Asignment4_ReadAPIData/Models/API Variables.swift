//
//  API Variables.swift
//  Asignment4_ReadAPIData
//
//  Created by Willie Green on 10/5/23.
//

import Foundation

//API Variables
struct Ranking: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var season: Int
    var week: Int
    var polls:[Poll]
}

struct Poll: Codable {
    var poll: String = "Coaches Poll"
    var ranks: [Rank]
}

struct Rank: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    var rank: Int
    var school: String
    var conference: String
    var firstPlaceVotes: Int
    var points: Int
    
}
