//
//  ShareViewController.swift
//  Swift5Bokete1
//
//  Created by Fujii Yuta on 2019/07/11.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//画像で一言

import UIKit

class ShareViewController: UIViewController {
    //設計図使用
    var resultImage = UIImage()
    var commentString = String()
    var screenShotImage = UIImage()
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //持ってきたデータ使う
        resultImageView.image = resultImage
        commentLabel.text = commentString
        //フォントサイズ自動調整
        commentLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func share(_ sender: Any) {
        
        //スクリーンショットをとる
        takeScreenShot()
        //何でも入る配列に
        let items = [screenShotImage] as [Any]
        //アクティビティビューに乗っけて、シェアする
        //UIActivityViewController-アプリから標準サービスを提供するために使用するビューコントローラー,applicationActivities-2段目機能

        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        //押した機能に遷移
        present(activityVC, animated: true, completion: nil)
    }
    
    func takeScreenShot(){
        //サイズ調整 横ーそのまま、高さー１・３で割った数、UIGraphicsBeginImageContextWithOptionsー引数で図形のサイズや特徴などを指定、サイズ、透過、解像度
        let width = CGFloat(UIScreen.main.bounds.size.width)
        let height = CGFloat(UIScreen.main.bounds.size.height/1.3)
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //viewに書き出す、UIGraphicsEndImageContextー編集終了、drawHierarchyー画像描写、更新した時変更を反映するか、大きさ指定、UIGraphicsGetImageFromCurrentImageContextー編集したイメージを渡す
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func back(_ sender: Any) {
        //閉じる
        dismiss(animated: true, completion: nil)
    }
}
