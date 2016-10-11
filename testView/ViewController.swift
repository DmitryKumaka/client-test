//
//  ViewController.swift
//  testView
//
//  Created by 1 on 08/10/16.
//  Copyright © 2016 dima. All rights reserved.
//

import UIKit
import CoreData



class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalView: UIScrollView!
    
    
    let poster1 = UIImage(named: "Tmp-poster-1")
    let poster2 = UIImage(named: "Tmp-poster-2")
    let album1 = UIImage(named: "Tmp-album-1")
    let album2 = UIImage(named: "Tmp-album-2")

    var postersArray = [UIImage!]()
    var albumsArray = [UIImage!]()

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchPostersRequest: NSFetchRequest<Posters> = Posters.fetchRequest()
    let fetchAlbumsRequest: NSFetchRequest<Album> = Album.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        deleteImages()
        setImage(image: poster1!, entityName: "Posters")
        setImage(image: poster2!, entityName: "Posters")
        setImage(image: album1!, entityName: "Album")
        setImage(image: album2!, entityName: "Album")
        
        getResult(entity: "Posters")
        getResult(entity: "Album")
        
        setMain()
        setWindow()
        setPosters()
        setAlbums()
        setLight()
        setStick()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

    func setMain() {
        
        let imageMain = UIImage(named: "Main.jpg")
        
        let imageView = UIImageView(image: imageMain)
        let imageWidth = self.view.frame.width
        let imageHeigth: CGFloat = 3500
        
        imageView.frame.size.width = imageWidth
        imageView.frame.size.height = imageHeigth
        
        scrollView.contentSize.height = imageHeigth
        scrollView.addSubview(imageView)

    }
    
    func setWindow() {
        
        let windowImage = UIImage(named: "News-wood")
        let windowView = UIImageView(image: windowImage)
        
        windowView.frame = CGRect(x: 0, y: 370, width: self.view.frame.width, height: 300)
        scrollView.addSubview(windowView)
    }
    
    func setPosters() {
        
        var posterView: UIImageView!
                
        horizontalView.contentSize.height = 252
        horizontalView.frame = CGRect(x: 0, y: 392, width: 375, height: 252)
        var xButtonPosition = 40

        for i in 0..<postersArray.count {
            
            posterView = UIImageView(image: postersArray[i])
            
            let xPosition = 300 * i
            
            let btn: UIButton = UIButton(frame: CGRect(x: xButtonPosition, y: 15, width: 200, height: 230))
            btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            btn.tag = i
            
            posterView.frame = CGRect(x: xPosition, y: 0, width: 300, height: 252)
            
            horizontalView.contentSize.width = posterView.frame.width * CGFloat(i + 1)
            
            horizontalView.addSubview(posterView)
            horizontalView.addSubview(btn)
            xButtonPosition += 300
        }

        scrollView.addSubview(horizontalView)
    }
    
    func buttonAction(button: UIButton!) {
        self.performSegue(withIdentifier: "segue", sender: button)
    }
    
    func setAlbums() {
    
        var albumView: UIImageView!
        var xx = 26
        
        for i in 0..<albumsArray.count {
        
            albumView = UIImageView(image: albumsArray[i])
            albumView.frame = CGRect(x: xx, y: 3095, width: 120, height: 160)
            scrollView.addSubview(albumView)
            xx += 161
        }
    }
    
    func setLight() {
    
        let lightImage = UIImage(named: "Light")
        let lightView = UIImageView(image: lightImage)
        
        lightView.frame = CGRect(x: 205, y: 2846, width: 35, height: 35)
        lightView.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .repeat, animations: {
            
            lightView.alpha = 1
            
            }, completion: nil)
        scrollView.addSubview(lightView)
    }
    
    func setStick() {
    
        let stickImage = UIImage(named: "Stick")
        let stickView = UIImageView(image: stickImage)
        stickView.frame = CGRect(x: 80, y: 2670, width: 130, height: 130)
    
        UIView.animate(withDuration: 1.8, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            stickView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/20) )
            stickView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/20) )



            }, completion: nil)

        scrollView.addSubview(stickView)

    }
    
    func setImage(image: UIImage, entityName: String) {
        
        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let posters = NSManagedObject(entity: entity!, insertInto: context)
        
        posters.setValue(imageData, forKey: "image")

    }
    
    
    func getResult(entity: String) {
        if entity == "Posters" {
            do {
                let searchResults = try context.fetch(fetchPostersRequest)
                if searchResults.count > 0 {
                    for i in 0..<searchResults.count {
                        let match = searchResults[i] as NSManagedObject
                        let image = match.value(forKey: "image") as! NSData
                        postersArray.append(UIImage(data: image as Data)!)
                    }
                }
                
            } catch {
                print("Error with request: \(error)")
            }
        } else if entity == "Album" {
            do {
                let searchResults = try context.fetch(fetchAlbumsRequest)
                if searchResults.count > 0 {
                    for i in 0..<searchResults.count {
                        let match = searchResults[i] as NSManagedObject
                        let image = match.value(forKey: "image") as! NSData
                        albumsArray.append(UIImage(data: image as Data)!)
                    }
                }
                
            } catch {
                print("Error with request: \(error)")
            }
        }

    }
    
    
    func deleteImages() {
        
        do {
            postersArray.removeAll()
            albumsArray.removeAll()
            
            let postersResults = try context.fetch(fetchPostersRequest)
            let albumsResults = try context.fetch(fetchAlbumsRequest)
            removeFromeStore(sender: postersResults as AnyObject)
            removeFromeStore(sender: albumsResults as AnyObject)
    
        } catch {
            print("Error with request: \(error)")
        }

        
    }
    
    func removeFromeStore(sender: AnyObject) {
    
        for i in 0..<sender.count {
            
            let item = sender[i] as! NSManagedObject
            
            context.delete(item)
            
            do {
                
                try self.context.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            
            if let numberOfPoster = (sender as? UIButton) {
                let postersController = segue.destination as! PostersViewController
                postersController.numberOfPoster = numberOfPoster.tag
            }
            
        }
    }

}

