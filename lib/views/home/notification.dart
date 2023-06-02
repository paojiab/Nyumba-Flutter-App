import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class Notify extends StatelessWidget {
  const Notify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
        centerTitle: true,
        title: Text(
          S.of(context).notifications,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: const Center(
          child: Text("We don't have any updates for you yet",style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
