//
//  ViewController.swift
//  SwiftFlickr
//
//  Created by Garrett Barker on 10/18/17.
//  Copyright © 2017 Garrett Barker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let apiKey = "1dd17dde0fed7286935d83875fcc17dd"
    
    var flickrResults = [AnyObject]()
    var selectedObject: Data? = nil
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var searchField: UITextField!
    
    @IBAction func searchButton(_ sender: Any) {
        mySearch(search: searchField.text!)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (flickrResults as AnyObject).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCollectionViewCell

        let item = flickrResults[indexPath.row]["farm"]
        let item1 = item as! NSNumber
        let item2 = item1.stringValue
        
        let myString = "https://farm" + item2 + ".staticflickr.com/" + ((flickrResults[indexPath.row]["server"]) as! String) + "/" + ((flickrResults[indexPath.row]["id"]) as! String) + "_" + ((flickrResults[indexPath.row]["secret"]) as! String) + ".jpg"
        
        let url = URL(string: myString)
        if(UIApplication.shared.canOpenURL(url!)){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    cell.myImageView?.image = UIImage(data: data!)
                    cell.imageName?.text = (self.flickrResults[indexPath.row]["title"]) as? String
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3 - 10, height: self.view.frame.size.width/3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = flickrResults[indexPath.row]["farm"]
        let item1 = item as! NSNumber
        let item2 = item1.stringValue
        
        let myString = "https://farm" + item2 + ".staticflickr.com/" + ((flickrResults[indexPath.row]["server"]) as! String) + "/" + ((flickrResults[indexPath.row]["id"]) as! String) + "_" + ((flickrResults[indexPath.row]["secret"]) as! String) + ".jpg"
        
        let url = URL(string: myString)
        if(UIApplication.shared.canOpenURL(url!)){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.selectedObject = data
                    self.performSegue(withIdentifier: "show", sender: nil)
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.myCollectionView.register(UINib(nibName: "myCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func searchFlickr(_ searchTerm:String) -> URL? {
        
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
        
        return url
    }
    
    func mySearch (search: String) -> Void{
        let url = searchFlickr(search)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
            print(json)
            
            let photos = json["photos"] as! Dictionary<String, Any>
            self.flickrResults = photos["photo"] as! [AnyObject]
            
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SecondViewController
        vc.myImageData = selectedObject
        selectedObject = nil
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

