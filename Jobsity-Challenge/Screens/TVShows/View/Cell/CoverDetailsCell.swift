//
//  CoverDetailsCell.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import UIKit

class CoverDetailsCell: UITableViewCell {
    static let coverDetailsCellIdentifier = "coverDetailsCell"
    
    // MARK: UIElements
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let topContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(show: TVShow) {
        if let image = show.image {
            coverImage.loadFrom(URLAddress: image.original)
        }
        
        topContentLabel.attributedText = {
            let attributedText = NSMutableAttributedString()
            //Show Title in Bold
            attributedText.append(NSAttributedString(string: show.name, attributes: [.font: UIFont.boldSystemFont(ofSize: 20)]))
            //Show genres
            attributedText.append(NSAttributedString(string: "\n" + show.genres.joined(separator: ", "), attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .light)]))
            //Days aired
            attributedText.append(NSAttributedString(string: "\n\n" + show.schedule.convertToText(), attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .light)]))
            
            return attributedText
        }()
        
        summaryLabel.attributedText = {
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "Summary\n\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)]))
            
            attributedString.append(.init(string: show.summary?.htmlToString ?? ""))
            
            return attributedString
        }()
    }
    
    private func setupLayout() {
        [coverImage, topContentLabel, summaryLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImage.heightAnchor.constraint(equalToConstant: 150),
            coverImage.widthAnchor.constraint(equalToConstant: 150 * 0.67),
            
            topContentLabel.topAnchor.constraint(equalTo: coverImage.topAnchor),
            topContentLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 16),
            topContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            summaryLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 24),
            summaryLabel.leadingAnchor.constraint(equalTo: coverImage.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: topContentLabel.trailingAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
