import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/cosmetic_bloc/cosmetic_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/pages/modals/opened_cosmetic_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CosmeticsPage extends StatefulWidget {
  const CosmeticsPage({super.key});

  @override
  State<CosmeticsPage> createState() => _CosmeticsPageState();
}

class _CosmeticsPageState extends State<CosmeticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CosmeticBloc>().add(GetCosmetic());
  }

  @override
  Widget build(BuildContext context) {
    Widget getImage(String url) {
      if (url.isEmpty || !url.startsWith('https://')) {
        return Image.asset(
          'assets/images/empty_image.webp',
          fit: BoxFit.contain,
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/empty_image.webp',
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }

    return BlocListener<CosmeticBloc, CosmeticState>(
      listener: (context, state) {
        if (state is CosmeticError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<CosmeticBloc>().add(GetCosmetic());
        }
      },
      child: BlocBuilder<CosmeticBloc, CosmeticState>(
        builder: (context, state) {
          if (state is CosmeticLoaded) {
            if (state.cosmeticsModel.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'У вас поки немає продукції добавте її через плюсик нижще',
                      style: MonseratStyles.montserrat14W400Black,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.cosmeticsModel.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OpenedCosmeticModal(
                            id: state.cosmeticsModel[index].id,
                            type: state.cosmeticsModel[index].type,
                            name: state.cosmeticsModel[index].name,
                            expirationDate:
                                state.cosmeticsModel[index].expirationDate,
                            openDate: state.cosmeticsModel[index].openDate,
                            remains:
                                state.cosmeticsModel[index].remains.toDouble(),
                            periodicOfUse:
                                state.cosmeticsModel[index].periodOfUse,
                            size: state.cosmeticsModel[index].size,
                            imageUrl: state.cosmeticsModel[index].imageUrl,
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: AppColors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: getImage(
                                state.cosmeticsModel[index].imageUrl,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.cosmeticsModel[index].type,
                                style: MonseratStyles.montserrat16W700Black,
                              ),
                              Text(
                                state.cosmeticsModel[index].name,
                                style: MonseratStyles.montserrat12W500Grey70,
                              ),
                              Text(
                                state.cosmeticsModel[index].periodOfUse,
                                style: MonseratStyles.montserrat14W500Black,
                              ),
                              Text(
                                state.cosmeticsModel[index].size,
                                style: MonseratStyles.montserrat14W500Black,
                              ),
                              Text(
                                'Вжити до ${DateFormat('dd/MM/yyyy').format(state.cosmeticsModel[index].expirationDate.toDate())}',
                                style: MonseratStyles.montserrat12W500Grey50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
