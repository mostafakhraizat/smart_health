import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:smart_health/constants/constants.dart';
import 'package:smart_health/pages/user/home_user.dart';

class PayQuestion extends StatefulWidget {
  const PayQuestion({Key? key, this.data, this.question,required this.balance}) : super(key: key);
  final data, question;
  final int balance;
  @override
  _PayQuestionState createState() => _PayQuestionState();
}

class _PayQuestionState extends State<PayQuestion> {
  bool loading = false;
  int balance = 0;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(widget.data);

    print(widget.balance);
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text('Pay for Dr. ' + widget.data['username']),
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Text('An ammount of 50 dollars will be payed.',style: TextStyle(
                  fontStyle: FontStyle.italic
                ),),
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.red,
                  backgroundImage:
                      useBackgroundImage ? 'assets/card_bg.png' : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.black,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                                FirebaseDatabase database = FirebaseDatabase.instance;


                                User user = FirebaseAuth.instance.currentUser!;
                                final question = {
                                  "sender":user.uid.toString(),
                                  "reciever":widget.data['uid'],
                                  'question':widget.question,
                                  "date":DateTime.now().toString(),
                                  "reply":"no reply yet"
                                };
                              FirebaseDatabase.instance.ref('Balance').child('amount').get().then((value) {

                                int amount = int.parse(value.value.toString());
                                amount+=50;
                                FirebaseDatabase.instance.ref('Balance').child('amount').set(amount);
                              });
                                database.ref('Questions').push().set(question).then((value) {
                                  Future.delayed(const Duration(seconds: 2), () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (c) => const UserHomePage()));

                                  });
                                }).onError((error, stackTrace) {
                                  print(error);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Oups, something went wrong, try again!")));
                                });


                              print('valid!');
                            } else {
                              print('invalid!');
                            }
                          },
                          child: Container(
                            child: Center(
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Validate and proceed',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Mulish'),
                                    ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Constants.primary),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

}
