import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_app/domain/model/models.dart';
import 'package:food_app/presentation/admin/admin_add_new_meal/cubit/cubit.dart';
import 'package:food_app/presentation/admin/admin_add_new_meal/cubit/states.dart';
import 'package:food_app/presentation/resources/assets_manager.dart';
import 'package:food_app/presentation/resources/routes_manager.dart';
import 'package:food_app/presentation/resources/strings_manager.dart';
import 'package:food_app/presentation/resources/styles_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../resources/appsize.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/widgets.dart';

class AdminAddNewMeal extends StatelessWidget {
  const AdminAddNewMeal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewMealCubit(),
      child: BlocConsumer<AddNewMealCubit, AddNewMealStates>(
        listener: (context, state) {
          if (state is PickImageErrorState) {
            errorToast(state.error).show(context);
          }
          if (state is AddNewMealSuccessState) {
            successToast(AppStrings.addNewMealSuccess).show(context);
          }
        },
        builder: (context, state) {
          var cubit = AddNewMealCubit.get(context);

          return state is AddNewMealLoadingState
              ? loadingScreen()
              : Scaffold(
                  appBar: AppBar(
                    title: Text(AppStrings.addNewMealScreen.toUpperCase()),
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding:  EdgeInsets.all(AppSize.s12.sp),
                          child: Column(
                            children: [
                              pickImageContainer(cubit),
                               SizedBox(height: AppSize.s25.sp),
                              textFormField(
                                cubit.titleController,
                                AppStrings.mealTitle,
                                cubit.nameErrorMessage,
                                (String value) {
                                  cubit.isNameValidFun();
                                  cubit.nameErrorMessage = cubit.nameErrorMessageFun();
                                  cubit.isAllParametersValidFun();
                                },
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              textFormField(
                                cubit.descController,
                                AppStrings.mealDescription,
                                cubit.descErrorMessage,
                                (String value) {
                                  cubit.isDescValidFun();
                                  cubit.descErrorMessage = cubit.descErrorMessageFun();
                                  cubit.isAllParametersValidFun();
                                },
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              timePicker(
                                cubit.price,
                                (value) {
                                  cubit.changePrice(value);
                                  cubit.isAllParametersValidFun();
                                },
                                AppStrings.mealPrice,
                                5,
                                100,
                                5,
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              timePicker(
                                cubit.stars,
                                (value) {
                                  cubit.changeStars(value);
                                  cubit.isAllParametersValidFun();
                                },
                                AppStrings.mealStars,
                                1,
                                5,
                                1,
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              timePicker(
                                cubit.calories,
                                (value) {
                                  cubit.changeCalories(value);
                                  cubit.isAllParametersValidFun();
                                },
                                AppStrings.mealCalories,
                                50,
                                1000,
                                50,
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              timePicker(
                                cubit.preparationTime,
                                (value) {
                                  cubit.changePreparationTime(value);
                                  cubit.isAllParametersValidFun();
                                },
                                AppStrings.mealPreparationtime,
                                1,
                                45,
                                1,
                              ),
                               SizedBox(height: AppSize.s25.sp),
                              dropDownButton(cubit, context),
                               SizedBox(height: AppSize.s100.sp),
                            ],
                          ),
                        ),
                      ),
                      // if keyboard is open hide it
                      if (MediaQuery.of(context).viewInsets.bottom == 0) bottomNavigationBar(cubit, context),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget dropDownButton(AddNewMealCubit cubit, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorManager.ligthGrey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 4,
            offset: const Offset(4, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(AppSize.s50.sp),
      ),
      child: DropdownButton<ItemCategory>(
        value: cubit.category,
        items: cubit.categoryList,
        onChanged: (ItemCategory? itemCategory) {
          cubit.onCategoryChange(itemCategory!);
          cubit.isAllParametersValidFun();
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: ColorManager.grey,
        ),
        iconSize: AppSize.s40.sp,
        isExpanded: true,
        style: getRegularStyle(color: ColorManager.orange),
        borderRadius: BorderRadius.circular(AppSize.s20.sp),
        padding:  EdgeInsets.symmetric(horizontal: AppSize.s20.sp),
        underline: Container(
            // height: 2,
            // color: ColorManager.orange,
            ),
        autofocus: false,
      ),
    );
  }

  Widget pickImageContainer(AddNewMealCubit cubit) {
    return InkWell(
      onTap: () => cubit.pickImage(),
      child: cubit.image == null
          ? Container(
              width: AppSize.s200.sp,
              decoration: BoxDecoration(
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.ligthGrey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 4,
                    offset: const Offset(4, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(AppSize.s50.sp),
              ),
              child: LottieBuilder.asset(LottieAsset.imagePicker),
            )
          : Container(
              width: AppSize.s200.sp,
              decoration: BoxDecoration(
                color: ColorManager.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.ligthGrey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 4,
                    offset: const Offset(4, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(AppSize.s50.sp),
              ),
              child: Image.file(cubit.image!),
            ),
    );
  }

  Widget bottomNavigationBar(AddNewMealCubit cubit, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: AppSize.s100.sp,
        decoration: BoxDecoration(
          color: ColorManager.white.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
              color: ColorManager.ligthGrey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 4,
              offset: const Offset(4, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(AppSize.s20.sp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.sp, vertical: AppPadding.p6.sp),
          child: Row(
            children: [
              orderStateContainer(
                  AppStrings.clientView,
                  cubit.isAllParametersValid
                      ? () {
                          Navigator.pushNamed(context, Routes.adminMealDetail,
                              arguments: AddNewMealObject(cubit.itemObject, cubit.image));
                        }
                      : () {
                          errorToast(AppStrings.itemNotValid).show(context);
                        }),
              orderStateContainer(
                AppStrings.addNewMeal,
                cubit.isAllParametersValid
                    ? () {
                        cubit.addNewMealItem();
                      }
                    : () {
                        cubit.nameErrorMessageFun();
                        cubit.descErrorMessageFun();
                        errorToast(AppStrings.itemNotValid).show(context);
                      },
              ),
              // orderStateContainer(
              //   AppStrings.clientView,
              //   cubit.isAllParametersValid(cubit.titleController.text, cubit.descController.text) ? () {} : null,
              // ),
              // orderStateContainer(
              //   AppStrings.addNewMeal,
              //   cubit.isParametersValid(cubit.titleController.text, cubit.descController.text)
              //       ? cubit.addNewMealItem
              //       : null,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderStateContainer(String name, Function()? function) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p8.sp, vertical: AppPadding.p6.sp),
        child: InkWell(
          onTap: function,
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.orange,
              borderRadius: BorderRadius.circular(AppSize.s20.sp),
            ),
            child: Center(
              child: Text(
                name,
                style: getRegularStyle(color: ColorManager.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget timePicker(int value, Function(int) function, String name, int minValue, int maxValue, int step) {
    return Row(
      children: [
        Text(
          name,
          style: getRegularStyle(color: ColorManager.orange),
        ),
        Expanded(
          child: NumberPicker(
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            onChanged: function,
            selectedTextStyle: getlargeStyle(color: ColorManager.orange),
            axis: Axis.horizontal,
            itemCount: 3,
            step: step,
          ),
        ),
      ],
    );
  }
}
