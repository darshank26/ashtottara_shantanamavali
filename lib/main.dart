import 'dart:async';
import 'package:ashtottara_shantanamavali/screens/HomeScreen.dart';
import 'package:ashtottara_shantanamavali/utils/constants.dart';
import 'package:ashtottara_shantanamavali/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());

  MobileAds.instance.initialize(); // here

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";

  late String _emailAddress;

  late String _externalUserId;

  bool _enableConsentButton = false;

  bool _requireConsent = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _handleConsent();
    // _handleSendNotification();

  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    // OneSignal.shared
    //     .setNotificationReceivedHandler((OSNotification notification) {
    //   this.setState(() {
    //     _debugLabelString =
    //     "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   });
    // });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
        "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
            (OSEmailSubscriptionStateChanges changes) {
          // print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
        });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .setAppId("1279868f-c622-4716-a674-5cc3c228a095");

    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.shared.consentGranted(true);
  }

  // void _handleSendNotification() async {
  //   var status = await OneSignal.shared.getPermissionSubscriptionState();
  //   var playerId = status.subscriptionStatus.userId;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '108 Ashtottara Shantanamavali',
      theme : ThemeData(
        brightness: Brightness.light,
        primaryColor: kmarroncolor,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          subtitle1: TextStyle(),
        ).apply(
          bodyColor:kmarroncolor,
          displayColor: kmarroncolor,
          decorationColor: kmarroncolor,
        ),
        scaffoldBackgroundColor: kmarroncolor,
        primaryIconTheme: IconThemeData(
          color:const Color(0xfffB2EBF2),
        ),
        primarySwatch: Colors.blue,
        accentColor: kmarroncolor,

        tabBarTheme: TabBarTheme(
          labelColor: Color(0xfffB2EBF2),
          unselectedLabelColor: Color(0xfffB2EBF2),
        ),
        appBarTheme: AppBarTheme(
          color: kmarroncolor,
        ),
        buttonTheme: ButtonThemeData(),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          subtitle1: TextStyle(),
        ).apply(
          bodyColor: Colors.blue[700],
          displayColor: Colors.blue[700],
          decorationColor: Color(0xff247188),
        ),
        iconTheme: IconThemeData(color: Color(0xff2a77a0),),
        buttonColor: Color(0xff2a77a0),

      ),

      home: IntroSplashScreen(),
    );
  }
}

class IntroSplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<IntroSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '108 Ashtottara Shantanamavali',
            theme: notifier.darkTheme! ? light : dark,
            home: Scaffold(
              // backgroundColor: Colors.blue[700] ,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.0,),
                    Center(child: Image.asset('assets/images/splash_logo.png',
                      height: 400,width: 350.0, )),
                    const SizedBox(height: 100.0,),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: kprimarycolor,
                        ),
                      ),
                    )
                  ],
                )

            ),
          );
        } ,
      ),
    )

    ;
  }
}
