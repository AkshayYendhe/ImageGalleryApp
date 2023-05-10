//
//  ImageDetailsViewController.swift
//  ImageGalleryApp
//
//  Created by Akshay Yendhe on 15/02/23.
//

import UIKit

class ImageDetailsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var imgDetailListA = [ImagesDetail]()
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var imageDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imageDetailCollectionView.reloadData()
        
        imageDetailCollectionView.scrollToItem(at: selectedIndexPath!, at: .left, animated: false)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imgDetailListA.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageDetailsCell = imageDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "imagedetailscell", for: indexPath) as! ImageDetailsCollectionViewCell
        let obj = imgDetailListA[indexPath.row]
        imageDetailsCell.UINameLabel.text = "Name :- \(obj.name)"
        imageDetailsCell.UICreatedAtLabel.text = "Created At :- \(obj.created_at)"
        imageDetailsCell.UIDescriptionLabel.text = "Description :- \(obj.alt_description)"
        imageDetailsCell.UILikesLabel.text = "Likes :- \(obj.likes)"
        if let url = URL(string: obj.fullImageUrl){
            imageDetailsCell.fullImageView.downloadImg(url: url)
        }
        
        return imageDetailsCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = imageDetailCollectionView.bounds.width
        let collectionHeight = imageDetailCollectionView.bounds.height
        return CGSize(width: collectionWidth, height: collectionHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
