import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/dialogs.dart';

class SignUpWebViewScreen extends StatefulWidget {
  const SignUpWebViewScreen({Key key}) : super(key: key);

  @override
  State<SignUpWebViewScreen> createState() => _SignUpWebViewScreenState();
}

class _SignUpWebViewScreenState extends State<SignUpWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: false,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: false,
        clearCache: true,
        cacheEnabled: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  //PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.black,
        ),
        body: SafeArea(
            bottom: false,
            top: false,
            child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                          URLRequest(url: Uri.parse(webUrlSignIn)),
                      initialOptions: options,
                      // pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                        });
                        print("urlweb start-->$url");
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },

                      onLoadStop: (controller, url) async {
                        // pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                        });
                        print("urlweb stop-->$url");
                      },
                      onLoadError: (controller, url, code, message) {
                        //pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          //pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) async {
                        final urlString = url.toString();
                        setState(() {
                          this.url = urlString;
                        });
                        print("urlweb progress-->$urlString");

                        final List<String> urlBreakup =
                            urlString.split('?email=');

                        print("urlweb progress start-->${urlBreakup.first}");

                        if (urlBreakup.first == webUrlAccessProjector) {
                          final List<String> tokenBreakup =
                              urlBreakup.last.split('&');

                          final response = await AuthService()
                              .getTokenFromWeb(code: tokenBreakup.first);
                          if (response['success'] == true) {
                            print("respweb true--");
                            await UserData().setUserLogged();
                            await UserData()
                                .setUserToken(response['data']['token']);
                            await UserData().setUserId(response['data']['id']);
                            await UserData()
                                .setFirstName(response['data']['firstname']);

                            // webViewController.goBack();

                            Navigator.pop(context);

                            // If promo data exist with token, show pop up
                            if (tokenBreakup.length > 1) {
                              navigate(context,
                                  StartWatchingScreen(showPromoDialog: true));
                            } else {
                              navigate(context, StartWatchingScreen());
                            }
                          } else {
                            print("respweb false--");
                          }
                        }
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                         log(consoleMessage.toString());
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ])));
  }
}
