import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/constants.dart' as Constants;
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/AuthScreen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

Future<bool> setFinishedOnBoarding() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(Constants.FINISHED_ON_BOARDING, true);
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Color(0xFFBBBAD3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () => print('Skip'),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Container(
                height: 600.0,
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Find your style\naround the world',
                            style: kTitleStyle,
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: Lottie.network(
                              //Lottie
                              'https://assets7.lottiefiles.com/packages/lf20_sSF6EG.json',
                              width: 250,
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 55.0),
                          Text(
                            'You can find or sell your designer clothes. Make account as seller and start sell',
                            style: kSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Connect with designers\n',
                            style: kTitleStyle,
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: Lottie.network(
                              //Lottie
                              'https://assets5.lottiefiles.com/packages/lf20_decvxrvx.json',
                              width: 350,
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 55.0),
                          Text(
                            'Find your personal favourite designers and chat together to discuss your offer',
                            style: kSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'You can start career\nlike designer',
                            style: kTitleStyle,
                          ),
                          SizedBox(height: 30.0),
                          Center(
                            child: Lottie.network(
                              //Lottie
                              'https://assets8.lottiefiles.com/datafiles/6WfDdm3ooQTEs1L/data.json',
                              width: 250,
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 55.0),
                          Text(
                            'Create your designer clothes, upload items, and sell',
                            style: kSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              _currentPage != _numPages - 1
                  ? Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(width: 10.0),

                      ],
                    ),
                  ),
                ),
              )
                  : Text(''),
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
        height: 100.0,
        width: double.infinity,
        color: Colors.white,
        child: InkWell(
          onTap: () {
            setFinishedOnBoarding();
            pushReplacement(context, new AuthScreen());
          },
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Get started',
                style: TextStyle(
                  color: Color(0xFF5B16D0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      )
          : Text(''),
    );
  }
}


