//
//  EpisodeCell.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-14.
//

import UIKit

class EpisodeCell: UITableViewCell {
    static let id: String = "episodeCell"
    
    // MARK: UIElements
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(episode: Episode) {
        mainTitle.text = "\(episode.number). \(episode.name)"
        subTitle.text = "Aired \(episode.airdate)"
    }
    
    private func setupLayout() {
        [mainTitle, subTitle].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            subTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 4),
            subTitle.leadingAnchor.constraint(equalTo: mainTitle.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: mainTitle.trailingAnchor),
            subTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
