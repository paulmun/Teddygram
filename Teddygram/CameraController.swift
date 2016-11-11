//
//  CameraController.swift
//  Teddygram
//
//  Created by James Moreno on 11/10/16.
//  Copyright © 2016 Team No Shoes. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBAction func takePicture(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takePictureButton.layer.cornerRadius = 0.5 * takePictureButton.bounds.size.width
        takePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        takePictureButton.layer.borderWidth = 8.0
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            if (device as AnyObject).position == AVCaptureDevicePosition.back{
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                        if captureSession.canAddOutput(sessionOutput){
                            
                            captureSession.addOutput(sessionOutput)
                            
                            captureSession.startRunning()
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
                            previewLayer.bounds = cameraView.frame
                        }
                        
                    }
                }
                catch {
                    print("ERROR")
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
