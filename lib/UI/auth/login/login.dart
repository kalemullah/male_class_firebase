import 'package:firebase_project/UI/auth/login/login_provider.dart';
import 'package:firebase_project/UI/auth/sign_up/sign_up.dart';
import 'package:firebase_project/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Consumer<LoginProvider>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('SIgn In '),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: model.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      controller: model.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: model.passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: 'Sign In',
                      height: 50.h,
                      width: 200.w,
                      isloading: model.isloading,
                      color: Colors.teal,
                      onPressed: () {
                        if (model.formKey.currentState!.validate()) {
                          model.login(
                            context,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: 'Sign Up',
                      height: 50.h,
                      width: 200.w,
                      isloading: model.isloading,
                      color: Colors.teal.withOpacity(.6),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUpScreen();
                        }));
                      },
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
