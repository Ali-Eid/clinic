import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:clinic/constants.dart';
import 'package:clinic/logic/auth/cubit/auth_cubit.dart';
import 'package:clinic/model/cities_model.dart';
import 'package:clinic/model/specialist_model.dart';
import 'package:clinic/services/cach_helper.dart';
import 'package:clinic/view/screens/home_screen.dart';
import 'package:clinic/view/widgets/auth/auth_button.dart';
import 'package:clinic/view/widgets/auth/text_form_field.dart';
import 'package:clinic/view/widgets/fotter.dart';
import 'package:clinic/view/widgets/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatelessWidget {
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  int? cityID;
  int? destrictID;
  int? specialistID;

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessAuthState) {
            CacheHelper.saveData(key: 'token', value: state.model!.data!.token)
                .then(
              (value) {
                if (value!) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(seconds: 1),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          animation = CurvedAnimation(
                              parent: animation, curve: Curves.linearToEaseOut);
                          return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return HomeScreen();
                        },
                      ),
                      (route) => false);
                }
              },
            );
          }
          if (state is ErrorInputAuthState) {
            String s = '';
            if (state.errormodel!.data!.firstName != null) {
              s = '${state.errormodel!.data!.firstName.toString()}\n';
            }
            if (state.errormodel!.data!.lastName != null) {
              s += '${state.errormodel!.data!.lastName.toString()}\n';
            }
            if (state.errormodel!.data!.email != null) {
              s += '${state.errormodel!.data!.email.toString()}\n';
            }
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Erro SignUp',
              desc: '${s}',
              // btnCancelOnPress: () {},
              btnOkOnPress: () {
                // Navigator.of(context).pop();
              },
            ).show();
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              flexibleSpace: Image(
                image: AssetImage('assets/images/xxxxxxx (1).png'),
                fit: BoxFit.fill,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Colors.grey.shade300,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: double.infinity,
                              height: 100,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextUtils(
                              text: 'عيادتي',
                              color: Colors.blue.shade900,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          TextUtils(
                              text: 'My clinic',
                              color: Colors.blue.shade900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: 35,
                                    // width: 100,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 25,
                                          offset: Offset(0, 10))
                                    ]),
                                    child: AuthTextFormField(
                                        controller: firstnameController,
                                        obsecure: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'First Name must not be empty';
                                          }
                                          return null;
                                        },
                                        hinttext: ' First Name'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    // height: 35,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 25,
                                          offset: Offset(0, 10))
                                    ]),
                                    child: AuthTextFormField(
                                        controller: lastnameController,
                                        obsecure: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Last Name must not be empty';
                                          }
                                          return null;
                                        },
                                        hinttext: ' Last Name'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              // height: 35,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 25,
                                    offset: Offset(0, 10))
                              ]),
                              child: AuthTextFormField(
                                  controller: emailController,
                                  obsecure: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email must not be empty';
                                    }
                                    return null;
                                  },
                                  hinttext: ' your email'),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              // height: 35,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 25,
                                    offset: Offset(0, 10))
                              ]),
                              child: AuthTextFormField(
                                  controller: passwordController,
                                  obsecure: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'password is too short';
                                    }
                                    return null;
                                  },
                                  hinttext: ' your password'),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              child: Container(
                                // height: 35,
                                width: double.infinity,
                                child: DropdownButtonHideUnderline(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: DropdownButton<dynamic>(
                                      hint: TextUtils(
                                          text: 'your city',
                                          color: Colors.grey.shade500,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      value: AuthCubit.get(context)
                                          .valueDropDowncity,
                                      items: AuthCubit.get(context)
                                                  .citiesModel ==
                                              null
                                          ? []
                                          : AuthCubit.get(context)
                                              .citiesModel!
                                              .data!
                                              .map((value) {
                                              return DropdownMenuItem<String>(
                                                  onTap: () {
                                                    cityID = value.id;
                                                    AuthCubit.get(context)
                                                        .getDistrict(
                                                            id: value.id);
                                                  },
                                                  child: Text(value.name!),
                                                  value: value.name);
                                            }).toList(),
                                      onChanged: (val) {
                                        AuthCubit.get(context)
                                            .changevalueDropdown(val);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              child: Container(
                                // height: 35,
                                width: double.infinity,
                                child: DropdownButtonHideUnderline(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: DropdownButton<dynamic>(
                                      hint: TextUtils(
                                          text: 'your Districit',
                                          color: Colors.grey.shade500,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      value: AuthCubit.get(context)
                                          .valueDropDowndistrict,
                                      items: AuthCubit.get(context)
                                                  .disrictModel ==
                                              null
                                          ? []
                                          : AuthCubit.get(context)
                                              .disrictModel!
                                              .data!
                                              .map((value) {
                                              return DropdownMenuItem<String>(
                                                child: Text(value.name!),
                                                value: value.name,
                                                onTap: () {
                                                  destrictID = value.id;
                                                },
                                              );
                                            }).toList(),
                                      onChanged: (val) {
                                        AuthCubit.get(context)
                                            .changevalueDropdownDistrict(val);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              child: Container(
                                // height: 35,
                                width: double.infinity,
                                child: DropdownButtonHideUnderline(
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: DropdownButton<dynamic>(
                                      hint: TextUtils(
                                          text: 'your specialty',
                                          color: Colors.grey.shade500,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      value: AuthCubit.get(context)
                                          .valueDropDowncityspecilalist,
                                      items: AuthCubit.get(context)
                                                  .specialistModel ==
                                              null
                                          ? []
                                          : AuthCubit.get(context)
                                              .specialistModel!
                                              .data!
                                              .map((value) {
                                              return DropdownMenuItem<String>(
                                                  onTap: () {
                                                    specialistID = value.id;
                                                  },
                                                  child: Text(value.name!),
                                                  value: value.name);
                                            }).toList(),
                                      onChanged: (val) {
                                        AuthCubit.get(context)
                                            .changevalueDropdownspecilalist(
                                                val);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          BuildCondition(
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.green.shade400,
                              ),
                            ),
                            condition: state is! LoadingAuthState,
                            builder: (context) => Container(
                              width: 130,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade300,
                                      Colors.blue.shade900,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight),
                              ),
                              child: AuthButton(
                                text: 'Sign up',
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    AuthCubit.get(context).signup(
                                      firstname: firstnameController.text,
                                      lastname: lastnameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      cityid: cityID!,
                                      districtid: destrictID!,
                                      specialistid: specialistID!,
                                    );
                                  }
                                },
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/facebook.png'),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: TextUtils(
                                  text: 'Or sign up with facebook',
                                  color: Colors.blue.shade900,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //     height: 60,
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Image(
                          //       image: AssetImage('assets/images/88.png'),
                          //       fit: BoxFit.fill,
                          //     )),
                        ],
                      ),
                    ),
                  ),
                ),
                FotterWidget(),
                // Container(
                //     height: 57,
                //     width: MediaQuery.of(context).size.width,
                //     child: Image(
                //       image: AssetImage('assets/images/88.png'),
                //       fit: BoxFit.fill,
                //     )),
              ],
            ),
          );
        },
      ),
    );
  }
}
