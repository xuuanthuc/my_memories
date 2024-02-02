import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:my_memories/global/style/app_colors.dart';
import 'package:my_memories/global/style/app_images.dart';
import 'package:my_memories/global/utilities/toast.dart';
import '../../../global/routes/navigation_service.dart';
import '../../../global/routes/route_keys.dart';
import '../newsfeed/bloc/newsfeed_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  goToHome() async {
    _focusNode.unfocus();
    if (_controller.text.trim() == '200124') {
      navService.pushReplacementNamed(RouteKey.root);
    } else {
      appToast(
        context,
        message: "Sai mật khẩu rồi 😌",
      );
    }
  }

  @override
  void initState() {
    context.read<NewsfeedCubit>().registerToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xffFFE9F6),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.splashBackground,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Lottie.asset(AppImages.login),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppImages.loginBackground,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  Text(
                    "Je t'aime",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 36,
                      fontFamily: "Chewy",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "My home has been your heart since the day I met you!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary.withOpacity(0.5),
                        fontSize: 22,
                        fontFamily: "Chewy",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => goToHome(),
                    decoration: InputDecoration(
                        hintText: "Nhập mật mã",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => goToHome(),
                    child: Container(
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            Color(0xffEB7FB5),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Oke go go",
                          style: TextStyle(
                            fontFamily: "Chewy",
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
