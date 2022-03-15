//
//  TVShowDetailsViewModel.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import Foundation
import Combine

final class TVShowDetailsViewModel {
    
    struct TVShowDetailsOutput {
        var listOfEpisodes = CurrentValueSubject<Dictionary<Int, [Episode]>, Never>([:])
        var isLoading = CurrentValueSubject<Bool, Never>(true)
    }
    
    var output = TVShowDetailsOutput()
    private let show: TVShow
    private let service: TVShowsService
    var cancellable = Set<AnyCancellable>()
    
    init(show: TVShow, service: TVShowsService = .init()) {
        self.show = show
        self.service = service
    }
    
    func bind() {
        service.getEpisodesForShow(with: show.id)
            .receive(on: DispatchQueue.main)
            .map {
                Dictionary(grouping: $0, by: { $0.season })
            }
            .sink { [unowned self] episodes in
                self.output.isLoading.send(false)
                self.output.listOfEpisodes.send(episodes)
            }.store(in: &cancellable)
    }
}
