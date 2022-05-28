import UIKit

@available(iOS 15.0, *)
class ViewController: UIViewController {

    //MARK: - Views

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Actions

    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func startButtonTap(_ sender: Any) {

            configureViewAfterTap()

        let password = generatePassword(len: Metric.passwordLength)
            passwordTextField.text = password

            let serialQueue = DispatchQueue(label: "Crack queue")
            let workItem = DispatchWorkItem {
                self.bruteForce(passwordToUnlock: password)
            }

            workItem.notify(queue: DispatchQueue.main, execute: {
                self.configureAfterCraced()
                self.resultLabel.text = "Password: \(password) has been cracked"

            })

            serialQueue.async(execute: workItem)
    }

    //MARK: - Private Functions

    private func generatePassword(len: Int) -> String {
        let len = len
        let passwordChars = Strings.passwordChars
        let randomPassword = String((0..<len).compactMap{ _ in passwordChars.randomElement() })
        return randomPassword
    }

    private func configureViewAfterTap() {
        resultLabel.text = ""
        startButton.configuration?.showsActivityIndicator = true
        passwordTextField.isSecureTextEntry = true
    }

    private func configureAfterCraced() {
        self.startButton.configuration?.showsActivityIndicator = false
        self.passwordTextField.isSecureTextEntry = false
    }

    private func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
        }
        print(password)
    }
}

@available(iOS 15.0, *)
extension ViewController {
    enum Metric {
        static let passwordLength = 3
    }
    enum Strings {
        static let queueLabel = "Crack queue"
        static let passwordChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    }
}
