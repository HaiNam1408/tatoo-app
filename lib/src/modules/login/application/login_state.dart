
	
class LoginState {
	final bool isLoading;
  final String? errorMessage;
  final String? accountName;
  final String? password;
  final bool? accountNameError;
  final bool? passwordError;
	  
	const LoginState({
		this.isLoading = false,
      this.errorMessage = '',
      this.accountName,
      this.password,
      this.accountNameError = false,
      this.passwordError = false
	});
	  
	LoginState copyWith({
		bool? isLoading,
      String? errorMessage,
      String? accountName,
      String? password,
      bool? accountNameError,
      bool? passwordError
	}) {
		return LoginState(
			isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        accountName: accountName ?? this.accountName,
        password: password ?? this.password,
        accountNameError: accountNameError ?? this.accountNameError,
        passwordError: passwordError ?? this.passwordError
		);
	}
}
