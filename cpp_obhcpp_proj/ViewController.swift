//
//  ViewController.swift
//  cpp_obhcpp_proj
//
//  Created by Flynn on 10/20/17.
//  Copyright © 2017 Flynn. All rights reserved.
//

import UIKit
import SceneKit.ModelIO
import ModelIO

class ViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Lets first copy a .drc file from bundle to temp")
        let my_url = copyBundleResourceToTemporaryDirectory(resourceName: "out", fileExtension: "drc")
        print("Time for C++ stuff")
        let instanceOfCustomObject: NewDecoderWrapper = NewDecoderWrapper()
        print("Setting object with INPUT URL... " + (my_url?.path)!)
        instanceOfCustomObject.someProperty = (my_url?.path)!
        let targetURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("out" + "." + "obj")
        print("Setting object with OUTPUT URL... " + (targetURL.path))
        instanceOfCustomObject.somePropertyOut = targetURL.path
        instanceOfCustomObject.loadMesh()
        setupView()
        setupScene(downloadedFilePath: targetURL)
        setupCamera()

        
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.backgroundColor = UIColor.red
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene(downloadedFilePath: URL) {
        print("Attempting to attach downloaded model to scene...")
        print("File path... " + downloadedFilePath.absoluteString)
        
        print("Loading scene...")
        
        scnScene = SCNScene()
        
        scnView.scene = scnScene
        print("Loading/adding model to scene")
        let start = DispatchTime.now()
        let asset = MDLAsset(url: downloadedFilePath)
        let object = asset.object(at:0)
        
        let node = SCNNode(mdlObject: object)
        scnScene.rootNode.addChildNode(node)
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("Done loading/adding model to scene and it tooks us " + timeInterval.description)
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func copyBundleResourceToTemporaryDirectory(resourceName: String, fileExtension: String) -> URL?
    {
//        // Get the file path in the bundle
//        print(URL(forResource: resourceName, withExtension: fileExtension))
        print("Copying drc file to...\n")
        print(Bundle.main.url(forResource: "out", withExtension: "drc")!.absoluteString + "\n")
        if let bundleURL = Bundle.main.url(forResource: "out", withExtension: "drc") {
            // Create a destination URL.
            print("Looking for file at " + bundleURL.absoluteString)
            let targetURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(resourceName + "." + fileExtension)
            print("Copying to " + targetURL.absoluteString)
            // Copy the file.
            do {
                try FileManager.default.copyItem(at: bundleURL, to: targetURL)
                return targetURL
            } catch let error {
                NSLog("Unable to copy file: \(error)")
                return targetURL
            }
        }
        
        return nil
    }


}

