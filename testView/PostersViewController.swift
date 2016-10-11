//
//  PostersViewController.swift
//  testView
//
//  Created by 1 on 11/10/16.
//  Copyright © 2016 dima. All rights reserved.
//

import UIKit
import CoreData

class PostersViewController: UIViewController {

    @IBOutlet weak var postersView: UIScrollView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchPostersRequest: NSFetchRequest<Posters> = Posters.fetchRequest()
    
    var postersArray = [UIImage!]()
    
    var numberOfPoster: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getResult()
        setPostersView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getResult() {

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
    }
    
    func setPostersView() {
    
        var postersImageView: UIImageView!
        
        postersView.contentSize.height = 380
        postersView.frame = CGRect(x: 0, y: 121, width: 375, height: 380)
        for i in 0..<postersArray.count {
            
            postersImageView = UIImageView(image: postersArray[i])
            
            let xPosition = Int(postersView.frame.width) * i
            
            postersImageView.frame = CGRect(x: xPosition, y: 0, width: Int(postersView.frame.width), height: 380)
            
            if numberOfPoster != nil {
                postersView.bounds.origin.x = postersView.frame.width * CGFloat(numberOfPoster!)
            }
            postersView.contentSize.width = postersImageView.frame.width * CGFloat(i + 1)

            postersView.addSubview(postersImageView)
        }
    }

   
}
