import 'package:flutter/material.dart';
import '../Firebase/firebaseAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage;
  bool islogin = true;
  bool isPasswordVisible = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInwithEmailandPassword() async {
    try {
      final User? user = await FirebaseAuthService(FirebaseAuth.instance)
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text);
      if (user == null) {
        setState(() {
          errorMessage = 'No user found for that email.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserwithEmailandPassword() async {
    try {
      final User? user = await FirebaseAuthService(FirebaseAuth.instance)
          .createUserWithEmailAndPassword(
              emailController.text, passwordController.text);
      if (user == null) {
        setState(() {
          errorMessage = 'No user found for that email.';

        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  //
  // Widget title() {
  //   return const Text(
  //     'firebase_auth',
  //   );
  // }

  Widget signInTitle() {
    return // Generated code for this Text Widget...
        Center(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // onTap: () async {
        //   setState(() {
        //     _model.create = false;
        //   });
        // },
        child: Text(
          'Sign In',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: islogin ? const Color(0xFF101213) : const Color(0xFF57636C),
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget loginText() {
    return const Padding(
      padding: EdgeInsets.only(top: 140.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Green',
              style: TextStyle(
                color: Color(0xFF00B860),
                fontSize: 50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
                height: 0,
                letterSpacing: -2.24,
              ),
            ),
            TextSpan(
              text: 'Eats',
              style: TextStyle(
                color: Color.fromARGB(255, 89, 89, 89),
                fontSize: 50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w900,
                height: 0,
                letterSpacing: -2.24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget entyfield() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80.0),
            child: TextFormField(
              controller: emailController,
              autofocus: true,
              autofillHints: const [AutofillHints.email],
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E3E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(24),
              ),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF101213),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
            child: TextFormField(
              controller: passwordController,
              autofillHints: const [AutofillHints.password],
              obscureText:
                  !isPasswordVisible, // You need to replace this with your actual variable
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Color(0xFF57636C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E3E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5963),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(24),
                suffixIcon: InkWell(
                  onTap: () => setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    }, // You need to replace this with your actual function
                  ),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF57636C),
                    size: 24,
                  ),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF101213),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget errorMessageText() {
    return Text(
      errorMessage ?? '',
      style: const TextStyle(color: Colors.red),
    );
  }

  Widget submitButton() {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(

        padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 10),
        child: ElevatedButton(
          onPressed: () async {
            if (islogin) {
              await signInwithEmailandPassword();
            } else {
              await createUserwithEmailandPassword();
            }
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(230, 52)),
            backgroundColor:
                MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
            elevation: MaterialStateProperty.all(3),
            side: MaterialStateProperty.all(const BorderSide(
              color: Colors.transparent,
              width: 1,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            )),
          ),
          child: Text(
            islogin ? 'Log In' : 'Create Account',

            // ignore: prefer_const_constructors
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget loginOrRegisterButton() {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              islogin = !islogin;
            });
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(230, 52)),
            backgroundColor:
                MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
            elevation: MaterialStateProperty.all(3),
            side: MaterialStateProperty.all(const BorderSide(
              color: Colors.transparent,
              width: 1,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            )),
          ),
          child: Text(
            islogin ? 'Create Account' : 'Log In',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  Widget previlageText() {
    return const Text(


        'Only accessible in NSBM green university ',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 10,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w900,


        ),

    );
  }

  // Widget backGroundImage() {
  //   return Container(
  //     width: double.infinity,
  //     height: double.infinity,
  //     decoration: const BoxDecoration(
  //       image: DecorationImage(
  //         image: AssetImage('assets/images/food.jpg'),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/food.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loginText(),
              //signInTitle(),
              entyfield(),
              errorMessageText(),
              submitButton(),
              loginOrRegisterButton(),
              previlageText(),
            ],
          ),
        ),
      ),
    );
  }
}
