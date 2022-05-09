import 'package:buildcondition/buildcondition.dart';
import 'package:clinic/logic/home/cubit/home_cubit.dart';
import 'package:clinic/view/screens/category_child/categoy_items/item_category.dart';
import 'package:clinic/view/screens/item/item.dart';
import 'package:clinic/view/screens/medical_supplies/items_sub.dart';
import 'package:clinic/view/screens/medical_supplies/sub_category.dart';
import 'package:clinic/view/screens/test_shimmer/shimmer_home.dart';
import 'package:clinic/view/widgets/category_item.dart';
import 'package:clinic/view/widgets/drawer_widget.dart';
import 'package:clinic/view/widgets/fotter.dart';
import 'package:clinic/view/widgets/grid_custom.dart';
import 'package:clinic/view/widgets/header_widget.dart';
import 'package:clinic/view/widgets/notification_search_title.dart';
import 'package:clinic/view/widgets/text_utils.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class SubCategoryScreen2 extends StatelessWidget {
  // int id;
  String name;

  SubCategoryScreen2({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            drawer: const DrawerPage(),
            appBar: AppBar(
              flexibleSpace: const HeaderWidget(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ),
            body: BuildCondition(
              fallback: (context) => Center(
                  child: Shimmer.fromColors(
                      child: const ShimmerLoad(),
                      baseColor: const Color(0Xff054F86),
                      highlightColor: const Color(0Xff61C089))),
              condition: state is! LoadingCategoriesState,
              builder: (context) => BuildCondition(
                  fallback: (context) => Center(
                      child: Shimmer.fromColors(
                          child: const ShimmerLoad(),
                          baseColor: const Color(0Xff054F86),
                          highlightColor: const Color(0Xff61C089))),
                  // Center(
                  //   child: TextUtils(
                  //       text: AppLocalizations.of(context)!.no_product,
                  //       color: Colors.green.shade400,
                  //       fontSize: 30,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  condition: HomeCubit.get(context).subModel != null,
                  builder: (context) => state is SuccessSubCategoriesState
                      ? Column(
                          children: [
                            NotificationSearchTitle(text: name),
                            const SizedBox(
                              height: 10,
                            ),
                            BuildCondition(
                              fallback: (context) => Expanded(
                                  child: Lottie.asset(
                                      'assets/images/no-data.json',
                                      width: 200,
                                      height: 100)),
                              condition: HomeCubit.get(context)
                                  .subModel!
                                  .data!
                                  .isNotEmpty,
                              builder: (context) => Expanded(
                                child: GridView.builder(
                                  itemCount: HomeCubit.get(context)
                                      .subModel!
                                      .data!
                                      .length,
                                  physics: const BouncingScrollPhysics(),
                                  // padding: const EdgeInsets.symmetric(horizontal: 5),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                                    itemCount: state.submodel!.data!.length,
                                    crossAxisCount: 2,
                                    // childAspectRatio: 1,
                                  ),
                                  itemBuilder: (ctxt, index) => Center(
                                    child: CategoryItemWidget(
                                        model: state.submodel!.data![index],
                                        ontap: () {
                                          if (state.submodel!.data![index]
                                              .hasChildren!) {
                                            HomeCubit.get(context)
                                                .getsubCategory(state.submodel!
                                                    .data![index].id!);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SubCategoryScreen2(
                                                          name: state
                                                              .submodel!
                                                              .data![index]
                                                              .name!)),
                                            );
                                          } else {
                                            HomeCubit.get(context)
                                                .getproductsSubCategory(
                                                    id: state.submodel!
                                                        .data![index].id!);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => ItemSubCateg(
                                                  name: state.submodel!
                                                      .data![index].name!,
                                                ),
                                              ),
                                            );
                                          }

                                          // Navigator.push(
                                          //     context,
                                          //     PageRouteBuilder(
                                          //       transitionDuration:
                                          //           Duration(seconds: 1),
                                          //       transitionsBuilder: (context, animation,
                                          //           secondaryAnimation, child) {
                                          //         animation = CurvedAnimation(
                                          //             parent: animation,
                                          //             curve: Curves.linearToEaseOut);
                                          //         return ScaleTransition(
                                          //           scale: animation,
                                          //           alignment: Alignment.center,
                                          //           child: child,
                                          //         );
                                          //       },
                                          //       pageBuilder: (context, animation,
                                          //           secondaryAnimation) {
                                          //         return ItemScreen();
                                          //       },
                                          //     ));
                                        }),
                                  ),
                                ),
                              ),
                            ),
                            FotterWidget(
                              salla1: true,
                              model:
                                  HomeCubit.get(context).contactInfoModel!.data,
                            ),
                          ],
                        )
                      : const Center(
                          child: Text('Error'),
                        )),
            ),
          );
        },
      ),
    );
  }
}