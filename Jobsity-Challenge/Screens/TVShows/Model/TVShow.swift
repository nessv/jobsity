//
//  TVShow.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-12.
//
import Foundation

// MARK: - TVShowElement
struct TVShow: Codable {
    let name: String
    let image: Image?
    let summary: String?
    let genres: [String]
    let schedule: Schedule
    let id: Int
}

struct TVShows: Codable {
    let show: TVShow
}

// MARK: - Image
struct Image: Codable {
    let original, medium: String
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String
    let days: [String]
}


extension Schedule {
    func convertToText() -> String {
        return "\(time) | \(days.joined(separator: "-"))"
    }
}
