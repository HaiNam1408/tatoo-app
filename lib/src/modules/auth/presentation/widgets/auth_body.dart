part of '../pages/auth_page.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key});

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.background,
      child: Center(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error) => error.whenOrNull(
                other: (message) => context.showError(message),
              ),
            );
          },
          builder: (context, state) {
            return Stack(alignment: Alignment.center, children: [
              SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Assets.images.banner.image(fit: BoxFit.cover)),
              SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(112.h),
                          Assets.images.logo.image(),
                          const Spacer(),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        context.router.push(const LoginRoute()),
                                    child: Container(
                                      height: 53.h,
                                      decoration: BoxDecoration(
                                          color: ColorName.primary,
                                          borderRadius:
                                              BorderRadius.circular(53.h / 2),
                                          border: Border.all(
                                              color: ColorName.primary)),
                                      child: Center(
                                          child: Text(
                                        'Đăng nhập',
                                        style: context.textTheme.bodyMedium
                                            .copyWith(color: ColorName.dark),
                                      )),
                                    ),
                                  ),
                                  Gap(16.h),
                                  GestureDetector(
                                    onTap: () {
                                      context.router
                                          .push(const StoreSignupRoute());
                                    },
                                    child: Container(
                                      height: 53.h,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(53.h / 2),
                                          border: Border.all(
                                              color: ColorName.primary)),
                                      child: Center(
                                          child: Text(
                                        'Dành cho khách hàng',
                                        style: context.textTheme.bodyMedium
                                            .copyWith(color: ColorName.primary),
                                      )),
                                    ),
                                  ),
                                  Gap(16.h),
                                  GestureDetector(
                                    onTap: () => context.router
                                        .push(const StoreSignupRoute()),
                                    child: Container(
                                      height: 53.h,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(53.h / 2),
                                          border: Border.all(
                                              color: ColorName.primary)),
                                      child: Center(
                                          child: Text(
                                        'Dành cho cửa hàng',
                                        style: context.textTheme.bodyMedium
                                            .copyWith(color: ColorName.primary),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                  .animate()
                  .slideY(
                      begin: 1,
                      end: 0,
                      duration: const Duration(milliseconds: 500)),
            ]);
          },
        ),
      ),
    );
  }

  // void _login(BuildContext context) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   final email = _emailTextEditingController.text;
  //   final password = _passwordTextEditingController.text;
  //   await context
  //       .read<AuthCubit>()
  //       .login(LoginRequest(email: email, password: password));
  // }
}
