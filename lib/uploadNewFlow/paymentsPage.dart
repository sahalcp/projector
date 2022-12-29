import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:projector/apis/subscriptionService.dart';
import 'package:projector/models/subscription_plan.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/uploadNewFlow/payment_provider.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PaymentsPage extends StatefulWidget {
  static Route<PaymentsPage> route({String videoId, int uploadCount}) =>
      MaterialPageRoute(
          builder: (_) =>
              PaymentsPage(videoId: videoId, uploadCount: uploadCount));

  const PaymentsPage({Key key, this.videoId, this.uploadCount})
      : super(key: key);

  final String videoId;

  /// User's total uploads
  final int uploadCount;

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  PaymentProvider paymentProvider;

  Pay _payClient = Pay.withAssets(['apple_pay_payment_profile.json']);

  @override
  void initState() {
    paymentProvider = PaymentProvider()..initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Transform.scale(
          scale: 0.75,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: CircleBorder(),
                padding: EdgeInsets.all(0.0)),
            onPressed: () {
              if (widget.videoId != null) {
                navigateReplace(
                    context, NewListVideo(videoId: widget.videoId.toString()));
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 42.0,
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: paymentProvider,
        builder: (builderContext, child) => _body(builderContext),
      ),
    );
  }

  _body(BuildContext bodyContext) {
    final provider = bodyContext.watch<PaymentProvider>();

    if (provider.isBusy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Text(
          provider.errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final int uploadsLeft =
        (widget.uploadCount > 2) ? 0 : (3 - widget.uploadCount);

    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.45,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.transparent],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              stops: [0.0, 0.5],
            ),
          ),
          child: Image.asset(
            "images/pic.png",
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24.0),
              Text(
                "Unlock the Ultimate Personal Streaming Experience",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  "$uploadsLeft Free uploads left",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.red),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text:
                          '\$${provider.selectedPlan.amount} ${provider.selectedPlan.priceDescription}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                  text: "Your Video Streaming App \nfor ",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0),
              Text(
                "Unlimited Uploads\nUnlimited Cloud Storage",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.0),
              TextButton(
                onPressed: () {
                  showBottomSheet(bodyContext);
                },
                child: Text(
                  "More Options",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        _applePayButton(),
        SizedBox(height: 16.0),
      ],
    );
  }

  showBottomSheet(context) {
    final screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: screenSize.height * 0.6,
            child: ListView(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(24.0),
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      Divider(thickness: 1.2, height: 32.0),
                  itemCount: paymentProvider.allPlans.length,
                  itemBuilder: (context, index) {
                    final item = paymentProvider.allPlans[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(item.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0)),
                            SizedBox(width: 12.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              child: Text(item.subTitle.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Spacer(),
                            Radio<SubscriptionPlan>(
                              value: item,
                              groupValue: paymentProvider.selectedPlan,
                              onChanged: (SubscriptionPlan newPlan) {
                                if (paymentProvider.selectedPlan == newPlan)
                                  return;
                                paymentProvider.changeSelectedPlan(newPlan);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text("\$${item.amount} ${item.priceDescription}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17.0))
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.0),
                _applePayButton(),
                Text(
                  "Plans will automatically renew unless cancelled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Colors.grey),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          );
        });
      },
    );
  }

  _applePayButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: FutureBuilder<bool>(
          future: _payClient.userCanPay(PayProvider.apple_pay),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return RawApplePayButton(
                    type: ApplePayButtonType.subscribe,
                    onPressed: onApplePayPressed);
              } else {
                return ElevatedButton(
                  child: Text("CONTINUE"),
                  onPressed: () async {
                    final paymentRes = await SubscriptionService()
                        .payWithApplePay(
                            planId: paymentProvider.selectedPlan.id,
                            transactionId: "demo_1234567");
                    if (paymentRes) {
                      paymentSuccessAlert();
                    } else {
                      InfoToast.showSnackBar(context,
                          message: "Transaction failed. Please retry");
                    }
                  },
                );
              }
            } else {
              return SizedBox(
                  width: 24.0, child: const CircularProgressIndicator());
            }
          }),
    );
  }

  void onApplePayPressed() async {
    final result = await _payClient.showPaymentSelector(
      provider: PayProvider.apple_pay,
      paymentItems: [
        PaymentItem(
          label: paymentProvider.selectedPlan.productName,
          amount: paymentProvider.selectedPlan.amount.toString(),
          status: PaymentItemStatus.final_price,
        )
      ],
    );

    if (result['error'] == null) {
      final apiResult = await SubscriptionService().payWithApplePay(
          planId: paymentProvider.selectedPlan.id,
          transactionId: result['transactionId']);
      if (apiResult) {
        paymentSuccessAlert();
        return;
      }
    }
    InfoToast.showSnackBar(context, message: "Apple Pay Payment failed.");
  }

  void paymentSuccessAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Icon(
            Icons.verified,
            size: 108.0,
            color: Colors.green,
          ),
          content: Text(
            "Payment Processed successfully.\nYour Plan will be activated",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("GO BACK"))
          ],
        );
      },
    );
  }
}
