import 'package:spesnow/LanguageChangeProvider.dart';
import 'package:spesnow/account.dart';
import 'package:spesnow/favorite.dart';
import 'package:spesnow/home_page.dart';
import 'package:spesnow/pages/scout.dart'; 
import 'package:spesnow/pages/search.dart';
import 'package:spesnow/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'package:flutter_config/flutter_config.dart';

Future main() async {
  // initialize flutter config
  WidgetsFlutterBinding.ensureInitialized(); 
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>( 
      create: (context) => LanguageChangeProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
          locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.brown,
            appBarTheme: const AppBarTheme(color: Colors.white),
          ),
          home: const RootPage(),
          routes: {
            '/account': (context) => const Account(),
            '/search': (context) => const SearchPage(),
          },
        );
      }),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
 
  List<Widget> pages = const [
    HomePage(),
    Favorite(),
    ScoutPage(),
    Wallet(),
    Account(),
  ];

  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_searching),
            label: 'Scout',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.black,
        onTap: _onTappedItem,
      ),
    );
  }
}
