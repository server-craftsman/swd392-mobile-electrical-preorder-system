import 'package:flutter/material.dart';
import 'package:mobile_electrical_preorder_system/core/utils/helper.dart';
import 'package:mobile_electrical_preorder_system/core/network/auth/auth_network.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_electrical_preorder_system/core/middleware/token_middleware.dart';

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
  // final TokenService _tokenService = TokenService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Future<void> _checkToken() async {
  //   final accessToken = await TokenService.decodeAccessToken(
  //     await TokenService.getAccessToken() ?? '',
  //   );
  //   if (accessToken != null) {
  //     Helper.navigateTo(context, '/admin/dashboard');
  //   }
  // }

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
                  obscureText: true,
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    _handleLogin();
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
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
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Đăng nhập với tài khoản mạng xã hội'),
                SizedBox(height: 16),
                _buildSocialIcons(context),
                SizedBox(height: 32),
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
                // Add extra padding at bottom for keyboard
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
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
