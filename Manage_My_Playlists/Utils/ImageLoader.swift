//
//  ImageLoader.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 10.01.2023.
//

import UIKit

class ImageLoader: ObservableObject {
    
    static let shared = ImageLoader() // Singleton instance of the ImageLoader class
    
    private init() {} // Private initializer to ensure that only one instance of ImageLoader can be created
    
    func setTheImage(url: String, title: String, onCompletion: @escaping (UIImage?) -> Void) {
        // Function to set the image for a given URL and title, with a completion handler
        
        // Get the path to the cache directory for the app
        guard let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent(url)
        let fileManager = FileManager.default
        
        // Check if the file already exists in the cache directory
        if fileManager.fileExists(atPath: fileURL.path()) {
            // If the file exists, load it from disk and pass it to the completion handler on the main thread
            print("FILE AVAILABLE")
            DispatchQueue.main.async() { [self] in
                onCompletion(loadImageFromDiskWith(fileName: url)!)
            }
        } else {
            // If the file doesn't exist, download it and save it to disk, then pass it to the completion handler on the main thread
            print("FILE NOT AVAILABLE")
            downloadImage(url: url) { image in
                onCompletion(image)
            }
        }
        
    }
    
    func setTheTrackImage(url: String) -> UIImage? {
        // Function to set the track image for a given URL
        
        // Get the path to the cache directory for the app
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(url)
        let fileManager = FileManager.default
        
        var image = UIImage()
        
        // Check if the file already exists in the cache directory
        if fileManager.fileExists(atPath: fileURL.path()) {
            // If the file exists, load it from disk and return it on the main thread
            print("FILE AVAILABLE")
            DispatchQueue.main.async() { [self] in
                image = loadImageFromDiskWith(fileName: url)!
            }
        } else {
            // If the file doesn't exist, download the default image and return it on the main thread
            print("FILE NOT AVAILABLE")
            downloadImage(url: url) { image1 in
                image = image1 ?? UIImage(named: "playlist_artwork_placeholder")!
            }
        }
        
        return image
    }
    
    func downloadImage(url: String, onCompletion: @escaping (UIImage?) -> Void) {
        // Function to download an image for a given URL, with a completion handler
        
        guard let imageUrl = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                onCompletion(UIImage(data: data))
            }
            self.saveImage(imageName: url, image: data)
            
        }.resume()
        
    }
    
    func saveImage(imageName: String, image: Data?) {
        // Function to save an image to the cache directory for the app
        
        // Get the path to the cache directory for the app
        guard let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            DispatchQueue.global(qos: .background).async {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path())
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }
            }
        }
       
        DispatchQueue.global(qos: .background).async {
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("error saving file with error", error)
            }
        }
    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        //function to load the image from the file directory
        
      let documentDirectory = FileManager.SearchPathDirectory.cachesDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        //Check if path exists return nil if it doesnt
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            var image: UIImage!
            image = UIImage(contentsOfFile: imageUrl.path())
            return image
        }

        return nil
    }
    
}
