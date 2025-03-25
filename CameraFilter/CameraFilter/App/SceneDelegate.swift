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
        
        let imageFilter = ImageFilterManager()
        let cameraManager = CameraManager(imageFilterManager: imageFilter)
        let cameraBottomView = CameraBottomView()
        let cameraViewModel = CameraViewModel(cameraManager: cameraManager)
        let photoViewModel = PhotoViewModel(cameraManager: cameraManager)
        let cameraViewController = CameraViewController(
            cameraBottomView: cameraBottomView,
            cameraViewModel: cameraViewModel,
            photoViewModel: photoViewModel
        )
        let navigationViewController = UINavigationController(rootViewController: cameraViewController)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }
}

