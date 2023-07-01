import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_app/domain/model/models.dart';
import 'package:food_app/presentation/main/base_cubit/cubit.dart';
import 'package:food_app/presentation/main/base_cubit/states.dart';
import 'package:food_app/presentation/resources/appsize.dart';
import 'package:food_app/presentation/resources/color_manager.dart';
import 'package:food_app/presentation/resources/strings_manager.dart';
import 'package:food_app/presentation/resources/styles_manager.dart';
import 'package:food_app/presentation/resources/widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaseCubit, BaseStates>(
      listener: (context, state) {
        if (state is SentOrderToFirebaseErrorState) {
          errorToast(state.error).show(context);
        }
        if (state is SentOrderToFirebaseSuccessState) {
          successToast("Order Sent Success").show(context);
        }
      },
      builder: (context, state) {
        BaseCubit cubit = BaseCubit.get(context);
        // Calculate the total Price
        int totalPrice = calculateTotalPrice(cubit.userOrders);
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              AppStrings.cart.toUpperCase(),
              style: getMeduimStyle(color: ColorManager.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: cubit.orderID != null
              ? getOrderState(cubit.orderID!, cubit)
              : state is SentOrderToFirebaseLoadingState
                  ? loadingScreen()
                  : cubit.userOrders.isEmpty
                      ? emptyScreen()
                      : ordersList(cubit, totalPrice),
        );
      },
    );
  }

  Widget getOrderState(String id, BaseCubit cubit) {
    return StreamBuilder(
      stream: cubit.getRealTimeOrderState(id),
      initialData: OrderState.WAITING.toString().split('.').last,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Center(
            child: cubit.getStateWidget(snapshot.data.toString(), context),
          );
        }
      },
    );
  }

  Widget ordersList(BaseCubit cubit, int totalPrice) {
    return Stack(
      children: [
        Container(
          color: ColorManager.whiteGrey,
          padding: const EdgeInsets.only(bottom: AppPadding.p200),
          child: ListView.builder(
            itemCount: cubit.userOrders.length,
            itemBuilder: (context, index) {
              Order order = cubit.userOrders[index];
              return cartOrderContainer(order, context, cubit);
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: totalContainer(cubit, totalPrice),
        )
      ],
    );
  }

  Container totalContainer(BaseCubit cubit, int totalPrice) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.s20),
          topRight: Radius.circular(AppSize.s20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p14).copyWith(bottom: AppPadding.p10),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: AppPadding.p50),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: cubit.userOrders.length,
                itemBuilder: (context, index) {
                  Order order = cubit.userOrders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.itemObject.title,
                          style: getMeduimStyle(color: ColorManager.black),
                        ),
                        Text(
                          "\$${order.itemObject.price * order.quentity}",
                          style: getMeduimStyle(color: ColorManager.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: ColorManager.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total:",
                          style: getRegularStyle(color: ColorManager.black),
                        ),
                        const SizedBox(width: AppSize.s10),
                        Text(
                          "\$${totalPrice.toString()}",
                          style: getRegularStyle(color: ColorManager.black),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        color: ColorManager.orange,
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.orange.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          cubit.sentOrderToFirebase();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p12),
                          child: Text(
                            "Order Now",
                            style: getRegularStyle(color: ColorManager.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cartOrderContainer(Order order, BuildContext context, BaseCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10).copyWith(bottom: AppPadding.p10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                cubit.removeOrder(order);
              },
              icon: Icons.delete,
              backgroundColor: ColorManager.red,
              borderRadius: BorderRadius.circular(AppSize.s20),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          height: AppSize.s100,
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
            borderRadius: BorderRadius.circular(AppSize.s20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s20),
                    image: DecorationImage(
                      image: NetworkImage(order.itemObject.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      order.itemObject.title,
                      style: getMeduimStyle(color: ColorManager.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  if (order.quentity > 1) {
                                    order.quentity--;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.remove,
                                color: ColorManager.black,
                                size: AppSize.s25,
                              ),
                            ),
                            // const SizedBox(width: AppSize.s4),
                            Text(
                              order.quentity.toString(),
                              style: getMeduimStyle(color: ColorManager.black),
                            ),
                            // const SizedBox(width: AppSize.s4),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  if (order.quentity < 10) {
                                    order.quentity++;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: ColorManager.black,
                                size: AppSize.s25,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(width: MediaQuery.of(context).size.width / 4),
                        const SizedBox(width: AppSize.s20),
                        Text(
                          "\$${order.itemObject.price * order.quentity}",
                          style: getMeduimStyle(color: ColorManager.black),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
