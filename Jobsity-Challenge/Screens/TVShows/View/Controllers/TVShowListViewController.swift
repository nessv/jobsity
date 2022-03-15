//
//  TVShowListViewController.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-12.
//

import UIKit
import Combine

class TVShowListViewController: UIViewController {
    // MARK: ViewModel
    var viewModel = TVShowsViewModel()
    var cancellable = Set<AnyCancellable>()
    
    // MARK: UIElements
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(TVShowCell.self, forCellReuseIdentifier: TVShowCell.tvShowCellIdentifier)
        return tableView
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var searchItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapOnSearch))
        return item
    }()
    
    // MARK: State Manager
    private var fetchSubject = PassthroughSubject<Void, Never>()
    public var fetchingMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
    }
    
    private func setupLayout() {
        self.title = "TV Shows"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = searchItem
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.bind(.init(loadNextPage: fetchSubject.eraseToAnyPublisher()))
        
        viewModel.tvShowsSubject.sink { [unowned self] shows in
            fetchingMore = false
            self.tableView.reloadData()
        }.store(in: &cancellable)
        
        viewModel.isLoadingSubject.sink { [unowned self] value in
            if (value) {
                self.tableView.backgroundView = loadingIndicator
            } else {
                self.tableView.backgroundView = nil
            }
        }.store(in: &cancellable)
    }
    
    @objc private func didTapOnSearch() {
        //Prepare navigation to seachViewPage
        let vc = TVShowSearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                fetchingMore = true
                self.fetchSubject.send()
            }
        }
    }
}

extension TVShowListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tvShowsSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVShowCell.tvShowCellIdentifier, for: indexPath) as! TVShowCell
        cell.setup(viewModel.tvShowsSubject.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = TVShowDetailsViewController(show: viewModel.tvShowsSubject.value[indexPath.row])
        self.navigationController?.pushViewController(details, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



