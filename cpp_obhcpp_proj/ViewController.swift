//
//  ViewController.swift
//  cpp_obhcpp_proj
//
//  Created by Flynn on 10/20/17.
//  Copyright © 2017 Flynn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let OCPPObject = MyOCPPClass()
        let MyObj = NewDecoderWrapper()
        MyObj.loadMesh()
        print("Time for C++ stuff")
//        print(OCPPObject.printHelloWorldFromCPP())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

