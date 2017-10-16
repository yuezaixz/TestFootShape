//
//  Plane.swift
//  FirstARProject
//
//  Created by 吴迪玮 on 2017/8/14.
//  Copyright © 2017年 DNT. All rights reserved.
//

import UIKit
import ARKit

class FootShape: SCNNode {
    
    var planeGeometry:SCNPlane!
    var anchor: ARPlaneAnchor!
    
    var footImage: UIImage!
    
    init(isLeft:Bool, withAnchor anchor:ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        if isLeft {
            footImage = UIImage(named: "left_foot")
        } else {
            footImage = UIImage(named: "right_foot")
        }
        self.setup(x: anchor.center.x, y: 0, z: anchor.center.z)
    }
    
    init(isLeft:Bool, withNode node:SCNNode) {
        super.init()
        if isLeft {
            footImage = UIImage(named: "left_foot")
        } else {
            footImage = UIImage(named: "right_foot")
        }
        self.setup(x: node.position.x, y: node.position.y, z: node.position.z)
    }
    
    func setup(x:Float, y:Float, z:Float) {
        // 用 ARPlaneAnchor 实例中的尺寸来创建 3D 平面几何体
        
        planeGeometry = SCNPlane(width: CGFloat(0.12), height: CGFloat(0.28))
        
        // 相比把网格视觉化为灰色平面，我更喜欢用科幻风的颜色来渲染
        let material = SCNMaterial()
        material.diffuse.contents = footImage
        material.lightingModel = .physicallyBased
        planeGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(x, y, z)
        planeNode.physicsBody = SCNPhysicsBody ( type : .static ,
                                                 shape: SCNPhysicsShape(geometry:self.planeGeometry ,options:[:])
        )
        
        // SceneKit 里的平面默认是垂直的，所以需要旋转90度来匹配 ARKit 中的平面
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi / 2.0), 1.0, 0.0, 0.0)
        
        //        setTextureScale()
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextureScale() {
        let width = planeGeometry.width
        let height = planeGeometry.height
        
        // 平面的宽度/高度 width/height 更新时，我希望 tron grid material 覆盖整个平面，不断重复纹理。
        // 但如果网格小于 1 个单位，我不希望纹理挤在一起，所以这种情况下通过缩放更新纹理坐标并裁剪纹理
        let material = planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
    
}

