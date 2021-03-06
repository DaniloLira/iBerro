//
//  MusicAPI.swift
//  iBerro
//
//  Created by Jéssica Amaral on 13/07/21.
//

import Foundation
import StoreKit

class MusicAPI {
    let devToken = "COLOCAR O DEVELOPER TOKEN AQUI"
    func getUserToken() -> String {
        var userToken: String = ""
        let lock = DispatchSemaphore(value: 0)
        
        SKCloudServiceController().requestUserToken(forDeveloperToken: devToken) { (token, error)  in
            guard error == nil else {
                return
            }
            
            if let newToken = token {
                userToken = newToken
                lock.signal()
            } else {
                print("Não pegou user token")
                lock.signal()
            }
        }
        
        lock.wait()
        return userToken
    }
    
    func searchMusic(_ filter: String, turn: Int, playersCount: Int) -> [Song] {
        //"trava" a thread até que um sinal seja dado (um gatilho precisa ser ativado para continuar rodando a thread)
        let lock = DispatchSemaphore(value: 0)
        var songs = [Song]()
        
        let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/br/search?term=\(filter.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25&offset=\(turn)")!
        
        var request = URLRequest(url: musicURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(devToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            if let json = try? JSON(data: data!) {
                print (json)
                var songList = (json["results"]["songs"]["data"]).array ?? []
                
                var roundSongList: [JSON] = []
                
                for i in 1...playersCount {
                    
                    let index = i
                    let song = songList[index]
                    let songInfos = song["attributes"]
                    let songPreviews = songInfos["previews"].array!
                    let newSong = Song(id: songInfos["playParams"]["id"].string!, hasLyrics: songInfos["hasLyrics"].bool!, previewURL: songPreviews[0]["url"].string!, lyrics: "")
                    
                    songs.append(newSong)
                    songList.remove(at: index)
                    roundSongList.append(song)
                }
                
                lock.signal()
                
            } else {
                lock.signal()
            }
        }.resume()
        
        lock.wait()
        
        return songs
    }
}
