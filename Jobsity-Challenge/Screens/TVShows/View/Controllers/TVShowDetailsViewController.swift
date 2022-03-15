//
//  TVShowDetailsViewController.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import UIKit
import Combine

class TVShowDetailsViewController: UIViewController {
    // MARK: UIElements
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CoverDetailsCell.self, forCellReuseIdentifier: CoverDetailsCell.coverDetailsCellIdentifier)
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.id)
        return tableView
    }()
    
    // MARK: ViewModel
    private let show: TVShow
    private lazy var viewModel = TVShowDetailsViewModel(show: show)
    var cancellable = Set<AnyCancellable>()
    
    init(show: TVShow) {
        self.show = show
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bind()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bind() {
        viewModel.bind()
        
        viewModel.output.listOfEpisodes.sink { [unowned self] episodes in
            self.tableView.reloadData()
        }.store(in: &cancellable)
    }
}

extension TVShowDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) { return 1 }
            return viewModel.output.listOfEpisodes.value[section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + viewModel.output.listOfEpisodes.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: CoverDetailsCell.coverDetailsCellIdentifier) as! CoverDetailsCell
            cell.setup(show: show)
            return cell
        } else {
            let data = viewModel.output.listOfEpisodes.value[indexPath.section]?[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.id) as! EpisodeCell
            cell.setup(episode: data!)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return nil }
        return "Season \(section)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let vc = EpisodeDetailsViewController(episode: viewModel.output.listOfEpisodes.value[indexPath.section]![indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
