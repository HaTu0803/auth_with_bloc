import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/bloc/auth_bloc.dart';
import '../signup/signup_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final email = TextEditingController();
  final password = TextEditingController();
  bool visibil = true;

  String? emailError;
  String? passwordError;
  String? loginError;

  static const String sampleEmail = "htttu0803@gmail.com";
  static const String samplePassword = "Mobile@123";
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  void validateLogin() {
    setState(() {
      emailError =
          email.text.isEmpty
              ? "Please enter your email"
              : (!RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  ).hasMatch(email.text)
                  ? "Invalid email format"
                  : null);

      passwordError =
          password.text.isEmpty ? "Please enter your password" : null;
    });

    if (emailError == null && passwordError == null) {
      if (email.text == sampleEmail && password.text == samplePassword) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        context.read<AuthBloc>().add(
          AuthLoginStarted(email: email.text, password: password.text),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginFailure) {
              setState(() {
                loginError = state.message;
              });
            } else if (state is AuthLoginSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                logo(),
                const SizedBox(height: 70),
                emailField(),
                const SizedBox(height: 15),
                passwordField(),
                const SizedBox(height: 20),
                forgotPassword(),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => loginButton(state),
                ),
                const SizedBox(height: 20),
                orDivider(),
                const SizedBox(height: 30),
                socialButtons(),
                const SizedBox(height: 30),
                haveAccountText(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: email,
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: const Icon(Icons.email),
          errorText: emailError,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.emailAddress,
        focusNode: _focusNode1,
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: password,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: const Icon(Icons.lock),
          errorText: passwordError,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: IconButton(
            icon: Icon(visibil ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => visibil = !visibil),
          ),
        ),
        obscureText: visibil,
        focusNode: _focusNode2,
      ),
    );
  }

  Padding loginButton(AuthState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: state is AuthLoginInProgress ? null : validateLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white, // Add this to ensure text is white
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              state is AuthLoginInProgress
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Explicitly set text color
                    ),
                  ),
        ),
      ),
    );
  }

  Row orDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(thickness: 1.5, endIndent: 4, indent: 20),
        ),
        Text(
          "Or continue with",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const Expanded(
          child: Divider(thickness: 1.5, endIndent: 20, indent: 4),
        ),
      ],
    );
  }

  Widget socialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        socialLoginButton('images/google.png'),
        const SizedBox(width: 20),
        socialLoginButton('', icon: Icons.apple),
      ],
    );
  }

  Padding socialLoginButton(String imagePath, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child:
            imagePath.isNotEmpty
                ? Image.asset(imagePath, height: 30)
                : Icon(icon, color: Colors.black, size: 30),
      ),
    );
  }

  Padding haveAccountText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?  ",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
            child: Text(
              "Forgot Password?",
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding logo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Image.asset(
        'images/logo.png',
        width: 160,
        height: 160,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
