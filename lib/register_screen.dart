import 'package:material_ui/material_ui.dart';

import 'core/app_colors.dart';
import 'login_screen.dart';
import 'shared/widgets/auth_curved_header.dart';
import 'main_nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Бүх талбарыг бөглөнө үү');
      return;
    }
    if (password != confirmPassword) {
      _showMessage('Нууц үгнүүд таарахгүй байна');
      return;
    }
    if (password.length < 6) {
      _showMessage('Нууц үг хамгийн багадаа 6 тэмдэгт байна');
      return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainNavScreen()));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthCurvedHeader(
              title: 'Тавтай морилно уу?',
              subtitle: 'Орлого, зарлагаа хянахад тань туслана',
              height: 280,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 36, 32, 32),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Бүтэн нэрээ оруулна уу?',
                  ),
                  const SizedBox(height: 22),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Имэйлээ оруулна уу?',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 22),
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Нууц үгээ оруулаарай',
                    isPassword: true,
                    obscure: _obscurePassword,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 22),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: 'Нууц үгээ давтан оруулаарай',
                    isPassword: true,
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E7C77),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Бүртгүүлэх',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Хэрэглэгчийн эрхтэй юу?',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Нэвтрэх',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2B8A9C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(fontSize: 15, color: AppColors.darkText),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 19,
          ),
        ),
      ),
    );
  }
}
