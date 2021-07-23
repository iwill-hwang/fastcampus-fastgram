//
//  FeedCell.swift
//  Fastcampus
//
//  Created by iwill.h on 2021/07/23.
//

import Foundation
import UIKit
import AVKit

class FeedCell: UITableViewCell {
    var feed: Feed? {
        didSet {
            guard let feed = feed else { return }
                
            if let url = URL(string: feed.user.profileImageURL) {
                userPhotoView.setImage(url: url)
            }
            
            collectionView.reloadData()
            collectionView.contentOffset = .zero
            
            userNameLabel.text = feed.user.name
            
            updateLike(feed)
            
            pageControl.numberOfPages = feed.medias.count
            pageControl.currentPage = 0
        }
    }
    
    var viewModel: FeedViewModel?
    
    @IBOutlet weak private var userPhotoView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak private var likeView: UIView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var likeCountLabel: UILabel!
    @IBOutlet weak private var container: UIView!
    @IBOutlet weak private var pageControl: UIPageControl!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userPhotoView.makeCircle()
        self.initialize()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(animateLike))
        doubleTap.numberOfTapsRequired = 2
        container.addGestureRecognizer(doubleTap)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initialize()
    }
    
    private func initialize() {
        self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.likeView.alpha = 0
        self.userPhotoView.image = nil
    }
    
    func updateLike(_ feed: Feed) {
        likeCountLabel.text = "좋아요 \(feed.likeCount)개"
    }
    
    @objc func animateLike() {
        if let feed = self.feed, feed.liked == false {
            self.viewModel?.toggleLike?(feed)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.likeView.alpha = 1
            self.likeView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.likeView.alpha = 0
                self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: nil)
        })
    }
    
    @IBAction func selectProfile() {
        guard let user = self.feed?.user else { return }
        self.viewModel?.goUserProfile?(user)
    }
}

extension FeedCell: MediaPlayable {
    func isPlayable(from superview: UIScrollView) -> Bool {
        let intersection = superview.bounds.intersection(self.frame)
        return intersection.height > self.frame.height * 0.7
    }
    
    func pause() {
        let cells = self.collectionView.visibleCells.compactMap{$0 as? MediaPlayable}
        cells.forEach{$0.pause()}
    }
    
    func resume() {
        let cell = self.collectionView.visibleCells.compactMap{$0 as? MediaPlayable}.first
        cell?.resume()
    }
}

extension FeedCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = index
        
        let cells = collectionView.visibleCells
        for cell in cells {
            if let cell = cell as? MediaPlayable {
                self.bounds.intersects(cell.bounds)
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells.compactMap{$0 as? MediaPlayable}
        
        for cell in cells {
            let intersection = collectionView.bounds.intersection(cell.frame)
            if intersection.width > collectionView.frame.width * 0.5 {
                cell.resume()
            } else {
                cell.pause()
            }
        }
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let media = feed?.medias[indexPath.item]
        
        if media?.type == .movie {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedMovieCell", for: indexPath) as! FeedMovieCell
            if let urlString = media?.url, let url = URL(string: urlString) {
                let item = AVPlayerItem(url: url)
                cell.player.replaceCurrentItem(with: item)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
            if let urlString = media?.url, let url = URL(string: urlString) {
                cell.url = url
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feed?.medias.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MediaPlayable {
            cell.pause()
        }
    }
}
