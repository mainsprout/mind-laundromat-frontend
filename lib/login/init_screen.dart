import 'package:flutter/material.dart';
import 'package:mind_laundromat/login/sign_up.dart';

import 'login.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return Login();
                    },
                    ),
                  );
                },
                child: Text('Login'),
            ),
            OutlinedButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return SignUp();
                },
                ),
              );
            }, child: Text('Sign up'),
            )

          ],
        ),
      )
    );
  }
}
