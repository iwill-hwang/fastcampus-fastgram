//
//  ViewController.swift
//  Fastagram
//
//  Created by donghyun on 2021/06/06.
//

import UIKit

protocol MediaPlayable: UIView {
    func isPlayable(from superview: UIScrollView) -> Bool
    func resume()
    func pause()
}

extension MediaPlayable {
    func togglePlay(from superview: UIScrollView) {
        if isPlayable(from: superview) {
            self.resume()
        } else {
            self.pause()
        }
    }
}

class FeedViewModel {
    var goUserProfile: ((User) -> Void)? = nil
    var toggleLike: ((Feed) -> Void)? = nil
}

class FeedViewController: UIViewController {
    private let limit = 50
    private let viewModel = FeedViewModel()
    
    private var feeds: [Feed] = []
    private var isLoadingContents = false
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.setupRefreshControl()
        self.initialize()
        
        self.viewModel.goUserProfile = { [weak self] user in
            self?.performSegue(withIdentifier: "User", sender: user)
        }
        
        self.viewModel.toggleLike = { [weak self] feed in
            guard let weakself = self else { return }
            guard let index = self?.feeds.firstIndex(where: {$0.id == feed.id}) else { return }
            
            var feed = weakself.feeds[index]
            let liked = feed.liked == false
            let count = feed.likeCount + (liked ? 1 : -1)
            
            feed.liked = liked
            feed.likeCount = count
            
            weakself.feeds[index] = feed
            
            if let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FeedCell {
                cell.updateLike(feed)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "User", let user = sender as? User {
            let controller = segue.destination as? UserViewController
            
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
            
            if reset {
                self?.playMovieIfNeeded()
            }
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
        
        cell.viewModel = viewModel
        cell.feed = feed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func playMovieIfNeeded() {
        var alreadyPlaying = false
        
        self.tableView.visibleCells.compactMap{$0 as? MediaPlayable}.forEach{
            let isPlayable = $0.isPlayable(from: self.tableView)
            if alreadyPlaying == false && isPlayable {
                $0.resume()
                alreadyPlaying = true
            } else {
                $0.pause()
            }
        }
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
        
        self.playMovieIfNeeded()
    }
}
