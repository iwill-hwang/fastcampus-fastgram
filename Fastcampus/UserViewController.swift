//
//  UserViewController.swift
//  Fastagram
//
//  Created by donghyun on 2021/06/06.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(url: URL) {
        self.af.setImage(withURL: url, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
    }
}
class UserProfileCell: UICollectionReusableView {
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageURL, let url = URL(string: profileImageUrl) else {
                photoView.image = nil
                nameLabel.text = "-"
                return
            }
            
            photoView.setImage(url: url)
            nameLabel.text = user?.name
        }
    }
    
    @IBOutlet weak private var photoView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoView.makeCircle()
    }
}


class UserFeedCell: UICollectionViewCell {
    var profileImage: String? {
        didSet {
            if let profileImage = profileImage, let url = URL(string: profileImage) {
                self.photoView.setImage(url: url)
            } else {
                self.photoView.image = nil
            }
        }
    }
    
    @IBOutlet weak private var photoView: UIImageView!
}

class UserViewController: UIViewController {
    var user: User?
    
    let images = [
        "https://images.unsplash.com/photo-1550354520-86a81c515d44?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80",
        "https://images.unsplash.com/photo-1622868685547-88562982d7d6?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60",
        "https://images.unsplash.com/photo-1622502887577-5a321783c8ae?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1532&q=80",
        "https://images.unsplash.com/photo-1622976245837-2d862662f04d?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60",
        "https://images.unsplash.com/photo-1622976383598-63a52ddd77be?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzM3x8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60"
    ].shuffled()
    
}

extension UserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        user?.feeds.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFeedCell", for: indexPath) as! UserFeedCell
        cell.profileImage = user?.profileImageURL
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
        view.user = user
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 2) / 3
        return CGSize(width: size, height: size)
    }
}
