import 'package:app_movil_iptv/utils/consts.dart';
import 'package:app_movil_iptv/utils/routes/routes_name.dart';
import 'package:app_movil_iptv/utils/utils.dart';
import 'package:app_movil_iptv/viewmodels/login_viewmodel.dart';
import 'package:app_movil_iptv/views/widgets/material_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  late bool isPasswordVisible = false;

  final FocusNode focusNodeUsername = FocusNode(); //0
  final FocusNode focusNodePassword = FocusNode(); //1
  final FocusNode focusNodeIsPasswordVisible = FocusNode(); //2
  final FocusNode focusNodeButtom = FocusNode(); //3
  final FocusNode remoteFocusNode = FocusNode();

  TabIndex indexTab = TabIndex.inputUsername;

  onKey(RawKeyEvent event) {
    debugPrint("EVENT");
    if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      debugPrint('downd');
      if (indexTab == TabIndex.inputUsername) {
        indexTab = TabIndex.inputPassword;
        focusNodeUsername.unfocus();
        focusNodePassword.requestFocus();
      } else if (indexTab == TabIndex.inputPassword) {
        indexTab = TabIndex.isPasswordVisible;
        focusNodePassword.unfocus();
        focusNodeIsPasswordVisible.requestFocus();
      } else if (indexTab == TabIndex.isPasswordVisible) {
        indexTab = TabIndex.buttomLogin;
        focusNodeIsPasswordVisible.unfocus();
        focusNodeButtom.requestFocus();
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      debugPrint('up');
      if (indexTab == TabIndex.buttomLogin) {
        indexTab = TabIndex.isPasswordVisible;
        focusNodeButtom.unfocus();
        focusNodeIsPasswordVisible.requestFocus();
      } else if (indexTab == TabIndex.isPasswordVisible) {
        indexTab = TabIndex.inputPassword;
        focusNodeIsPasswordVisible.unfocus();
        focusNodePassword.requestFocus();
      } else if (indexTab == TabIndex.inputPassword) {
        indexTab = TabIndex.inputUsername;
        focusNodePassword.unfocus();
        focusNodeUsername.requestFocus();
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.select)) {
      debugPrint("enter");
      if (indexTab == TabIndex.inputUsername) {
        focusNodeUsername.requestFocus();
      } else if (indexTab == TabIndex.inputPassword) {
        focusNodePassword.requestFocus();
      } else if (indexTab == TabIndex.buttomLogin) {
        submit();
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    focusNodeUsername.requestFocus();
  }

  @override
  void dispose() {
    focusNodeUsername.dispose();
    focusNodePassword.dispose();
    focusNodeIsPasswordVisible.dispose();
    focusNodeButtom.dispose();
    remoteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: remoteFocusNode,
      onKey: onKey,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Const.imgBackground), fit: BoxFit.cover)),
            child: Row(
              children: <Widget>[
                //Item 1/2
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Logo
                        Image(
                          image: AssetImage(Const.imgLogo),
                          height: 200,
                        ),
                        //Texto
                        Text(
                            textAlign: TextAlign.center,
                            "Watch Live Tv, Movies, Tv shows \n and much more... 😜",
                            style: Const.fontTitleTextStyle)
                      ],
                    ),
                  ),
                ),
                //Item 2/2
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //TExto Bienvenida
                        const Text(
                          "Login to your \n Account",
                          textAlign: TextAlign.center,
                          style: Const.fontHeaderH1TextStyle,
                        ),
                        Utils.verticalSpace(20),
                        //Usuario
                        TextField(
                          controller: username,
                          //enabled: indexTab == TabIndex.inputUsername,
                          focusNode: focusNodeUsername,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white70),
                          onTap: () {
                            setState(() {
                              indexTab = TabIndex.inputUsername;
                            });
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            labelText: 'Username',
                            hintText: 'Username',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Const.colorPurpleDarker,
                              size: 20,
                            ),
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //    color: Const.colorPurpleDarker,
                            //    width: 5.sp,
                            //  ),
                            //  borderRadius:
                            //      BorderRadius.all(Radius.circular(1.w)),
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Const.colorPurpleDark,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Const.colorCoralAccent,
                              fontSize: 18,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Const.colorPinkAccent,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        Utils.verticalSpace(20),
                        //Contrasenia
                        TextField(
                          controller: password,
                          //enabled: indexTab == TabIndex.inputPassword,
                          focusNode: focusNodePassword,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white70),
                          onTap: () {
                            setState(() {
                              indexTab = TabIndex.inputPassword;
                            });
                          },
                          obscureText: !isPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            labelText: 'Password',
                            hintText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.key,
                              color: Const.colorPurpleDarker,
                              size: 20,
                            ),
                            // border: OutlineInputBorder(
                            //  borderSide: BorderSide(
                            //    color: Const.colorPurpleDarker,
                            //   width: 5.sp,
                            // ),
                            //  borderRadius:
                            //      BorderRadius.all(Radius.circular(1.w)),
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Const.colorPurpleDark,
                                width: 2,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Const.colorCoralAccent,
                              fontSize: 18,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Const.colorPinkAccent,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        //CHECK VISIBLE PASWORD
                        Flexible(
                          child: Row(
                            children: [
                              Checkbox(
                                focusNode: focusNodeIsPasswordVisible,
                                activeColor: Const.colorCoralAccent,
                                value: isPasswordVisible,
                                onChanged: (value) {
                                  setState(() {
                                    isPasswordVisible = value!;
                                    indexTab = TabIndex.isPasswordVisible;
                                  });
                                },
                                side: const BorderSide(
                                  color: Const.colorPurpleDark,
                                  width: 2,
                                ),
                              ),
                              const Text('Show Password',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ),
                        //BOTON LOGIN
                        ButtomMaterial(
                          texto: "Sign In",
                          icono: Icons.login,
                          colorBg: Const.colorPurpleMediumDark,
                          onPresed: submit,
                          focusNodeButtom: focusNodeButtom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void submit() {
    LoginViewModel().login(username.text, password.text, () {
      Navigator.of(context).pushReplacementNamed(RoutesName.home);
    });
  }
}

enum TabIndex {
  inputUsername,
  inputPassword,
  isPasswordVisible,
  buttomLogin,
}
