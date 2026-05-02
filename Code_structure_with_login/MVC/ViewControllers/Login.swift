//
//  LoginViewController.swift
//  Inheritx Solutions
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var svMain: UIScrollView!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField! {
        didSet {
            txtEmail.delegate = self
            txtEmail.title = "Email Address"
            txtEmail.placeholder = "Enter your email"
        }
    }
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField! {
        didSet {
            txtPassword.delegate = self
            txtPassword.title = "Password"
            txtPassword.placeholder = "Enter your password"
            txtPassword.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnBiometric: UIButton!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardManagement()
        checkBiometricAvailability()
    }
    
    // MARK: - Setup
    private func setupUI() {
        formView.backgroundColor = AppColors.primary
        formView.layer.cornerRadius = 12
        btnLogin.layer.cornerRadius = 8
        
        // Premium touch: apply global theme
        ThemeManager.shared.applyTheme()
        
        UITextField.connectAllTxtFieldFields(txtfields: [txtEmail, txtPassword])
    }
    
    private func setupBindings() {
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.view.showHud()
                } else {
                    self?.view.hideHud()
                }
            }
        }
        
        viewModel.onShowError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message)
                self?.shakeView(self?.formView)
            }
        }
        
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                AppLogger.shared.log("Login Successful!", category: .auth)
                // Navigate to dashboard
            }
        }
    }
    
    private func checkBiometricAvailability() {
        let type = BiometricManager.shared.biometricType
        btnBiometric?.isHidden = (type == .none)
        let iconName = (type == .faceID) ? "faceid" : "touchid"
        btnBiometric?.setImage(UIImage(systemName: iconName), for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        viewModel.login(email: txtEmail.text, password: txtPassword.text)
        updateValidationDisplay()
    }
    
    @IBAction func btnBiometricTapped(_ sender: UIButton) {
        BiometricManager.shared.authenticate { [weak self] success, error in
            if success {
                AppLogger.shared.log("Biometric Auth Success", category: .auth)
                self?.viewModel.onLoginSuccess?()
            } else if let error = error {
                self?.showError(error)
            }
        }
    }
    
    private func updateValidationDisplay() {
        txtEmail.errorMessage = viewModel.emailErrorMessage
        txtPassword.errorMessage = viewModel.passwordErrorMessage
    }
    
    // MARK: - Animations (Premium Feel)
    private func shakeView(_ view: UIView?) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (view?.center.x ?? 0) - 10, y: view?.center.y ?? 0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: (view?.center.x ?? 0) + 10, y: view?.center.y ?? 0))
        view?.layer.add(animation, forKey: "position")
    }
    
    private func showError(_ message: String) {
        showValidationErrorAlert(msg: message) {}
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let txt = textField as? SkyFloatingLabelTextField {
            txt.errorMessage = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard Management
extension LoginViewController {
    private func setupKeyboardManagement() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            svMain.contentInset = .zero
        } else {
            svMain.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        svMain.scrollIndicatorInsets = svMain.contentInset
    }
}

