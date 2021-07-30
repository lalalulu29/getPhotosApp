//
//  PresentViewController.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 26.07.2021.
//

import UIKit

class PresentViewController: UIViewController, NSUserActivityDelegate {
    
    var image: Data!
    var date: Int!
    
    @IBOutlet weak var bigPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureNavigationItemAndController()
        
        //Настройка dateFormatter для получения из ответа сетевого запроса дату необходимого вида
        let badDate = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        let goodDate = dateFormatter.string(from: badDate)
        navigationItem.title = "\(goodDate)"
        bigPhoto.image = UIImage(data: image)
        
        
    }
    
    func configureNavigationItemAndController()  {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(savePhoto))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    
    @objc private func savePhoto() {
        let photo = bigPhoto.image
        UIImageWriteToSavedPhotosAlbum(photo!, self, #selector(save), nil)
        
    }
    
    @objc func save(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var alert: UIAlertController
        
        if let _ = error {
            alert = ShowAlertWith("Ошибка сохранения изображения",
                                  message: "Возникла ошибка при сохранении изображения. Возможно было запрещено сохранение в библиотеку")
            
        } else {
            alert = ShowAlertWith("Сохранение прошло успешно",
                                  message: "Поздравляем, сохранение прошло успешно!")
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
