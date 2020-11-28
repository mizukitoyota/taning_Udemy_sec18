//
//  ViewController.swift
//  Swift5Bokete1
//
//  Created by Fujii Yuta on 2019/07/11.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var odaiImageView: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    
    @IBOutlet weak var searchTextField: UITextField!
 
    var count = 0
    
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        commentTextView.layer.cornerRadius = 20.0
        
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
                case .authorized: break
                case .denied: break
                case .notDetermined: break
                case .restricted: break
                
            }
        }
        
        
        DispatchQueue.global().async {
                
            self.getImages(keyword: "funny")
            
            DispatchQueue.main.async {
                
                self.indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                self.indicator.center = self.view.center
                self.indicator.hidesWhenStopped = true
                self.indicator.style = .large
                self.view.addSubview(self.indicator)
                self.indicator.startAnimating()
                
            }
        }
        

        
    
    }

    //検索キーワードの値を元に画像を引っ張ってくる
    //pixabay.com
  
    func getImages(keyword:String){
        
        
        //APIKEY 2963093-768f9ffc11d874c5a568a82ee
        
        let url = "https://pixabay.com/api/?key=2963093-768f9ffc11d874c5a568a82ee&q=\(keyword)"
        
        //Alamofireを使ってhttpリクエストを投げます。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result{
                
            case .success:

                self.indicator.stopAnimating()
                
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                
                
                if imageString == nil{
                    
                    imageString = json["hits"][0]["webformatURL"].string
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                    
                    
                }else{
                    
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)

                }
                
                
                
            case .failure(let error):
                
                    print(error)
                
                
            }
            
        }
    }
    
    
    
    @IBAction func nextOdai(_ sender: Any) {
        
        count = count + 1
        
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
            
        }else{
            
            
            DispatchQueue.global().async{
              
                DispatchQueue.main.async{
                    self.getImages(keyword: self.searchTextField.text!)
                    self.indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    self.indicator.center = self.view.center
                    self.indicator.hidesWhenStopped = true
                    self.indicator.style = .large
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                
                }
            }

                                   
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        searchTextField.resignFirstResponder()
        
    }
    

    @IBAction func searchAction(_ sender: Any) {
        
        self.count = 0
        if searchTextField.text == ""{
            
            getImages(keyword: "funny")
            
        }else{
            
            getImages(keyword: searchTextField.text!)
            
        }
        
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
        
        
    }
    
    
}

