//
//  ViewController.swift
//  PlayGIFPicture
//
//  Created by kris on 2023/1/8.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playGifPicture()
    }

    func playGifPicture() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: view.frame.self.width, height: 400))
        view.addSubview(imageView)
        
        //1、加载GIF图片，并转成data类型
        guard let path = Bundle.main.path(forResource: "star.gif", ofType: nil) else { return }
        guard let data = NSData(contentsOfFile: path) else { return }
        
        //2、从data中读取数据：将data转成
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        //3、遍历所有图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<imageCount {
            //3.1、取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue}
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            //3.2、取出持续时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
            
        }
        
        //4、设置imageView属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0
        
        //5、开始播放
        imageView.startAnimating()
        
    }

}

