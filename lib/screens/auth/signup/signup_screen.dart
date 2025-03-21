import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool visibil = true;
  String? emailError, passwordError, confirmPasswordError, nameError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateSignUp() {
    setState(() {
      emailError =
          emailController.text.isEmpty
              ? "Please enter your email"
              : (!RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                  ).hasMatch(emailController.text)
                  ? "Invalid email format"
                  : null);

      passwordError =
          passwordController.text.isEmpty
              ? "Please enter your password"
              : (!RegExp(
                    r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                  ).hasMatch(passwordController.text)
                  ? "Must have 8+ chars, 1 uppercase, 1 special char, 1 number"
                  : null);

      confirmPasswordError =
          confirmPasswordController.text.isEmpty
              ? "Please confirm your password"
              : (confirmPasswordController.text != passwordController.text
                  ? "Passwords do not match"
                  : null);

      nameError = nameController.text.isEmpty ? "Please enter your name" : null;
    });

    if (emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        nameError == null) {
      context.read<AuthBloc>().add(
        AuthRegisterStarted(
          email: emailController.text,
          password: passwordController.text,
          username: nameController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthRegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AuthRegisterSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                logo(),
                const SizedBox(height: 20),
                inputField(
                  emailController,
                  "Email",
                  Icons.email,
                  errorText: emailError,
                ),
                const SizedBox(height: 20),
                inputField(
                  nameController,
                  "Name",
                  Icons.person,
                  errorText: nameError,
                ),
                const SizedBox(height: 20),
                inputField(
                  passwordController,
                  "Password",
                  Icons.lock,
                  obscureText: visibil,
                  suffixIcon: true,
                  errorText: passwordError,
                ),
                const SizedBox(height: 20),
                inputField(
                  confirmPasswordController,
                  "Confirm Password",
                  Icons.lock,
                  obscureText: visibil,
                  errorText: confirmPasswordError,
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return signupButton(state);
                  },
                ),
                const SizedBox(height: 20),
                orDivider(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialLoginButton('images/google.png'),
                    const SizedBox(width: 20),
                    socialLoginButton('', icon: Icons.apple),
                  ],
                ),
                const SizedBox(height: 40),
                haveAccountText(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
    bool suffixIcon = false,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          errorText: errorText,
          suffixIcon:
              suffixIcon
                  ? IconButton(
                    onPressed: () => setState(() => visibil = !visibil),
                    icon: Icon(
                      visibil ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Padding signupButton(AuthState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: state is AuthRegisterInProgress ? null : validateSignUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              state is AuthRegisterInProgress
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            "Already have an account?",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              " Login",
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

  Padding logo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Image.asset('images/logo.png', width: 160, height: 160),
    );
  }
}
