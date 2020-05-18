import 'package:flutter/cupertino.dart';
import 'package:flutterapp/helper/helperfunctions.dart';
import 'package:flutterapp/helper/theme.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/chatrooms.dart';
import 'package:flutterapp/widget/widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/helper/constants.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  List<String> profList = ['weaver', 'list1',  'list2'];
  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (var iprof in profList) {
      String profession = iprof;
      var newItem = DropdownMenuItem(
        child: Text(profession),
        value: profession,

      );

      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }
  String userName;
  String fullName;
  String password;
  String userEmail;
  String userAddress;
  String prof = "list1";

  bool showSpinner = false;

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {
    try {
      await authService.signUpWithEmailAndPassword(userEmail,
          password).then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "fullName": fullName,
            "userName": userName,
            "userEmail": userEmail,
            "userAddress": userAddress,
            "userProfession": prof,

          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userName);
          HelperFunctions.saveFullNameSharedPreference(fullName);
          HelperFunctions.saveUserEmailSharedPreference(userEmail);
          HelperFunctions.saveAddressSharedPreference(userAddress);
          HelperFunctions.saveProfSharedPreference(prof);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: kBorderColor,
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Welcome,",
                  style:
                  TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Create New Account",
                  style:
                  TextStyle(fontSize: 20, color: Colors.blueGrey[400], fontWeight: FontWeight.bold),
                ),
                Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: TextStyle(fontSize: 14,color: Colors.blueGrey[400],fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey[600]),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kBorderColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        onChanged: (value) {
                          fullName = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(fontSize: 14,color: Colors.blueGrey[400],fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey[600]),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kBorderColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 58.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: Colors.blueGrey[600], style: BorderStyle.solid, width: 0.80),
                        ),
                        child: DropdownButton(
                          style: TextStyle(
                            color: Colors.blueGrey[400],
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                            isExpanded: true,
                            underline: SizedBox(
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down
                            ),
                            value: prof,
                            items: getDropdownItems(),
                            onChanged: (value) {
                              setState(() {
                                prof = value;
                              });
                            },
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14,color: Colors.blueGrey[400],fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey[600]),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kBorderColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          userEmail = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14,color: Colors.blueGrey[400],fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey[600]),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: kBorderColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],

                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: (){
                      showSpinner = true;
                      singUp();
                    },
                    padding: EdgeInsets.all(0),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff0be578),
                            Color(0xFF53D192),
                            Color(0xff00bbff),
                          ],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(maxWidth: double.infinity,minHeight: 50),
                        child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        "SignIn now",
                        style: TextStyle(
                            color: kBorderColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}
