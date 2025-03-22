//
//  SceneDelegate.swift
//  CameraFilter
//
//  Created by 김기영 on 3/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let cameraManager = CameraManager()
        let imageFilter = ImageFilter()
        let cameraBottomView = CameraBottomView()
        let cameraViewModel = CameraViewModel(cameraManager: cameraManager, imageFilter: imageFilter)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = CameraViewController(
            cameraBottomView: cameraBottomView,
            cameraViewModel: cameraViewModel
        )
        window?.makeKeyAndVisible()
    }
}

