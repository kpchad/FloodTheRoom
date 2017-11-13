//
//  ViewController.swift
//  FloodTheRoom
//
//  Created by Kyle Chadwick on 11/12/17.
//  Copyright © 2017 Kyle Chadwick. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var addWater: UIButton!
    @IBOutlet weak var subtractWater: UIButton!
    
    let configureation = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configureation.planeDetection = .horizontal
        self.sceneView.session.run(configureation)
        self.registerGuestureRecognizers()
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerGuestureRecognizers(){
        let tapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGuestureRecognizer)
    }

    @objc func tapped(sender: UITapGestureRecognizer){
        print("tap recognized")
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlane)
        if !hitTest.isEmpty{
            print("add sea floor")
            self.addSeaFloor(hitTestResult: hitTest.first!)
        }
    }
    
    func addSeaFloor(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "Models.scnassets/water.scn")
        let node = (scene?.rootNode.childNode(withName: "water", recursively: false))!
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        print(thirdColumn)
        node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        print(node.position)
        self.sceneView.scene.rootNode.addChildNode(node)
    }

}

