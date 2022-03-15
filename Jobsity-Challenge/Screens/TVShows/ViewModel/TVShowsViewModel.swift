//
//  TVShowsViewModel.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-12.
//

import Foundation
import Combine

enum HTTPError: LocalizedError {
    case statusCode
}

final class TVShowsViewModel {
    //Output
    var tvShowsSubject = CurrentValueSubject<[TVShow], Never>([])
    var isLoadingSubject = CurrentValueSubject<Bool, Never>(true)
    var searchResultsSubject = CurrentValueSubject<[TVShow], Never>([])
    
    //Input
    struct TVShowListInput {
        var loadNextPage: AnyPublisher<Void, Never>
    }
    
    //Other
    private var service: TVShowsService
    var cancellable = Set<AnyCancellable>()
    
    //Private
    private var tvShows: [TVShow] = [] {
        didSet {
            self.tvShowsSubject.send(tvShows)
        }
    }
    
    private var currentPage: Int = 0
    
    init(service: TVShowsService = .init()) {
        self.service = service
    }
    
    func bind(_ input: TVShowListInput) {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        input.loadNextPage
            .map { [unowned self] in service.getShowsByPage(currentPage) }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] shows in
                self.isLoadingSubject.send(false)
                self.tvShows.append(contentsOf: shows)
                currentPage += 1
            }.store(in: &cancellable)
    }
}
