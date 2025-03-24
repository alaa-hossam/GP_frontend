import 'dart:convert';
import 'package:gp_frontend/Models/CustomerModel.dart';
import 'package:http/http.dart' as http;

class customerViewModel {
  final String apiUrl = "https://octopus-app-n9t68.ondigitalocean.app/sanaa/api/graphql";
  customerServices customerProcesses = customerServices();

  Future<String> addUser({required birthDate,required email,required gender,required name,
    required password,required phone,required username})async{

    CustomerModel customer = CustomerModel(name: name, userName: username, password: password, email: email,phone:phone, gender: gender, birthDate: birthDate);
    return customerProcesses.addCustomer(customer);
  }

  Future<CustomerModel?> fetchUser(String id) async {
    return customerProcesses.getUser(id);
  }

  Future<String> verifyCustomer(String code , String email){
    return customerProcesses.verifyCustomer(code, email);
  }
  Future<String>resendCode(String email){

    return  customerProcesses.resendCode(email);
  }

  Future<String> logIn({required email,required password})async{
    return customerProcesses.logInCustomer(email, password);
  }

  Future<String> forgetPassCode({required email,})async{
    return customerProcesses.forgetPassGetCode(email);
  }

  Future<String> verfiyResetPassCode({required email,required code})async{
    return customerProcesses.checkResetPassCode(email, code);
  }

  Future<String> ResetPass({required email,required newPass,required confirmPass})async{
    return customerProcesses.ResetPass(email, newPass, confirmPass);
  }

  Future<String> getEmail() async {
    return customerProcesses.getUserEmail();
  }
}
