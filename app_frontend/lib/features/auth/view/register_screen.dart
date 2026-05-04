import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../model/register_model.dart';
import '../service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthService()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(fullNameController, "Full Name"),
                  _buildTextField(usernameController, "Username"),
                  _buildTextField(emailController, "Email"),
                  _buildTextField(mobileController, "Mobile"),
                  _buildTextField(
                    passwordController,
                    "Password",
                    isPassword: true,
                  ),
                  _buildTextField(
                    confirmPasswordController,
                    "Confirm Password",
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final model = RegisterModel(
                              fullName: fullNameController.text.trim(),
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              mobile: mobileController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmPassword:
                                  confirmPasswordController.text.trim(),
                            );

                            context.read<AuthBloc>().add(RegisterEvent(model));
                          }
                        },
                        child: const Text("Register"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label required";
          }

          if (label == "Email" && !value.contains("@")) {
            return "Enter valid email";
          }

          if (label == "Mobile" && value.length != 10) {
            return "Enter valid mobile";
          }

          if (label == "Confirm Password" && value != passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
