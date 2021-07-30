//
//  PhotoViewController.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 25.07.2021.
//

import UIKit
var Photo: photoStruct?
var PhotoImage: [Int: Data] = [:]

class PhotoViewController: UIViewController {

    let networkProvider = NetworkProvider()
    let userDefaults = UserDefaults.standard
    
    
    var photoList = Photo?.response.items ?? []
    @IBOutlet weak var photoCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        if Photo == nil {

            let token = userDefaults.string(forKey: "token")
            networkProvider.checkValidToken(token: token!) {[weak self] bool, result in
                if bool {
                    Photo = result
                    
                    self?.photoList = (Photo?.response.items)!
                    DispatchQueue.main.async {
                        self!.photoCollection.reloadData()
                    }
                    
                }
            }
        }
        
    }
    func configureNavigationItem() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выход",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(goToAuthView))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    //MARK: - Метод, стирающий из userDefaults токен и выбрасывадщий на окно авторизации
    @objc func goToAuthView() {
        userDefaults.removeObject(forKey: "token")
        DispatchQueue.main.async {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyBoard.instantiateViewController(identifier: "authView")
            self.dismiss(animated: true, completion: nil)
            self.present(view, animated: true)
            
        }
        
        
        
    }
    deinit {
        print("view was deinit")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPresent" {
            let DVC = segue.destination as! PresentViewController
            guard let selectedRow = photoCollection.indexPathsForSelectedItems!.first else {return}

            let image = PhotoImage[selectedRow.row]
            DVC.image = image
            DVC.date = Photo?.response.items[selectedRow.row].date
        }
        
    }


}
//MARK: - Реализация методов протоколов UICollectionViewDataSource и UICollectionViewDelegate
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "photoCell",
                                                       for: indexPath) as! PhotoCollectionViewCell
        
        let numberPhoto = photoList[indexPath.row]
        
        networkProvider.downloadPhoto(stringUrl: numberPhoto.sizes.last!.url,
                                      indexCell: indexPath.row) {bool in

            if bool {
                DispatchQueue.main.async {
                    cell.photoInCell.image = UIImage(data: PhotoImage[indexPath.row]!)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - 2) / 2
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPresent", sender: nil)
    }
    
    
}
