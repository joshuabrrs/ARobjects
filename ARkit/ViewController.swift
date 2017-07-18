//
//  ViewController.swift
//
//  Created by Joshua Barrios on 7/17/17.
//  Copyright © 2017 Joshua Barrios. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


@available(iOS 11.0, *)
class ViewController: UIViewController {
    
    @IBOutlet var sceneview: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneview.session.run(configuration)
    }
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }

    @IBAction func addObj1(_ sender: Any) {
        //let zCoords = randomFloat(min: -2, max: -0.2)
        
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        //cubeNode.position = SCNVector3(0,0,zCoords)
        let cc = getCameraCoordinates(sceneview: sceneview)
        cubeNode.position = SCNVector3 (cc.x, cc.y, cc.z)
        sceneview.scene.rootNode.addChildNode(cubeNode)
    }
    @IBAction func addObj2(_ sender: Any) {
        let vaseNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneview: sceneview)
        vaseNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "vase.scn", inDirectory: "Models.scnassets/vase")
            else {
                return
    }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        vaseNode.addChildNode(wrapperNode)
        sceneview.scene.rootNode.addChildNode(vaseNode)
    }
        
    struct myCamCoordinates{
        var x = Float()
        var y = Float()
        var z = Float()
    }
    func getCameraCoordinates(sceneview: ARSCNView) -> myCamCoordinates{
        let cameraTransform = sceneview.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCamCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

