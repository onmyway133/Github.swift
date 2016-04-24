import UIKit
import GithubSwift

class ViewController: UIViewController {

  let user = User(rawLogin: "onmyway133", server: Server.dotComServer)
  var client: Client!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()

    Config.clientID = "39a577aa1d58f517a462"
    Config.clientSecret = "bd65a95fbf09d59055c5dedc5a49582e4c4e1c81"

    nativeLogin()
  }

  func nativeLogin() {
    let _ =
    Client.signIn(user: user, password: "", scopes: [.Repository])
    .subscribe {
      print($0)
    }
  }

  func oAuthLogin() {
    let _ =
    Client.signInUsingWebBrowser(Server.dotComServer, scopes: [.Repository])
      .subscribe {
        print($0)
    }
  }
}

