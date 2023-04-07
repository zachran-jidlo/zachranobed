import 'package:flutter/material.dart';

class ZachranObedColors {
  static const primary = Color.fromRGBO(192, 0, 22, 1);
  static const onPrimary = Color.fromRGBO(255, 255, 255, 1);
  final primaryLight = Color.lerp(
    const Color.fromRGBO(192, 0, 22, 0.08),
    const Color(0xFFFFFBFF),
    0.9,
  );
  static const onPrimaryLight = Color.fromRGBO(83, 67, 65, 1);
  static const secondary = Color.fromRGBO(255, 218, 214, 1);
  static const onSecondary = Color.fromRGBO(44, 21, 19, 1);
}

class ZachranObedStrings {
  static const emailAddress = 'E-mailová adresa';
  static const password = 'Heslo';
  static const login = 'Přihlásit se';
  static const logout = 'Odhlásit se';
  static const forgottenPassword = 'Zapomenuté heslo';
  static const rememberUser = 'Zapamatovat heslo';
  static const wrongCredentialsError = 'Špatné přihlašovací údaje!';
  static const requiredFieldError = 'Vyplňte prosím toto pole';
  static const invalidNumberError = 'Zadejte prosím validní číslo';
  static const requiredDropdownError = 'Vyberte prosím nějakou možnost';
  static const overview = 'Přehled';
  static const donations = 'Darované';
  static const donationList = 'Seznam darů';
  static const statistics = 'Statistiky';
  static const menu = 'Menu';
  static const change = 'Změnit';
  static const youCanDonate = 'Dnes můžete darovat ještě';
  static const youCantDonateAnymore = 'Dnes již nemůžete darovat';
  static const lastDonated = 'Naposledy darováno';
  static const savedLunches = 'Zachráněno obědů';
  static const borrowedBoxes = 'Zapůjčeno ReKrabiček';
  static const offer = 'Nabídnout';
  static const offerFood = 'Darovat pokrmy';
  static const offerLeftoverFood = 'Nabídka zbylých pokrmů';
  static const offerFoodDescription =
      'Vyplňte prosím tento formulář, který slouží k evidenci pokrmů. Děkujeme, že zachraňujete jídlo a pomáháte lidem v nouzi.';
  static const foodName = 'Název pokrmu';
  static const allergens = 'Alergeny';
  static const numberOfServings = 'Počet porcí';
  static const packaging = 'Balení';
  static const consumeBy = 'Spotřebujte do';
  static const addAnotherFood = 'Přidat další';
  static const food = 'Pokrm';
  static const summaryInfo = 'Souhrnné informace';
  static const confirmation =
      'Pokrm jste \n úspěšně darovali \n \u2764 Děkujeme, že \n pomáháte.';
  static const offerError =
      'Nabídku se \n nepodařilo odeslat. \n \u274c Zkuste to prosím \n znovu.';
  static const endOffer = 'Ukončit nabídku?';
  static const cancelTheOffer = 'Zrušit změny';
  static const continueTheOffer = 'Pokračovat v nabídce';
  static const filter = 'Filtrovat';

  static const zjLogoPath = 'assets/zj-logo.svg';
  static const placeholderImagePath = 'assets/placeholder-image.png';
  static const foodImagePath = 'assets/food-image.png';

  static const tabidooApiUrlBase =
      'https://private-anon-446cafc2fe-tabidoo.apiary-proxy.com/api/v2/apps';
}

class WidgetStyle {
  static const inputBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey));
}
