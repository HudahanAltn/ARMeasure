//
//  ViewController.swift
//  ARMeasure
//
//  Created by Hüdahan Altun on 2.03.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes:[SCNNode] = [SCNNode] ()
    
    var textNode:SCNNode = SCNNode ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView){
            
            
            let hitTestResult = sceneView.hitTest(touchLocation, types:.featurePoint)
            
            if let hitResult = hitTestResult.first{
                print("touchhed")
                addDot(at: hitResult)
            }
        }
    }

}

extension ViewController{
    
    func addDot(at hitResult:ARHitTestResult){
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                      y: hitResult.worldTransform.columns.3.y,
                                      z: hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        dotNodes.append(dotNode)
        
        if dotNodes.count == 2{ // if there are two dot then you can calculate
            
            calculate()
        }else if dotNodes.count < 2{//if there are less than two dots ,wait
            
            return
        }else{// if there are more than 2 dots clear all and start again
            
            removeAll()
        }
        
    }
    
    
    func removeAll(){// when tried to create more than  two nodes ,everything will be removed.
        
        for dot in dotNodes{// dots will removed
            
            dot.removeFromParentNode()
        }
        dotNodes.removeAll()
        
        textNode.removeFromParentNode()// text will removed
    }
    
    func calculate(){//3D dimension calculation
        
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        // distance = √ ( (X2 - X1)^2 + (Y2 - Y1)^2 + (Z2 - Z1)^2 )
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        
        print( "result \(abs(distance))")
        
        print("calculating")
        
        showTextOnScreen(text: String(abs(distance)),at: end.position)
        
    }
    
    func showTextOnScreen(text:String, at position : SCNVector3){//distance text
        
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(x: position.x, y: position.y + 0.01, z: position.z)
        
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
        
    }
    
   
}


