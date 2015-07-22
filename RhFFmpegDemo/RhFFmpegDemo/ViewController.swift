//
//  ViewController.swift
//  RhFFmpegDemo
//
//  Created by sun on 15/7/22.
//  Copyright (c) 2015年 sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        av_register_all();
        let a = UIView();
        
        let ctx:AVFormatContext
        avformat_open_input(ctx, "file_name", 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

