import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class OpenTradeCardData {
  const OpenTradeCardData( {
    required this.assetName,
    this.openTime,
    required this.isBuy,
    this.openPrice,
    required this.currentPrice,
    required this.profit,
    required this.digit,
    required this.sl,
    required this.swap,
    required this.type,
    required this.volume,
    required this.login,
    required this.ticket,
  });

  final String assetName;
  final String? openTime;
  final int login;
  final int ticket;
  final bool isBuy;
  final String? openPrice;
  final String currentPrice;
  final double profit;
  final int digit;
  final int sl;
  final int swap;
  final int type;
  final double volume;
}


class OpenTradeCardWidget extends StatelessWidget {
  const OpenTradeCardWidget({super.key, required this.data, this.onTap});

  final OpenTradeCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.profileCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.token_sharp,
                              color: AppColors.profileTextSecondary.withValues(
                                alpha: 0.5,
                              ),
                              size: 16,
                            ),
                            Text(
                              data.ticket.toString(),
                              style: TextStyle(
                                color: AppColors.profileTextSecondary
                                    .withValues(alpha: 0.5),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '#${data.assetName}',
                          style: const TextStyle(
                            color: AppColors.profileText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                         Text(
                              "UID: ${data.login.toString()}",
                              style: TextStyle(
                                color: AppColors.profileTextSecondary
                                    .withValues(alpha: 0.5),
                                fontSize: 10,
                              ),
                            ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${data.profit >= 0 ? '+' : ''}${data.profit.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: data.profit >= 0
                              ? AppColors.tradeProfit
                              : AppColors.tradeLoss,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                           _PriceRow(
                                label: 'Open Price:',
                                value: data.openPrice ?? '—',
                                // openTime: data.openTime,
                              ),
                            
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                data.openTime!,
                                style: TextStyle(
                                  color: AppColors.profileTextSecondary
                                      .withValues(alpha: 0.5),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        _PriceRow(
                          label: 'Current Price:',
                          value: data.currentPrice,
                          openTime: "",
                        ),
                        Divider(color: AppColors.profileTextSecondary.withValues(alpha: 0.2),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(
                            children: [
                              Text("Digit",style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),),
                              Text(data.digit.toString(),style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("SL",style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),),
                              Text(data.sl .toString(),style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Swap",style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),),
                              Text(data.swap.toString(),style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Type",style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),),
                              Text(data.type .toString(),style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),)
                            ],
                          ),
                          Column(
                            children: [
                              Text("Volume",style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),),
                              Text(data.volume.toStringAsFixed(2),style: TextStyle(color: AppColors.profileTextSecondary.withValues(alpha: 0.5), fontSize: 10),)
                            ],
                          ),
                        ],)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.openTime});

  final String label;
  final String value;
  final String? openTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.profileText, fontSize: 14),
        ),
        SizedBox(width: 10),
       Text(
              value,
              style: const TextStyle(
                color: AppColors.profileText,
                fontSize: 14,
              ),
            ),
      ],
    );
  }
}
