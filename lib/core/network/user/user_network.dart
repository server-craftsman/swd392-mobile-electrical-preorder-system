import 'package:mobile_electrical_preorder_system/core/network/config/api_client.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/req/user_req.dart';
import 'package:mobile_electrical_preorder_system/core/network/user/res/register_res.dart';
import 'package:mobile_electrical_preorder_system/core/utils/format_response.dart';

class UserNetwork {
  final ApiClient _apiClient = ApiClient();

  Future<FormatResponse<RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    final response = await _apiClient.post('/user/sign-up', data: request);
    return FormatResponse(
      message: true,
      data: RegisterResponse.fromJson(response.data),
    );
  }
}
