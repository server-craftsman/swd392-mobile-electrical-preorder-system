import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/user_network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  final String userId;

  const ChangePasswordPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSubmitting = false;

  final UserNetwork _userNetwork = UserNetwork();

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordRequirements);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_updatePasswordRequirements);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements() {
    if (mounted) {
      setState(() {
        // Just trigger a rebuild
      });
    }
  }

  bool _isPasswordValid(String password) {
    // Check each requirement individually
    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);

    // All requirements must be met
    return hasMinLength && hasUppercase && hasLowercase && hasDigit;
  }

  bool _hasMinLength(String password) => password.length >= 8;
  bool _hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);
  bool _hasLowercase(String password) => RegExp(r'[a-z]').hasMatch(password);
  bool _hasDigit(String password) => RegExp(r'[0-9]').hasMatch(password);

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final result = await _userNetwork.changePassword(
          userId: widget.userId,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        if (!mounted) return;

        setState(() {
          _isSubmitting = false;
        });

        if (result['success']) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );

          // Show dialog to inform user they will be logged out
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => AlertDialog(
                  title: Text('Thay đổi mật khẩu thành công'),
                  content: Text(
                    'Bạn sẽ được đăng xuất để đăng nhập lại với mật khẩu mới.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                      },
                      child: Text('Đồng ý'),
                    ),
                  ],
                ),
          );

          // Perform logout
          await _logout();
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isSubmitting = false;
        });

        // Show generic error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra khi thay đổi mật khẩu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to login screen and clear navigation stack
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      print('Error during logout: $e');
      // If logout fails, at least return to profile page
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF1A237E)),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current password field
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: 'Mật khẩu hiện tại',
                    hint: 'Nhập mật khẩu hiện tại của bạn',
                    isVisible: _isCurrentPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu hiện tại';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // New password field
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'Mật khẩu mới',
                    hint:
                        'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số',
                    isVisible: _isNewPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu mới';
                      }
                      if (value == _currentPasswordController.text) {
                        return 'Mật khẩu mới không được trùng với mật khẩu hiện tại';
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Confirm password field
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu mới',
                    isVisible: _isConfirmPasswordVisible,
                    toggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu mới';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  // Password strength hint
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F8FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mật khẩu mạnh cần:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildPasswordRequirement(
                          'Ít nhất 8 ký tự',
                          _hasMinLength(_newPasswordController.text),
                        ),
                        SizedBox(height: 8),
                        _buildPasswordRequirement(
                          'Có ít nhất 1 chữ hoa',
                          _hasUppercase(_newPasswordController.text),
                        ),
                        SizedBox(height: 8),
                        _buildPasswordRequirement(
                          'Có ít nhất 1 chữ thường',
                          _hasLowercase(_newPasswordController.text),
                        ),
                        SizedBox(height: 8),
                        _buildPasswordRequirement(
                          'Có ít nhất 1 chữ số',
                          _hasDigit(_newPasswordController.text),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Submit button
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A237E),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child:
                        _isSubmitting
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required bool isVisible,
    required Function toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      onChanged: (value) {
        if (controller == _newPasswordController) {
          _formKey.currentState?.validate();
        }
        if (controller == _confirmPasswordController) {
          _formKey.currentState?.validate();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? 'Nhập $label',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF1A237E), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFF1A237E),
          ),
          onPressed: () => toggleVisibility(),
        ),
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
        errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        errorMaxLines: 3,
      ),
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 20,
          color: isMet ? Colors.green.shade600 : Colors.grey.shade400,
        ),
        SizedBox(width: 10),
        Text(
          requirement,
          style: TextStyle(
            fontSize: 14,
            color: isMet ? Colors.green.shade800 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
