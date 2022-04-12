import 'package:buildcondition/buildcondition.dart';
import 'package:clinic/applocal.dart';
import 'package:clinic/logic/home/cubit/home_cubit.dart';
import 'package:clinic/model/medical_supplies.dart';
import 'package:clinic/view/screens/category_child/categoy_items/category_items.dart';
import 'package:clinic/view/screens/category_child/product_category/products_category.dart';
import 'package:clinic/view/screens/medical_supplies/sub_category.dart';
import 'package:clinic/view/widgets/auth/auth_button.dart';
import 'package:clinic/view/widgets/category_and_title.dart';
import 'package:clinic/view/widgets/drawer_widget.dart';
import 'package:clinic/view/widgets/fotter.dart';
import 'package:clinic/view/widgets/grid_custom.dart';
import 'package:clinic/view/widgets/header_widget.dart';
import 'package:clinic/view/widgets/notification_search_title.dart';
import 'package:clinic/view/widgets/title_primary_title.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            drawer: DrawerPage(),
            appBar: AppBar(
              flexibleSpace: HeaderWidget(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ),
            body: BuildCondition(
              fallback: (context) => Center(
                  child: EasyLoader(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
                backgroundColor: Colors.grey.shade300,
                // iconSize: 20,
                iconColor: Color(0Xff054F86),
              )),
              condition: HomeCubit.get(context).medicalModel?.data != null,
              builder: (context) => Column(
                children: [
                  NotificationSearchTitle(
                    text: '${AppLocalizations.of(context)!.medical_Supplies}',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 5,
                        // padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
                                itemCount: 5,
                                childAspectRatio: 1.2,
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 1),
                        itemBuilder: (ctxt, index) {
                          return CategoryChild(
                            model: HomeCubit.get(context)
                                .medicalModel!
                                .data![index],
                            index: index,
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FotterWidget(
                    salla1: true,
                    model: HomeCubit.get(context).contactInfoModel!.data,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryChild extends StatelessWidget {
  MedicalSuppliesData? model;
  int? index;
  CategoryChild({Key? key, this.model, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoryandTitle(
        height: 100,
        width: 100,
        text: '${model!.name}',
        imgurl: '${HomeCubit.get(context).img[index!]}',
        ontap: () {
          if (model!.hasChildren!) {
            HomeCubit.get(context).getsubCategory(model!.id!);
          } else {
            HomeCubit.get(context).getproductDetails(id: model!.id);
          }
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                animation = CurvedAnimation(
                    parent: animation, curve: Curves.linearToEaseOut);
                return ScaleTransition(
                  scale: animation,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                if (model!.hasChildren!) {
                  return SubCategoryScreen(name: model!.name!);
                } else {
                  return ProductCategory(id: model!.id!, name: model!.name!);
                  // return CategoryItemsScreen(
                  //     id: model!.id!, name: model!.name!);
                }
              },
            ),
          );
        });
  }
}