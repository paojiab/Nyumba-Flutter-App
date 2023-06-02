import 'package:flutter/material.dart';
import 'package:spesnow/providers/flutterwave.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RaveModelPage extends StatefulWidget {
  const RaveModelPage({super.key, required this.myUrl, required this.txRef});
  final String myUrl;
  final String txRef;
  @override
  State<RaveModelPage> createState() => _RaveModelPageState();
}

class _RaveModelPageState extends State<RaveModelPage> {
  late final WebViewController controller;
  int _progress = 0;
  bool _isLoading = false;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _progress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _progress = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.myUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_isLoading) {
          setState(() {
            _isLoading = true;
          });
          try {
            await flutteraveProvider()
                .getTransaction(widget.txRef)
                .then((value) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context);
              if (value["status"] == "successful") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black,
                    content:
                        const Text("Transaction successfull. Refresh page"),
                  ),
                );
              }
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black,
                content: const Text("Transaction failed"),
              ),
            );
          }
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Validate Payment",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await flutteraveProvider()
                          .getTransaction(widget.txRef)
                          .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                        if (value["status"] == "successful") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: const Text(
                                  "Transaction successfull. Refresh page"),
                            ),
                          );
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          content: const Text("Transaction failed"),
                        ),
                      );
                    }
                  }
                },
                icon: _isLoading
                    ? const Text(
                        "...",
                        style: TextStyle(color: Colors.black),
                      )
                    : const Icon(
                        Icons.clear,
                        color: Colors.black,
                      )),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (_progress < 100)
              LinearProgressIndicator(
                value: _progress / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
              ),
          ],
        ),
      ),
    );
  }
}
