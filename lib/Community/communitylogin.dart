import 'package:flutter/material.dart';
import 'package:loginrace/Community/addcommunitydetails.dart';
import 'package:loginrace/Community/navigation.dart';

class CommunityLogin extends StatefulWidget {
  const CommunityLogin({super.key});

  @override
  State<CommunityLogin> createState() => _CommunityLoginState();
}

class _CommunityLoginState extends State<CommunityLogin> {
  var user=TextEditingController();
  var password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

body: Center(child: 
              Center(
                child: Container(
                
                  width: 400,
                  
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        Image.asset('images/logo1.png'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          
                          children: [
                            Padding(padding: const EdgeInsets.all(10)),
                            Text('Enter username'),
                          ],
                        ),
                        TextFormField(
                          controller: user,
                          decoration: InputDecoration(hintText: 'username',fillColor:  Color.fromARGB(111, 247, 73, 73),filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40))
                        ),
                        ),
                        SizedBox(height: 15,),
                        Container(child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.all(10)),
                            Text('Enter Password'),
                          ],
                        )),
                        TextFormField(
                          controller: password,
                          decoration: InputDecoration(hintText: 'Password',fillColor:  Color.fromARGB(111, 247, 73, 73),filled: true,
                        border:OutlineInputBorder(borderRadius: BorderRadius.circular(40))
                        ),),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
                          children: [
                             Align(
                  alignment: Alignment.centerLeft,
                  
                  child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Color.fromARGB(255, 27, 23, 229),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  
                  ),
                      Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                    print(user.text);
                    print(password.text);
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //           return GridPageView1();
                  // },));

                  }, child: Text('SIGN UP')),
                  //  child: Text(
                  //     'Sign Up',
                  //     style: TextStyle(
                  //       color: const Color.fromARGB(255, 24, 24, 24),
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),      
                            
                              
                      ),    
                          ],

                        ),
                        
                            
                            
                           
                            
                          
                        
                    SizedBox(height: 40,),
                        ElevatedButton(onPressed: (){
                       
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return  Navigation();
                  },));

                        },  style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 217, 149, 149))),
                        child: Text('Login',style: TextStyle(fontSize: 20,color: Colors.white),))
                    
                    ],
                    
                    
                    ),
                  ),
                ),
              )   
                 ),






    );
  }
}