//
//  EpisodeDetailsViewController.swift
//  Jobsity-Challenge
//
//  Created by Nestor Valdez on 2022-03-14.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    // MARK: UIElements
    private var scrollView: UIScrollView!
    private var episodeImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var episodeInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private var episodeSummary: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // MARK: External
    private let episode: Episode
    
    init(episode: Episode) {
        self.episode = episode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupInfo()
    }
    
    private func setupInfo() {
        episodeImage.loadFrom(URLAddress: episode.image.original)
        
        episodeInfo.attributedText = {
            let attributedText = NSMutableAttributedString()
           //Show Title in Bold
           attributedText.append(NSAttributedString(string: episode.name, attributes: [.font: UIFont.boldSystemFont(ofSize: 20)]))
            
            attributedText.append(NSAttributedString(string: "\n" + "Season \(episode.season) | Episode \(episode.number)", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.systemGray]))
           return attributedText
        }()
        
        
        episodeSummary.attributedText = {
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "Summary\n\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 20)]))

            attributedString.append(.init(string: episode.summary.htmlToString))

            return attributedString
        }()
    }
    
    
    private func setupLayout() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView?.alwaysBounceHorizontal = false
        
        let verticalStackView = UIStackView(arrangedSubviews: [episodeInfo, episodeSummary, UIView()])
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 16
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .top
        
        let contentView = UIView()
        contentView.frame = scrollView.bounds
        
        scrollView.addSubview(contentView)
        
        [episodeImage, verticalStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            episodeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            episodeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodeImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height * 0.4),
            
            verticalStackView.topAnchor.constraint(equalTo: episodeImage.bottomAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: episodeImage.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: episodeImage.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
