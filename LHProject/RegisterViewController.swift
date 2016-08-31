
//
//  RegisterViewController.swift
//  LHProject
//
//  Created by bangong on 16/8/18.
//  Copyright © 2016年 auto. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

     var nameTextField : UITextField!
     var passwordTextField : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField = UITextField.init(frame: CGRectMake(20, 100, 200, 30))
        nameTextField.borderStyle = .RoundedRect
        nameTextField.placeholder = "mingzi"
        passwordTextField = UITextField.init(frame: CGRectMake(20, 150, 200, 30))
        passwordTextField.borderStyle = .RoundedRect
        passwordTextField.placeholder = "mima"
        self.view.addSubview(nameTextField)
        self.view.addSubview(passwordTextField)


        let registerButton = UIButton.init(frame: CGRectMake(20, 250, 80, 30))
        registerButton.setTitle("register", forState: .Normal)
        registerButton.backgroundColor = UIColor.greenColor()
        registerButton.addTarget(self, action:"registerClick", forControlEvents: .TouchUpInside)

        self.view.addSubview(registerButton)

    }

    func registerClick(){


        XMPPManager.shareManager().registerWithName(nameTextField.text, passWord: passwordTextField.text)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
