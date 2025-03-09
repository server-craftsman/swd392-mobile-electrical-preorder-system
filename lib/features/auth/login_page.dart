import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:mobile_electrical_preorder_system/core/network/auth/auth_network.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthNetwork _authNetwork = AuthNetwork();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Animation controllers
  late AnimationController _animationController;
  Animation<double>? _fadeAnimation; // Changed to nullable
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadCredentials();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutQuint),
      ),
    );

    _animationController.forward();
  }

  // ... existing methods for credentials ...

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A237E), // Deep indigo
                  Color(0xFF303F9F), // Indigo
                  Color(0xFF3949AB), // Lighter indigo
                ],
              ),
            ),
          ),

          // Decorative elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Positioned(
            bottom: 150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  tooltip: 'Quay về trang chủ',
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    // Logo and app name
                    FadeTransition(
                      opacity:
                          _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/logo.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Chào mừng bạn quay trở lại',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Login form
                    SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              'Tên đăng nhập',
                              Icons.person_outline,
                              controller: _usernameController,
                              focusNode: _usernameFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_passwordFocus);
                              },
                            ),
                            SizedBox(height: 20),
                            _buildTextField(
                              'Mật khẩu',
                              Icons.lock_outline,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) {
                                _handleLogin();
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Color(0xFF1A237E),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),

                            SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: Color(0xFF1A237E),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Ghi nhớ đăng nhập',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Quên mật khẩu?',
                                    style: TextStyle(
                                      color: Color(0xFF1A237E),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30),

                            // Login button
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A237E),
                                    Color(0xFF3949AB),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF1A237E).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: _handleLogin,
                                  child: Center(
                                    child: Text(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool obscureText = false,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xFF1A237E)),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  // Keep the existing _handleLogin method
  Future<void> _handleLogin() async {
    // Your existing login logic
    try {
      if (_usernameController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng nhập đầy đủ thông tin'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 16),
              Text('Đang đăng nhập...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final accessToken = await _authNetwork.login(
        _usernameController.text,
        _passwordController.text,
        googleAccountId: "",
        fullName: "",
      );

      if (accessToken != null) {
        _saveCredentials();
        print('Access Token: $accessToken');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Decode the role from the access token
        final decodedToken = await TokenService.decodeAccessToken(accessToken);
        final role = decodedToken?['role'];

        // Navigate based on the role
        if (role != null) {
          switch (role) {
            case 'ROLE_ADMIN':
              Helper.navigateTo(context, '/admin/dashboard');
              break;
            case 'ROLE_STAFF':
              Helper.navigateTo(context, '/staff/overview');
              break;
            default:
              Helper.navigateTo(context, '/');
              break;
          }
        } else {
          // Handle case where role is not found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể xác định vai trò người dùng.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle login failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Có lỗi xảy ra. Vui lòng thử lại sau.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username');
      final savedPassword = prefs.getString('password');
      final savedRememberMe = prefs.getBool('rememberMe');

      if (savedRememberMe == true &&
          savedUsername != null &&
          savedPassword != null) {
        setState(() {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          _rememberMe = true;
        });
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('username', _usernameController.text);
        await prefs.setString('password', _passwordController.text);
        await prefs.setBool('rememberMe', true);
      } else {
        await prefs.remove('username');
        await prefs.remove('password');
        await prefs.setBool('rememberMe', false);
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }
}
