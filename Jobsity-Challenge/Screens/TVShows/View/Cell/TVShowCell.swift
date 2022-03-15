//
//  TVShowCell.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-13.
//

import UIKit

class TVShowCell: UITableViewCell {
    static let tvShowCellIdentifier = "TvShowCell"
    
    // MARK: UIElements
    let mainTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.image = nil
    }
    
    public func setup(_ show: TVShow) {
        mainTitle.text = show.name
        
        if(show.image != nil) {
            coverImage.loadFrom(URLAddress: show.image!.medium)
        }
        
        subTitle.text = show.genres.joined(separator: ", ")
    }
    
    private func setupLayout() {
        [mainTitle, coverImage, subTitle].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        NSLayoutConstraint.activate([
            //Cover Image
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImage.widthAnchor.constraint(equalToConstant: 50),
            //Title
            mainTitle.topAnchor.constraint(equalTo: coverImage.topAnchor),
            mainTitle.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 16),
            mainTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            //Subtitle
            subTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 8),
            subTitle.leadingAnchor.constraint(equalTo: mainTitle.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: mainTitle.trailingAnchor),
        ])
    }
}
