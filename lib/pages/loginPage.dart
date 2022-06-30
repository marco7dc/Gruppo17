import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //variable for the function login
  final username = "3Moschettieri";
  final pass = "30L";
  var usercontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

// we need to collect what the user write in the textbox
  @override
  void dispose() {
    usercontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[600],
      appBar: AppBar(
        title: const Text(
          "Login Page",
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.redAccent,
                    primaryColorDark: Colors.red,
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: usercontroller,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(84, 110, 122, 1),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.red),
                        ),
                        hintText: "Username"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(84, 110, 122, 1),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                      hintText: "Password"),
                ),
                const SizedBox(
                  height: 40,
                ),
                // when the user click this button we control if username and
                //password in the textbox and our credential are the same
                // if they are correct we go to the app, otherwise we will show "wrong credential"
                // message and come back to the login
                ElevatedButton(
                  onPressed: () {
                    if (usercontroller.text != username ||
                        passwordcontroller.text != pass) {
                      setState(
                        () {
                          usercontroller = TextEditingController();
                          passwordcontroller = TextEditingController();
                          const LoginPage();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Wrong credentials",
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                        },
                      );
                    } else {
                      setState(() {
                        usercontroller = TextEditingController();
                        passwordcontroller = TextEditingController();
                        const LoginPage();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Welcome",
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                      });
                      Navigator.pushNamed(context, "tab",
                          arguments: usercontroller.text);
                    }
                  },
                  child: const Text("Log In"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shadowColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(10),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
