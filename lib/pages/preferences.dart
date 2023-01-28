import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nyumba/LanguageChangeProvider.dart';

class Preferences extends StatelessWidget {
  const Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text(
          "Preferences",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body:          Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<LanguageChangeProvider>()
                                .changeLocale("en");
                          },
                          child: const Text(
                            'ENGLISH',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<LanguageChangeProvider>()
                                .changeLocale("sw");
                          },
                          child: const Text(
                            'SWAHILI',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
      );
  }
}