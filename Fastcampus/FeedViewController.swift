//
//  ViewController.swift
//  Fastagram
//
//  Created by donghyun on 2021/06/06.
//

import UIKit
import AlamofireImage

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}

class FeedItemCell: UICollectionViewCell {
    var url: URL! {
        didSet {
            imageView.setImage(url: url)
        }
    }
    
    @IBOutlet weak private var imageView: UIImageView!
}

class FeedCell: UITableViewCell {
    var feed: Feed? {
        didSet {
            if let profileImageURL = feed?.user.profileImageURL, let url = URL(string: profileImageURL) {
                userPhotoView.setImage(url: url)
            } else {
                userPhotoView.image = nil
            }
            userNameLabel.text = feed?.user.name
            collectionView.reloadData()
        }
    }
    
    var loading = false
    
    @IBOutlet weak private var userPhotoView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak private var likeView: UIView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var likeCountLabel: UILabel!
    @IBOutlet weak private var replyLabel: UILabel!
    @IBOutlet weak private var container: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.likeView.alpha = 0
        self.userPhotoView.makeCircle()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(animateLike))
        doubleTap.numberOfTapsRequired = 2
        container.addGestureRecognizer(doubleTap)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.likeView.alpha = 0
    }
    
    @objc func animateLike() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.likeView.alpha = 1
            self.likeView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.likeView.alpha = 0
                self.likeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                
            })
        })
    }
}

extension FeedCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedItemCell", for: indexPath) as! FeedItemCell
                
//        cell.url = URL(string: images[indexPath.item])!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
}

class FeedViewController: UIViewController {
    private let limit = 50
    private var feeds: [Feed] = []
    private var isLoadingContents = false
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.setupRefreshControl()
        self.initialize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "User", let indexPath = sender as? IndexPath {
            let controller = segue.destination as? UserViewController
            let user = feeds[indexPath.row].user
            
            controller?.user = user
        }
    }
    
    @objc private func initialize() {
        loadContents(reset: true)
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(initialize), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc private func loadContents(reset: Bool = false) {
        loadingIndicator.startAnimating()
        
        fetchMoreContent(completion: { [weak self] feeds in
            guard let weakself = self else { return }
            
            if reset {
                self?.feeds = feeds
            } else {
                self?.feeds.append(contentsOf: feeds)
            }
            
            if weakself.limit <= weakself.feeds.count {
                self?.tableView.tableFooterView?.frame = .zero
            } else {
                self?.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: weakself.tableView.frame.width, height: 44)
            }
            
            self?.tableView.reloadData()
            self?.isLoadingContents = false
            self?.loadingIndicator.stopAnimating()
            self?.tableView.refreshControl?.endRefreshing()
        })
    }
    
    private func fetchMoreContent(completion: @escaping (([Feed]) -> ())) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let feeds = (1...20).map{_ in Feed.createRandom()}
            completion(feeds)
        })
    }
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let feed = feeds[indexPath.row]
        
        cell.feed = feed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "User", sender: indexPath)
    }
}

extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldLoadMore = scrollView.contentOffset.y + scrollView.frame.height - 30 > scrollView.contentSize.height
        let haveMoreContents = feeds.count < limit
        
        if shouldLoadMore && haveMoreContents && isLoadingContents == false {
            isLoadingContents = true
            loadContents(reset: false)
        }
    }
}
