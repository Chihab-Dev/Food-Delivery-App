import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/app/di.dart';
import 'package:food_app/domain/model/models.dart';
import 'package:food_app/domain/usecases/add_new_mealItem_usecase.dart';
import 'package:food_app/presentation/admin/admin_add_new_meal/cubit/states.dart';
import 'package:image_picker/image_picker.dart';

import '../../../resources/strings_manager.dart';

class AddNewMealCubit extends Cubit<AddNewMealStates> {
  AddNewMealCubit() : super(AddNewMealInitState());

  static AddNewMealCubit get(context) => BlocProvider.of(context);

  final AddNewMealItemUseCase _addNewMealItemUseCase = AddNewMealItemUseCase(instance());

  ItemObject itemObject = ItemObject("", "", "", "", 0, 0, ItemCategory.FASTFOOD, 0, 0);

  // Pick title & desc

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // pick Calories
  int calories = 200;

  void changeCalories(int value) {
    calories = value;
  }

  // pick Calories
  int preparationTime = 5;

  void changePreparationTime(int value) {
    preparationTime = value;
  }

  // Pick Image
  File? image;

  void pickImage() async {
    emit(PickImageLoadingState());
    try {
      final picker = ImagePicker();
      final pickerFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickerFile != null) {
        image = File(pickerFile.path);
        print("✅ image ✅ ");
        isImageValidFun(image);
        isAllParametersValidFun();
        emit(PickImageSuccessState());
      }
    } catch (error) {
      // print("🛑 image 🛑 $error");
      isImageValidFun(image);
      isAllParametersValidFun();
      emit(PickImageErrorState(error.toString()));
    }
  }

  // Pick Price
  int price = 20;

  void changePrice(int value) {
    price = value;
    emit(AddNewMealChangePriceValueState());
  }

  // Pick stars
  int stars = 3;

  void changeStars(int value) {
    stars = value;
    emit(AddNewMealChangeStarsValueState());
  }
  // ADD new item to database

  void addNewMealItem() async {
    print("add new meal loading");
    emit(AddNewMealLoadingState());

    (await _addNewMealItemUseCase.start(AddNewMealObject(itemObject, image))).fold(
      (failure) {
        print("🛑 ADD item error 🛑 /n ${failure.message}");
        emit(AddNewMealErrorState(failure.message));
      },
      (success) {
        image = null;
        titleController.clear();
        descController.clear();
        changePrice(20);
        category = ItemCategory.FASTFOOD;
        changeStars(3);
        changeCalories(200);
        changePreparationTime(5);

        emit(AddNewMealSuccessState());
      },
    );
  }

  // check is all parameters Valid
  bool isAllParametersValid = false;

  Future<bool> isAllParametersValidFun() async {
    if (isNameValid &&
        isDescValid &&
        isImageValid &&
        calories != 0 &&
        price != 0 &&
        preparationTime != 0 &&
        stars != 0) {
      itemObject = ItemObject(
        "",
        "",
        titleController.text,
        descController.text,
        price,
        stars,
        category,
        calories,
        preparationTime,
      );
      emit(AddNewMealIsAllParemetersValidState());
      isAllParametersValid = true;
      return true;
    } else {
      emit(AddNewMealIsAllParemetersValidState());
      isAllParametersValid = false;
      return false;
    }
  }

  //  Check is name Valid

  bool isNameValid = false;

  void isNameValidFun() {
    if (titleController.text.length >= 3 &&
        titleController.text.length <= 12 &&
        titleController.text.startsWith(" ") == false &&
        titleController.text.endsWith(" ") == false &&
        titleController.text.contains("  ") == false) {
      isNameValid = true;
    } else {
      isNameValid = false;
    }
    emit(AddNewMealIsNameValidState());
  }

  String? nameErrorMessage;

  String? nameErrorMessageFun() {
    if (titleController.text.length <= 3) {
      emit(AddNewMealNameErrorState());
      return AppStrings.nameErrorTooShort;
    }
    if (titleController.text.length > 12) {
      emit(AddNewMealNameErrorState());
      return AppStrings.nameErrorTooLong;
    }
    if (titleController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      emit(AddNewMealNameErrorState());
      return AppStrings.nameErrorContainCaracters;
    }
    if (titleController.text.startsWith(" ") ||
        titleController.text.endsWith(" ") ||
        titleController.text.contains("  ")) {
      emit(AddNewMealNameErrorState());
      return AppStrings.nameErrorContainSpaces;
    } else {
      emit(AddNewMealNameErrorState());
      return null;
    }
  }

  // void nameErrorMessageFun(String value) {
  //   if (value.length <= 3) {
  //     nameErrorMessage = AppStrings.nameErrorTooShort;
  //   } else {
  //     nameErrorMessage = null;
  //   }
  //   if (value.length > 12) {
  //     nameErrorMessage = AppStrings.nameErrorTooLong;
  //   }
  //   if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
  //     nameErrorMessage = AppStrings.nameErrorContainCaracters;
  //   }
  //   if (value.startsWith(" ") || value.endsWith(" ") || value.contains("  ")) {
  //     nameErrorMessage = AppStrings.nameErrorContainSpaces;
  //   }
  //   print("🛑 nameErrorMessageFun \n $nameErrorMessage");
  //   emit(AddNewMealNameErrorState());
  // }

// Check is desc Valid

  bool isDescValid = false;

  void isDescValidFun() {
    if (descController.text.length >= 10 &&
        descController.text.length <= 40 &&
        descController.text.startsWith(" ") == false &&
        descController.text.endsWith(" ") == false &&
        descController.text.contains("  ") == false) {
      emit(AddNewMealIsDescValidState());
      isDescValid = true;
    } else {
      emit(AddNewMealIsDescValidState());
      isDescValid = false;
    }
  }

  String? descErrorMessage;

  String? descErrorMessageFun() {
    if (descController.text.length < 10) {
      emit(AddNewMealDescErrorState());
      return AppStrings.nameErrorTooShort;
    }
    if (descController.text.length > 40) {
      emit(AddNewMealDescErrorState());
      return AppStrings.nameErrorTooLong;
    }
    if (descController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      emit(AddNewMealDescErrorState());
      return AppStrings.nameErrorContainCaracters;
    }
    if (descController.text.startsWith(" ") ||
        descController.text.endsWith(" ") ||
        descController.text.contains("  ")) {
      emit(AddNewMealDescErrorState());
      return AppStrings.nameErrorContainSpaces;
    } else {
      emit(AddNewMealDescErrorState());
      return null;
    }
  }

// check is image Valid

  bool isImageValid = false;

  void isImageValidFun(File? image) {
    image == null ? isImageValid = false : isImageValid = true;
  }

  // Select category

  List<DropdownMenuItem<ItemCategory>>? categoryList = [
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.FASTFOOD,
      child: Text(AppStrings.fastFood),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.DRINK,
      child: Text(AppStrings.drink),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.SNACK,
      child: Text(AppStrings.snack),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.DESSERT,
      child: Text(AppStrings.dessert),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.BURGER,
      child: Text(AppStrings.burger),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.PIZZA,
      child: Text(AppStrings.pizza),
    ),
    const DropdownMenuItem<ItemCategory>(
      value: ItemCategory.HOTDOG,
      child: Text(AppStrings.hotdog),
    ),
  ];

  ItemCategory category = ItemCategory.FASTFOOD;

  void onCategoryChange(ItemCategory itemCategory) {
    category = itemCategory;
    emit(AddNewMealChangeCategoryState());
  }
}
