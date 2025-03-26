import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class WebViewExample extends StatefulWidget {
  String conditionsUrl = 'https://helpabode.com/privacy-policy.html';
  String title = '';

  WebViewExample({required this.conditionsUrl, required this.title});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    debugPrint('Loading Url: ${widget.conditionsUrl}');

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
            });
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _loadingProgress = 0;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://helpabode.com/')) {
          //     debugPrint('blocking navigation to ${request.url}');
          //     return NavigationDecision.prevent;
          //   }
          //   debugPrint('allowing navigation to ${request.url}');
          //   return NavigationDecision.navigate;
          // },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.conditionsUrl));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          widget.title ?? '',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),

        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          //NavigationControls(webViewController: _controller),
          // SampleMenu(webViewController: _controller),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: _loadingProgress < 1.0
              ? LinearProgressIndicator(
                  value: _loadingProgress,
                  color: Colors.black,
                )
              : Container(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
      //floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {
        final String? url = await _controller.currentUrl();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorited $url')),
          );
        }
      },
      child: const Icon(Icons.favorite),
    );
  }

  Future<void> openDialog(HttpAuthRequest httpRequest) async {
    final TextEditingController usernameTextController =
        TextEditingController();
    final TextEditingController passwordTextController =
        TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  autofocus: true,
                  controller: usernameTextController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: passwordTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Explicitly cancel the request on iOS as the OS does not emit new
            // requests when a previous request is pending.
            TextButton(
              onPressed: () {
                httpRequest.onCancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                httpRequest.onProceed(
                  WebViewCredential(
                    user: usernameTextController.text,
                    password: passwordTextController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
}

class SampleMenu extends StatelessWidget {
  SampleMenu({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.showUserAgent:
            _onShowUserAgent();
          case MenuOptions.listCookies:
            _onListCookies(context);
          case MenuOptions.clearCookies:
            _onClearCache(context);
          case MenuOptions.addToCache:
            _onAddToCache(context);
          case MenuOptions.listCache:
            _onListCache();
          case MenuOptions.clearCache:
            _onClearCache(context);
          case MenuOptions.navigationDelegate:
            _onNavigationDelegateExample();
          case MenuOptions.doPostRequest:
            _onDoPostRequest();
          case MenuOptions.loadLocalFile:
            _onLoadLocalFileExample();
          case MenuOptions.loadFlutterAsset:
            _onLoadFlutterAssetExample();
          case MenuOptions.loadHtmlString:
            _onLoadHtmlStringExample();
          case MenuOptions.transparentBackground:
            _onTransparentBackground();
          case MenuOptions.setCookie:
            _onSetCookie();
          case MenuOptions.logExample:
            _onLogExample();
          case MenuOptions.basicAuthentication:
            _promptForUrl(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.showUserAgent,
          child: Text('Show user agent'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.addToCache,
          child: Text('Add to cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCache,
          child: Text('List cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCache,
          child: Text('Clear cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.navigationDelegate,
          child: Text('Navigation Delegate example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.doPostRequest,
          child: Text('Post Request'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadLocalFile,
          child: Text('Load local file'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadFlutterAsset,
          child: Text('Load Flutter Asset'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadHtmlString,
          child: Text('Load HTML string'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.transparentBackground,
          child: Text('Transparent background example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.logExample,
          child: Text('Log example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.basicAuthentication,
          child: Text('Basic Authentication'),
        ),
      ],
    );
  }

  Future<void> _onShowUserAgent() async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered on the WebView.
    await webViewController.runJavaScript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  Future<void> _onListCookies(BuildContext context) async {
    final String cookies = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Cookies:'),
            _getCookieList(cookies),
          ],
        ),
      ));
    }
  }

  Future<void> _onAddToCache(BuildContext context) async {
    await webViewController.runJavaScript(
        'caches.open("test_caches_entry"); localStorage.setItem("test_localStorage", "dummy_entry");');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added a test entry to cache.'),
      ));
    }
  }

  Future<void> _onListCache() async {
    await webViewController.runJavaScript(
        'caches.keys().then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage})).then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await webViewController.clearCache();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cache cleared.'),
      ));
    }
  }

  Future<void> _onNavigationDelegateExample() async {
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    await webViewController.loadRequest(
      Uri.parse('data:text/html;base64,$contentBase64'),
    );
  }

  Future<void> _onDoPostRequest() async {
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(kPostRequestExamplePage));
    await webViewController.loadRequest(
      Uri.parse('data:text/html;base64,$contentBase64'),
    );
  }

  Future<void> _onLoadLocalFileExample() async {
    final String pathToIndex = await _prepareLocalFile();
    await webViewController.loadFile(pathToIndex);
  }

  Future<void> _onLoadFlutterAssetExample() async {
    await webViewController.loadFlutterAsset('assets/www/index.html');
  }

  Future<void> _onLoadHtmlStringExample() async {
    await webViewController.loadHtmlString(kTestPage);
  }

  Future<void> _onTransparentBackground() async {
    await webViewController.setBackgroundColor(const Color(0x00000000));
  }

  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
        // expiresDate: null,
        // isHttpOnly: false,
        // isSecure: false,
        // sameSite: WebViewCookieSameSitePolicy.none,
      ),
    );
    await webViewController
        .loadRequest(Uri.parse('https://httpbin.org/anything'));
  }

  Widget _getCookieList(String cookies) {
    if (cookies == '') {
      return const Text('There are no cookies.');
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

  Future<void> _promptForUrl(BuildContext context) async {
    final TextEditingController urlTextController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter the URL to authenticate against'),
          content: SingleChildScrollView(
            child: TextField(
              decoration: const InputDecoration(labelText: 'URL'),
              autofocus: true,
              controller: urlTextController,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onBasicAuthentication(urlTextController.text);
              },
              child: const Text('Enter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onBasicAuthentication(String authUrl) async {
    final String username = 'WebViewUser';
    final String password = 'WebViewPassword';
    await webViewController
        .loadRequest(Uri.parse(authUrl), headers: <String, String>{
      HttpHeaders.authorizationHeader:
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    });
  }

  Future<void> _onLogExample() async {
    final Directory documents = await getApplicationDocumentsDirectory();
    final String documentsPath = documents.path;
    await webViewController.runJavaScript(
        'console.log("Document Path on host machine: $documentsPath")');
  }
}

const String kNavigationExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation Delegate Example</title>
</head>
<body>
    <p>
    The navigation delegate is set to block navigation to the youtube website.
    </p>
    <ul>
        <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
        <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
    </ul>
</body>
</html>
''';

const String kPostRequestExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Request Example</title>
</head>
<body>
    <form method="post" action="https://postman-echo.com/post">
        <label for="message">Message:</label>
        <input type="text" id="message" name="message" value="Hello!">
        <input type="submit" value="Send">
    </form>
</body>
</html>
''';

const String kTestPage = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Page</title>
</head>
<body>
    <p>
    Hello world!
    </p>
    <ul>
        <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
    </ul>
</body>
</html>
''';

Future<String> _prepareLocalFile() async {
  final String tmpDir = (await getTemporaryDirectory()).path;
  final File file = File('$tmpDir/local.html');
  await file.writeAsString(kLocalFileContents);
  return file.path;
}

const String kLocalFileContents = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Local File</title>
</head>
<body>
    <p>
    Local file loaded into webview.
    </p>
</body>
</html>
''';
