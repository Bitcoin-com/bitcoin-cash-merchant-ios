//
//  ScannerViewController.swift
//  SLPWalletDemo
//
//  Created by Angel Mortega on 2019/03/20.
//  Contributors Jean-Baptiste Dominguez.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import Lottie
import AVKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var presenter: ScannerPresenter?
    
    fileprivate var captureSession: AVCaptureSession!
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    fileprivate var animationView: LOTAnimationView!
    fileprivate var hasPermission = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Scanner"

        let closeItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(didPushClose))
        navigationItem.leftBarButtonItem = closeItem
        
        view.backgroundColor = UIColor.white
        
        checkPermission()
    }
    
    fileprivate func checkPermission() {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] success in
            if !success {
                DispatchQueue.main.async {
                    // Handle the case without permission
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
                        return
                    }
                    
                    let alert = UIAlertController(title: "Camera Permission Error", message: "The camera is necessary", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { success in
                            self?.checkPermission()
                        })
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        self?.presenter?.didPushClose()
                    }))
                    
                    self?.present(alert, animated: true)
                }
            } else {
                self?.hasPermission = true
                self?.setupCamera()
            }
        }
    }
    
    fileprivate func setupCamera() {
        guard hasPermission else {
            return
        }
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        animationView = LOTAnimationView(name: "qr_animation")
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        animationView.loopAnimation = true
        animationView.play()
    }
        
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
    
    fileprivate func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(value: stringValue)
        }
    }
    
    func found(value: String) {
        presenter?.didNext(value: value)
    }
    
    func onError(error: Error) {
        captureSession.startRunning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
