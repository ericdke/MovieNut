import SwiftUI
import WebKit

struct LoginWebView: UIViewRepresentable {

    let origin: LoginOrigin
    let helper = WebViewHelper()
    
    let url = URL(string: "https://pnut.io/oauth/authenticate?client_id=\(Credentials.clientId)&redirect_uri=movienut://auth&scope=public_messages:io.pnut.core.chat,write_post&response_type=token&simple_login=1")!
    
    private let js = """
    var inputs = document.getElementsByTagName('button');
    var button = inputs[0];
    button.addEventListener("click", function() {
        var messageToPost = {'didClick':'loginButton'};
        window.webkit.messageHandlers.buttonClicked.postMessage(messageToPost);
    },false);
    """
    
    func makeUIView(context: UIViewRepresentableContext<LoginWebView>) -> WKWebView {
        helper.origin = origin
        let webCfg = WKWebViewConfiguration()
        let userController = WKUserContentController()
        let userScript:WKUserScript =  WKUserScript(source: js,
                                                    injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
                                                    forMainFrameOnly: false)
        userController.addUserScript(userScript)
        userController.add(helper, name: "buttonClicked")
        webCfg.userContentController = userController
        let webview = WKWebView(frame: .zero, configuration: webCfg)
        webview.navigationDelegate = helper

        let request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalCacheData)
        webview.load(request)
        
        return webview
    }

    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<LoginWebView>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}

class WebViewHelper: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    
    private let token_delimiter = "access_token="
    private let scheme_delimiter = "movienut:"
    private var done = false
    var origin: LoginOrigin!
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        #if DEBUG
        DispatchQueue.main.async {
            print(Date(), #file, #function)
        }
        #endif
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        DispatchQueue.main.async {
            print(Date(), #file, #function)
        }
        #endif
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString,
            url.starts(with: scheme_delimiter),
            let endIndex = url.range(of: token_delimiter)?.upperBound
        {
            if done == false {
                done = true
                let res = TokenResponse(token: String(url[endIndex...]), origin: origin)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.GotToken, object: res, userInfo: nil)
                }
            }
            
            #if DEBUG
            DispatchQueue.main.async {
                print(String(url[endIndex...]))
                print(Date(), #file, #function)
            }
            #endif
        }
        decisionHandler(.allow)
    }
    
}


