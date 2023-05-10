//
//  ViewController.swift
//  ImageGalleryApp
//
//  Created by Akshay Yendhe on 14/02/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var imgDetailList = [ImagesDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchData(){
        
        let url = URL(string: "https://api.unsplash.com/photos/?client_id=nyLCTvFK3GU9pyT9bU784NDsXSevO0V2Lf5oGDHetzk")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            
            guard let data = data , error == nil else {
                return
            }
            
            do{
                let object = try JSONSerialization.jsonObject(with: data)
                guard let dictArray = object as? [[AnyHashable : Any]] else {
                    return
                }
                //print(dictArray)
                for dict in dictArray {
                    let id = dict["id"] as! String
                    let createdDate = dict ["created_at"] as! String
                    let description = dict["alt_description"] as! String
                    let urls = dict["urls"] as! [AnyHashable : Any]
                    let smallImage = urls["small_s3"] as? String ?? ""
                    let largeImage = urls["full"] as? String ?? ""
                    let user = dict["user"] as! [AnyHashable : Any]
                    let name = user["name"] as? String ?? ""
                    let likes = dict["likes"] as! Int
                    let imgDetail = ImagesDetail(id: id, name: name, created_at: createdDate, alt_description: description, smallImageUrl: smallImage, fullImageUrl: largeImage, likes: likes)
                    //print(imgDetail)
                    //print(dict)
                    self.imgDetailList.append(imgDetail)
                }
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
                
            }
            catch let error {
                print("Error Data Not Found =\(error.localizedDescription)")
            }
        })
        task.resume()
    }


}

extension UIImageView{
    func downloadImg(url : URL){
        
        contentMode = .scaleToFill
        let imgTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            guard let httpUrlResp = response as? HTTPURLResponse, httpUrlResp.statusCode == 200, let imgType = response?.mimeType?.hasPrefix("image"), let data = data , error == nil, let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        })
        imgTask.resume()
    }
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDetailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell
        let obj = imgDetailList[indexPath.row]
        if let url = URL(string: obj.smallImageUrl) {
            cell.myImage.downloadImg(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageDetailsViewController") as! ImageDetailsViewController
        vc.selectedIndexPath = indexPath
        vc.imgDetailListA = imgDetailList
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = myCollectionView.bounds.width
        return CGSize(width: collectionWidth/2, height: collectionWidth/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
