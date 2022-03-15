//
//  TVShowSearchViewModel.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import Foundation
import Combine

final class TVShowSearchViewModel {
    //Output
    var searchResultsSubject = CurrentValueSubject<[TVShows], Never>([])
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    
    //Input
    struct TVShowInput {
        var searchValue: AnyPublisher<String, Never>
    }
    
    //Other
    private let service: TVShowsService
    var cancellable = Set<AnyCancellable>()
    
    init(service: TVShowsService = .init()) {
        self.service = service
    }
    
    func transform(input: TVShowInput) {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        input.searchValue
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter( {
                if($0.isEmpty) {
                    self.searchResultsSubject.send([])
                    return false
                }
                return true
            } )
            .map { [unowned self] query -> AnyPublisher<[TVShows], Never> in
                self.isLoading.send(true)
                self.searchResultsSubject.send([])
                return service.searchShow(query)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] shows in
                isLoading.send(false)
                self.searchResultsSubject.send(shows)
            }.store(in: &cancellable)
        

    }
}
