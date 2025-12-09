//
//  CommonScanner.swift
//  GIS
//
//  Created by Macbook Pro on 14/08/23.
//  Copyright © 2023 Hawkscode. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyGif


protocol ScannerDelegate {
    func mGetScannedData(value : String,type:String)
    
}

class CommonScanner: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var mScannerCamView: UIView!
    
    @IBOutlet weak var mScannerGif: UIImageView!
    let shape = CAShapeLayer()
    let layer = CAGradientLayer()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var mType = ""
    var delegate:ScannerDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // ✅ โหลด GIF ด้วย SwiftyGif
        if let gif = try? UIImage(gifName: "scanner.gif") {
    mScannerGif.setGifImage(gif)
}

        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        mStartQRcode()
        
    }
    
    
    
    @IBAction func mBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    func mStartQRcode(){
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
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
             
            metadataOutput.metadataObjectTypes = [.code128,.code39,
                                                  .qr,.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        mScannerCamView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        var s: SystemSoundID = 1000
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }

            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func found(code: String) {
        
        self.delegate?.mGetScannedData(value: code, type: self.mType)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        self.dismiss(animated: true)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
}
