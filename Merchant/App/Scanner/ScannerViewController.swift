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
        title = Constants.Strings.scanner
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func checkPermission() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] success in
            if !success {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
                    return
                }
                
                let alert = UIAlertController(title: Constants.Strings.cameraPermissionError, message: Constants.Strings.theCameraIsNecessary, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: Constants.Strings.openSettings, style: .default, handler: { _ in
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { success in
                        self?.checkPermission()
                    })
                }))
                
                alert.addAction(UIAlertAction(title: Constants.Strings.cancel, style: .cancel, handler: { _ in
                    self?.presenter?.didPushClose()
                }))
                
                self?.present(alert, animated: true)
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
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.captureSession = AVCaptureSession()
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (self.captureSession.canAddInput(videoInput)) {
                self.captureSession.addInput(videoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.captureSession.canAddOutput(metadataOutput)) {
                self.captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                self.failed()
                return
            }
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = self.view.layer.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
            
            self.animationView = LOTAnimationView(name: "qr_animation")
            self.view.addSubview(self.animationView)
            
            self.animationView.translatesAutoresizingMaskIntoConstraints = false
            self.animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.animationView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
            self.animationView.widthAnchor.constraint(equalToConstant: self.view.frame.width / 2).isActive = true
            
            self.animationView.loopAnimation = true
            self.animationView.play()
        }
    }
        
    @objc func didPushClose() {
        presenter?.didPushClose()
    }
    
    fileprivate func failed() {
        let ac = UIAlertController(title: Constants.Strings.scanningNotSupported, message: Constants.Strings.scanningNotSupportedDetails, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: Constants.Strings.ok, style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermission()
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
