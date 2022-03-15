//
//  Episode.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import Foundation

struct Episode: Codable {
    let name: String
    let season, number: Int
    let image: Image
    let summary: String
    let airdate: String
}
