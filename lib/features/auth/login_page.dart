import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:mobile_electrical_preorder_system/core/network/auth/auth_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthNetwork _authNetwork = AuthNetwork();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  void _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
    await prefs.setBool('rememberMe', _rememberMe);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () {
              Helper.navigateTo(context, '/');
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/images/logo.jpg', height: 40),
              ),
              SizedBox(width: 8),
              Text('Elecee', style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz_outlined, color: Colors.grey),
              onPressed: () {
                Helper.navigateTo(context, '/setting');
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ), // 20% of the screen height
                Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                _buildConstrainedTextField(
                  'Username',
                  'Nhập username của bạn',
                  controller: _usernameController,
                  focusNode: _usernameFocus,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                ),
                SizedBox(height: 16),
                _buildConstrainedTextField(
                  'Mật khẩu',
                  'Nhập mật khẩu của bạn',
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _handleLogin();
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor:
                              Colors.black, // Set the active color to red
                        ),
                        Text('Remember me'),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Khôi phục mật khẩu',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // Text('Đăng nhập với tài khoản mạng xã hội'),
                // SizedBox(height: 16),
                // _buildSocialIcons(context),
                // SizedBox(height: 32),
                // GestureDetector(
                //   onTap: () {
                //     Helper.navigateTo(context, '/signup');
                //   },
                //   child: Text.rich(
                //     TextSpan(
                //       text: 'Bạn chưa có tài khoản? ',
                //       children: [
                //         TextSpan(
                //           text: 'Đăng ký tài khoản',
                //           style: TextStyle(color: Colors.blue),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
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
              Helper.navigateTo(context, '/home');
              break;
            // Add more roles and their corresponding routes as needed
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
              'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildConstrainedTextField(
    String label,
    String hint, {
    bool obscureText = false,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        cursorColor: Colors.red,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            try {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(width: 16),
                      Text('Đang đăng nhập với Google...'),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ),
              );

              final url = await _authNetwork.socialLogin();
              if (url != null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Không thể mở trình duyệt'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Không thể kết nối đến máy chủ. Vui lòng thử lại sau.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: _buildSocialIcon(
            Icons.g_mobiledata_sharp,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, {TextStyle? style}) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: Icon(icon, color: style?.color ?? Colors.blue),
    );
  }
}
