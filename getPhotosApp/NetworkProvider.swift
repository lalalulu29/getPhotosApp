//
//  NetworkProvider.swift
//  getPhotosApp
//
//  Created by Кирилл Любарских  on 25.07.2021.
//

import Foundation


class NetworkProvider {
    
    let session = URLSession.shared
    
    
    func checkValidToken(token: String, result: @escaping (Bool, photoStruct?)->()){
        let url = URL(string:"https://api.vk.com/method/photos.get?owner_id=-128666765&album_id=266276915&access_token=\(token)&v=5.131")!
        
        session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                result(false, nil)
                return}
            do {
                let infoFromDate = try JSONDecoder().decode(photoStruct.self, from: data)
                result(true, infoFromDate)
            } catch {
                result(false, nil)
            }
        }.resume()
        
        
    }
    func downloadPhoto(stringUrl: String, indexCell: Int, result: @escaping (Bool)->()) {
        guard let url = URL(string: stringUrl) else {return}
        session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                result(false)
                return
            }
            PhotoImage[indexCell] = data
            result(true)
            
        }.resume()
    }
}
