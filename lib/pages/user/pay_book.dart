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

class PayBook extends StatefulWidget {
  const PayBook({Key? key, this.data, this.question}) : super(key: key);
  final data, question;

  @override
  _PayBookState createState() => _PayBookState();
}

class _PayBookState extends State<PayBook> {
  bool loading = false;
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
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text('Pay for  ' + widget.data['name']),
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
                              final auth = FirebaseAuth.instance;

                              final data = {
                                'major': widget.data['major'],
                                'name': widget.data['name'],
                                'hours': widget.data['hours'],
                                'description': widget.data['description'],
                                "location": widget.data['location'],
                                "bookedOn": DateTime.now().toString(),
                              };
                              final data2 = {
                                'major': widget.data['major'],
                                'name': widget.data['name'],
                                'hours': widget.data['hours'],
                                'description': widget.data['description'],
                                "location": widget.data['location'],
                                "bookedOn": DateTime.now().toString(),
                                'by': FirebaseAuth.instance.currentUser!.email
                                    .toString()
                              };
                              FirebaseDatabase.instance.ref('Balance').child('amount').get().then((value) {

                                int amount = int.parse(value.value.toString());
                                amount+=50;
                                FirebaseDatabase.instance.ref('Balance').child('amount').set(amount);
                              });
                              FirebaseDatabase database =
                                  FirebaseDatabase.instance;
                              int balance = 0;
                              database
                                  .ref('Balance')
                                  .child('amount')
                                  .get()
                                  .then((value) {
                                setState(() {
                                  balance = int.parse(value.value.toString());
                                  balance += 50;
                                });
                                print(value.value);
                                print(balance);
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Booked successfully'),
                                action: SnackBarAction(
                                  label: 'show',
                                  onPressed: () {},
                                ),
                              ));
                              FirebaseDatabase.instance
                                  .ref('bookedClinics')
                                  .child(auth.currentUser!.uid.toString())
                                  .push()
                                  .set(data)
                                  .then((value) {
                                FirebaseDatabase.instance
                                    .ref('books')
                                    .push()
                                    .set(data2)
                                    .then((value) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) => const UserHomePage()));
                                });
                              });
                              database
                                  .ref('Balance')
                                  .child('amount')
                                  .set(balance);
                            }
                          },
                          child: Container(
                            child: Center(
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Validate and Book',
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
