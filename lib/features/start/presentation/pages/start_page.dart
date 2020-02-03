import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seed/routes/router.gr.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start'),),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(child: Text('Number trivia'), onPressed: () => navigateToTrivia(context),)
            ],
          ),
        ),
      ),
    );
  }

  void navigateToTrivia(BuildContext context) {
    Router.navigator.pushNamed(Router.numberTriviaPage);
  }
}
