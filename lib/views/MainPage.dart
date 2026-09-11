import 'package:flutter/material.dart';
import 'HomePage.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F3233),
      body: Stack(
        children: [
          // Montanhas fixas na parte inferior da tela, um pouco mais pra baixo
          Positioned(
            left: 0,
            right: 0,
            bottom: -40,
            child: Image.asset(
              'lib/image/icons/montanhas2.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const LogoTurMe(),
                    const SizedBox(height: 28),
                    const LoginFields(),
                    const SizedBox(height: 16),
                    const LoginLinks(),
                    const SizedBox(height: 24),
                    const EntrarButton(),
                    const SizedBox(height: 40),
                    const SocialLoginSection(),
                    const SizedBox(height: 220), // respiro para as montanhas
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoTurMe extends StatelessWidget {
  const LogoTurMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'lib/image/icons/turme2.png',
          height: 150,
        ),
        Transform.translate(
          offset: const Offset(0, -8),
          child: const Text(
            'tur.me',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class LoginFields extends StatelessWidget {
  const LoginFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _LoginTextField(
          hintText: 'E-mail ou nome de usuário',
        ),
        SizedBox(height: 14),
        _LoginTextField(
          hintText: 'Senha',
          obscureText: true,
        ),
      ],
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const _LoginTextField({
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: const Color(0xFFD9D9D9),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class LoginLinks extends StatelessWidget {
  const LoginLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: navegar para recuperação de senha
          },
          child: const Text(
            'Esqueci a senha!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            // TODO: navegar para cadastro
          },
          child: const Text(
            'Cadastrar-se',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class EntrarButton extends StatelessWidget {
  const EntrarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4C7A5C),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Entrar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SocialLoginButton(
          iconAsset: 'lib/image/icons/microsoft.png',
          label: 'Entrar com a conta\nMicrosoft',
        ),
        SocialLoginButton(
          iconAsset: 'lib/image/icons/google.png',
          label: 'Entrar com a conta\nGoogle',
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String iconAsset;
  final String label;

  const SocialLoginButton({
    super.key,
    required this.iconAsset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: lógica de login social
      },
      child: Column(
        children: [
          Image.asset(
            iconAsset,
            height: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}