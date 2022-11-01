import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projector/apis/subscriptionService.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({this.priceId, this.trialDays});

  final String priceId, trialDays;
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNo, cvv, date, email;
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController card = TextEditingController(),
      monthYear = TextEditingController();

  int month, year;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Payment',
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Email id',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9),
                  TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
                    // ignore: missing_return
                    validator: (val) {
                      if (!EmailValidator.validate(val))
                        return 'Enter Valid Email';
                    },
                    autofocus: false,
                    style: TextStyle(fontSize: 16.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Card Number',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 9),
                  TextFormField(
                    onChanged: (val) {
                      cardNo = val;
                    },
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Date Of Expiry',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 134,
                          height: 50,
                          child: TextFormField(
                            controller: monthYear,
                            onChanged: (val) {
                              if (val.length == 2 && !val.contains('/')) {
                                monthYear =
                                    TextEditingController(text: val + '/');
                                monthYear.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: monthYear.text.length));

                                setState(() {});
                              }
                            },
                            textAlign: TextAlign.center,
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          width: 134,
                          height: 50,
                          child: TextFormField(
                            onChanged: (val){
                              cvv=val;
                            },
                            autofocus: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'CVV',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.18),
                  Center(
                   /* child: InkWell(
                      onTap: () {
                        if (formKey.currentState.validate())
                          try {
                            setState(() {
                              loading = true;
                            });
                            print( int.parse(monthYear.text.substring(3, 5)));
                            //TODO: PAYMENT
                            StripePayment.createTokenWithCard(
                              CreditCard(
                                number: cardNo,
                                cvc: cvv,
                                expMonth:
                                    int.parse(monthYear.text.substring(0, 2)),
                                expYear:
                                    int.parse(monthYear.text.substring(3, 5)),
                              ),
                            ).then((value) async {
                              var res = await purchaseProduct(
                                stripeToken: value.tokenId,
                                priceId: widget.priceId,
                                trial: widget.trialDays,
                                email: email,
                              );
                              // if(res)
                              setState(() {
                                loading = false;
                              });
                              Fluttertoast.showToast(
                                backgroundColor: Colors.white,
                                msg: res['message'],
                                textColor: Colors.black,
                              );
                            }).catchError((e) {
                              setState(() {
                                loading = false;
                              });
                              Fluttertoast.showToast(
                                backgroundColor: Colors.white,
                                msg: e.toString(),
                                textColor: Colors.black,
                              );
                            });
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            print(e);
                            Fluttertoast.showToast(
                              backgroundColor: Colors.white,
                              msg: e.toString(),
                            );
                          }
                      },
                      child: Container(
                        height: 50,
                        width: width * 0.36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Center(
                          child: loading
                              ? CircularProgressIndicator()
                              : Text(
                                  'Pay Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),*/
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
