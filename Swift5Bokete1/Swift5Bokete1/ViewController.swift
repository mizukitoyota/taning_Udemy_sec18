//
//  ViewController.swift
//  Swift5Bokete1
//
//  Created by Fujii Yuta on 2019/07/11.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//検索画面
//API-ソフトウェアの機能を共有できる仕組み

import UIKit
//HTTPリクエスト
import Alamofire
//（ユーザー情報の保存）JSONファイル解析
import SwiftyJSON
//Web上の画像をダウンロードして使う
import SDWebImage
//写真ライブラリのアルバム内に画像を保存する
import Photos

class ViewController: UIViewController {
    //image
    @IBOutlet weak var odaiImageView: UIImageView!
    //ボケ
    @IBOutlet weak var commentTextView: UITextView!
    //お題さがし
    @IBOutlet weak var searchTextField: UITextField!
    //調べた写真の順番
    var count = 0
    //UIActivityIndicatorView-処理中である、または待機中である事を示すビュー　待機中
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //角丸
        commentTextView.layer.cornerRadius = 20.0
        //requestAuthorizationー通知許可表示
        PHPhotoLibrary.requestAuthorization { (status) in
            //フォトライブラリへのアクセスについて
            switch(status){
            //許可
            case .authorized: break
            //拒否
            case .denied: break
            //決まってない
            case .notDetermined: break
            //制限
            case .restricted: break
            }
        }
        //処理待ちタスク追加、並列処理、非同期追加
        DispatchQueue.global().async {
            //最初はfunny画像
            self.getImages(keyword: "funny")
            DispatchQueue.main.async {
                self.indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                self.indicator.center = self.view.center
                //hidesWhenStopped-アニメーションが止まっている時の表示の設定
                self.indicator.hidesWhenStopped = true
                //style-サイズ（白）
                self.indicator.style = .large
                //addSubview-UIViewに別のUIViewを追加
                self.view.addSubview(self.indicator)
                //startAnimating-アニメーションを開始させる
                self.indicator.startAnimating()
            }
        }
    }
    
    //検索キーワードの値を元に画像を引っ張ってくる
    //pixabay.com
    func getImages(keyword:String){
        //APIKEY 2963093-768f9ffc11d874c5a568a82ee
        let url = "https://pixabay.com/api/?key=2963093-768f9ffc11d874c5a568a82ee&q=\(keyword)"
        //responseJSONーAPIサーバーとの通信処理
        //Alamofireを使ってhttpリクエストを投げます。getでリクエストを投げる（URL形式）、responseが返ってくる
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            //通信結果
            switch response.result{
            case .success:
                
                self.indicator.stopAnimating()
                //キャスト
                let json:JSON = JSON(response.data as Any)
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    //ライブラリ内の一番目のURLゲット
                    imageString = json["hits"][0]["webformatURL"].string
                    //画像のURLから画像を引っ張って来て、imageViewにセット、値はあるかわからない！
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }else{
                    //範囲内、そのままセット
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
            //失敗
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //次のお題
    @IBAction func nextOdai(_ sender: Any) {
        //調べた写真の次
        count = count + 1
        //空ならファニー
        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }else{
            DispatchQueue.global().async{
                //直列処理、非同期追加
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
    //タッチが始まったら呼ばれる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //resignFirstResponderーキーボードが非表示
        searchTextField.resignFirstResponder()
    }
    //検索
    @IBAction func searchAction(_ sender: Any) {
        //カウントゼロ戻し
        self.count = 0
        if searchTextField.text == ""{
            getImages(keyword: "funny")
        }else{
            getImages(keyword: searchTextField.text!)
        }
    }
    //決定
    @IBAction func next(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "next", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segueの識別子確認、遷移先
        let shareVC = segue.destination as? ShareViewController
        //テキスト、イメージを遷移画面へ送る
        shareVC?.commentString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
}

