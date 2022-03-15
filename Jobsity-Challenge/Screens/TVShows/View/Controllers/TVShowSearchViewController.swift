//
//  TVShowSearchViewController.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import Foundation
import UIKit
import Combine

class TVShowSearchViewController: UIViewController {
    // MARK: UIElements
    private lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Type a show's name"
        searchbar.delegate = self
        searchbar.returnKeyType = .default
        searchbar.becomeFirstResponder()
        //TODO: Will only work on iPhone devices, for iPads we should take a different approach
        searchbar.showsCancelButton = true
        return searchbar
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(TVShowCell.self, forCellReuseIdentifier: TVShowCell.tvShowCellIdentifier)
        return tableView
    }()
    
    // MARK: ViewModel
    private let viewModel: TVShowSearchViewModel
    var cancellable = Set<AnyCancellable>()
    
    // MARK: Publisher
    var searchValue = CurrentValueSubject<String, Never>("")
    
    init(viewModel: TVShowSearchViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
    }
    
    private func setupLayout() {
        navigationItem.titleView = searchBar
        
        //setupTableView
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.transform(input: .init(searchValue: searchValue.eraseToAnyPublisher()))
        
        viewModel.searchResultsSubject.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &cancellable)
        
        viewModel.isLoading.sink { [unowned self] value in
            self.tableView.backgroundView = value ? loadingIndicator : nil
            self.tableView.reloadData()
        }.store(in: &cancellable)
    }
}

extension TVShowSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResultsSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVShowCell.tvShowCellIdentifier, for: indexPath) as! TVShowCell
        cell.setup(viewModel.searchResultsSubject.value[indexPath.row].show)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = TVShowDetailsViewController(show: viewModel.searchResultsSubject.value[indexPath.row].show)
        self.navigationController?.pushViewController(details, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TVShowSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchValue.send(searchText)
    }
}
