import 'package:flutter/material.dart';
import 'package:spesnow/pages/payment.dart';

class KeysPage extends StatelessWidget {
  const KeysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text('Key Packages'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage()),
                  );
              },
              title: Text('UGX 5,000'),
              subtitle: Text('UGX 7,500', style: TextStyle(decoration: TextDecoration.lineThrough),),
              trailing: Text('25 Keys', style: TextStyle(color: Colors.brown),),
            ),
          ),
        ),
       Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
               onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage()),
                  );
              },
              title: Text('UGX 15,000'),
              subtitle: Text('UGX 35,500', style: TextStyle(decoration: TextDecoration.lineThrough),),
              trailing: Text('75 Keys', style: TextStyle(color: Colors.brown),),
            ),
          ),
        ),
       Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
               onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage()),
                  );
              },
              title: Text('UGX 35,000'),
              subtitle: Text('UGX 55,000', style: TextStyle(decoration: TextDecoration.lineThrough),),
              trailing: Text('175 Keys', style: TextStyle(color: Colors.brown),),
            ),
          ),
        ),
       Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
               onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage()),
                  );
              },
              title: Text('UGX 65,000'),
              subtitle: Text('UGX 85,000', style: TextStyle(decoration: TextDecoration.lineThrough),),
              trailing: Text('325 Keys', style: TextStyle(color: Colors.brown),),
            ),
          ),
        ),
      ],),
    );
  }
}
