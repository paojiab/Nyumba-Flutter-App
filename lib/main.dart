import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spesnow/LanguageChangeProvider.dart';
import 'package:spesnow/views/account/account.dart';
import 'package:spesnow/views/favorite.dart';
import 'package:spesnow/views/home/home_page.dart';
import 'package:spesnow/views/scout.dart';
import 'package:spesnow/views/search/init.dart';
import 'package:spesnow/views/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  await FlutterConfig.loadEnvVariables();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
            appBarTheme: const AppBarTheme(color: Colors.transparent),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.home_mini_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline_rounded), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Scout',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline), label: 'Wallet'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onTappedItem,
      ),
    );
  }
}
