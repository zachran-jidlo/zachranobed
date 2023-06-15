import 'package:flutter/material.dart';

class ZachranObedColors {
  static const primary = Color.fromRGBO(192, 0, 22, 1);
  static const onPrimary = Color.fromRGBO(255, 255, 255, 1);
  static const primaryLight = Color.fromRGBO(248, 223, 229, 1);
  static const onPrimaryLight = Color.fromRGBO(83, 67, 65, 1);
  static const secondary = Color.fromRGBO(255, 218, 214, 1);
  static const onSecondary = Color.fromRGBO(44, 21, 19, 1);
  static const borderColor = Color.fromRGBO(216, 194, 191, 1);
  static const cardBackground = Color.fromRGBO(255, 251, 255, 1);
  static const onCardBackground = Color.fromRGBO(119, 86, 83, 1);
  static const disabledButtonChild = Color.fromRGBO(28, 27, 31, 0.16);
}

class ZachranObedStrings {
  static const emailAddress = 'E-mailová adresa';
  static const password = 'Heslo';
  static const login = 'Přihlásit se';
  static const logout = 'Odhlásit se';
  static const forgottenPassword = 'Zapomenuté heslo';
  static const wrongCredentialsError = 'Špatné přihlašovací údaje!';
  static const requiredFieldError = 'Vyplňte prosím toto pole';
  static const invalidNumberError = 'Zadejte prosím validní číslo';
  static const invalidAllergensFormatError =
      'Zadejte prosím alergeny ve správném formátu';
  static const requiredDropdownError = 'Vyberte prosím nějakou možnost';
  static const packagingRekrabicka = 'REkrabička';
  static const packagingIkeaBox = 'IKEA krabička';
  static const packagingDisposable = 'jednorázový obal';
  static const newOffer = 'Nová nabídka';
  static const overview = 'Přehled';
  static const donations = 'Darované';
  static const loadMoreDonations = 'Načíst další';
  static const thisWeek = 'Tento týden';
  static const lastWeek = 'Minulý týden';
  static const menu = 'Menu';
  static const youCanDonate = 'Kurýra můžete přivolat ještě';
  static const youCantDonateAnymore = 'Dnes již nemůžete darovat';
  static const courierWillCome = 'Kurýr přijede přibližně mezi';
  static const contactCarrier = 'Kontaktovat dopravce';
  static const callACourier = 'Přivolat kurýra';
  static const deliveryConfirmedState = 'Potvrzeno';
  static const deliveryCancelledState = 'Storno';
  static const lastDonated = 'Naposledy darováno';
  static const savedLunches = 'Zachráněno obědů';
  static const total = 'Celkem';
  static const lastThirtyDays = 'Za posledních 30 dní';
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
  static const consent =
      'Kliknutím na tlačítko “Darovat pokrmy” potvrzuji, že pokrmy jsou darované po zavírací době podniku a splňují všechny požadavky stanovené správnou hygienickou praxí. Přehled podmínek je uvedený v příručce ';
  static const manualName = 'Jak darovat hotové pokrmy.';
  static const confirmation =
      'Pokrm jste úspěšně darovali \u2764. Děkujeme, že pomáháte.';
  static const offerError =
      'Nabídku se \n nepodařilo odeslat. \n \u274c Zkuste to prosím \n znovu.';
  static const endOffer = 'Zahodit nabídku?';
  static const cancelTheOffer = 'Zahodit';
  static const continueTheOffer = 'Pokračovat';
  static const cancel = 'Zrušit';
  static const cancelOfferDialogContent =
      'Máte rozpracovanou nabídku. Opravdu si ji přejete zahodit?';
  static const newOfferDialogContent =
      'Abyste mohli zadat novou nabídku, musíte nejdříve přivolat kurýra.';
  static const cantOfferAnymoreDialogContent =
      'Právě teď není možné nabídnout zbylé pokrmy. Pokud se vám to stává často, upravte si rozvrh tak, aby lépe odpovídal vašim potřebám pro darování.';
  static const filter = 'Filtrovat';

  static const zjLogoPath = 'assets/zj-logo.svg';
  static const placeholderImagePath = 'assets/placeholder-image.png';
  static const foodImagePath = 'assets/food-image.png';

  static const tabidooApiUrlBase =
      'https://private-anon-3321195636-tabidoo.apiary-proxy.com/api/v2/apps';
}

class WidgetStyle {
  static const inputBorder =
      OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.grey));
}
