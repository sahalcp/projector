import 'package:flutter/material.dart';
import 'package:projector/paymentScreen.dart';

import 'apis/stripePayment.dart';
import 'apis/subscriptionService.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool loading = false;
  @override
  void initState() {
    //TODO: PAYMENT
   // StripeService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: [
              SizedBox(height: 10),
              Text(
                'Choose the right Projector Stream for you',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: getAllPlans(),
                builder: (context, subscription) {
                  if (subscription.hasData) {
                    return ListView.builder(
                      itemCount: subscription.data['subscriptions'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          color: Colors.white,
                          height: height * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(14),
                                height: 50,
                                width: width,
                                color: Colors.lightBlue,
                                child: Text(
                                  subscription.data['subscriptions'][index]
                                      ['name'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${subscription.data['subscriptions'][index]['unit_amount']}",

                                      // '4.95',
                                      style: TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      'user/ month',
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.storage,
                                        ),
                                        SizedBox(width: 10),
                                        Text(subscription.data['subscriptions']
                                                [index]['description'] ??
                                            ''),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            'Connect to ${subscription.data["subscriptions"][index]["max_view_request_sent"]} viewers'),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                              priceId: subscription
                                                      .data['subscriptions']
                                                  [index]['price_id'],
                                              trialDays: '7',
                                            ),
                                          ),
                                        );
                                        // var token =
                                        //     await StripeService.payWithNewCard(
                                        //   amount:
                                        //       subscription.data['subscriptions']
                                        //               [index]['unit_amount'] *
                                        //           100,
                                        //   currency: 'INR',
                                        // );
                                        // print(token);
                                        // if (token != null) {
                                        //   setState(() {
                                        //     loading = true;
                                        //   });
                                        //   var res = await purchaseProduct(
                                        //     stripeToken: token,
                                        //     email: widget.email,
                                        //     priceId: subscription
                                        //             .data['subscriptions']
                                        //         [index]['price_id'],
                                        //     trial: 7,
                                        //   );
                                        //   Fluttertoast.showToast(msg: '$res');
                                        //   print(res);
                                        //   setState(() {
                                        //     loading = false;
                                        //   });
                                        // }
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Try free for a week',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                              priceId: subscription
                                                      .data['subscriptions']
                                                  [index]['price_id'],
                                              trialDays: '0',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          'or purchase now',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
