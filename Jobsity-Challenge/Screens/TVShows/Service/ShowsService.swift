//
//  ShowsService.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-12.
//

import Foundation
import Combine

protocol TVShowsProtocol {
    func getShowsByPage(_ page: Int) -> AnyPublisher<[TVShow], Never>
    func searchShow(_ query: String) -> AnyPublisher<[TVShows], Never>
    func getEpisodesForShow(with id: Int) -> AnyPublisher<[Episode], Never>
}


class TVShowsService: TVShowsProtocol {
    func getShowsByPage(_ page: Int) -> AnyPublisher<[TVShow], Never> {
        let url = URL(string: "https://api.tvmaze.com/shows?page=\(page)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TVShow].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func searchShow(_ query: String) -> AnyPublisher<[TVShows], Never> {
        let finalQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        return URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.tvmaze.com/search/shows?q=\(finalQuery)")!)
            .map { $0.data }
            .decode(type: [TVShows].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func getEpisodesForShow(with id: Int) -> AnyPublisher<[Episode], Never> {
        let url = URL(string: "https://api.tvmaze.com/shows/\(id)/episodes")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}


