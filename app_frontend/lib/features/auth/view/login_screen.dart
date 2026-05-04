// import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
// import 'package:app_frontend/features/auth/bloc/auth_event.dart';
// import 'package:app_frontend/features/auth/bloc/auth_state.dart';
// import 'package:app_frontend/features/auth/model/login_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginForm extends StatefulWidget {
//   final VoidCallback onToggleToRegister;
//   const LoginForm({super.key, required this.onToggleToRegister});

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is AuthSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message), backgroundColor: Colors.green),
//           );
//           // After login success, go to Home
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.pushReplacementNamed(context, '/home');
//           });
//         } else if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.error), backgroundColor: Colors.red),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Email Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextFormField(
//                   controller: emailController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     hintText: 'Email Address',
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Email required';
//                     if (!value.contains('@')) return 'Enter valid email';
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Password Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     hintText: 'Password',
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Password required';
//                     return null;
//                   },
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Forgot Password
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Reset password link sent!')),
//                     );
//                   },
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(color: Color(0xFFFFD700)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               // Sign In Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: state is AuthLoading
//                       ? null
//                       : () {
//                           if (_formKey.currentState!.validate()) {
//                             final model = LoginModel(
//                               identifier: emailController.text.trim(),
//                               password: passwordController.text.trim(),
//                             );
//                             context.read<AuthBloc>().add(LoginEvent(model));
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFFD700),
//                     foregroundColor: Colors.black87,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   child: state is AuthLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
//                         )
//                       : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               // Apply to Drive link (toggles to register)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('New to the fleet? ', style: TextStyle(color: Colors.grey)),
//                   GestureDetector(
//                     onTap: widget.onToggleToRegister,
//                     child: const Text(
//                       'Apply to Drive',
//                       style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }

import 'package:app_frontend/features/auth/bloc/auth_bloc.dart';
import 'package:app_frontend/features/auth/bloc/auth_event.dart';
import 'package:app_frontend/features/auth/bloc/auth_state.dart';
import 'package:app_frontend/features/auth/model/login_model.dart';
import 'package:app_frontend/features/auth/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onToggleToRegister;
  const LoginForm({super.key, required this.onToggleToRegister});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Email Field (UPDATED)
              AppTextField(
                controller: emailController,
                hintText: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password Field (UPDATED)
              AppTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Forgot Password (UNCHANGED)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset password link sent!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFFFFD700)),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sign In Button (UNCHANGED)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      state is AuthLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              final model = LoginModel(
                                identifier: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              context.read<AuthBloc>().add(LoginEvent(model));
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      state is AuthLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black87,
                            ),
                          )
                          : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 24),

              // Register Link (UNCHANGED)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to the fleet? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: widget.onToggleToRegister,
                    child: const Text(
                      'Apply to Drive',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
