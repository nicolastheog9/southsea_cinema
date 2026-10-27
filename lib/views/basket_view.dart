import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final BasketRepository _basket = BasketRepository.instance;

  @override
  Widget build(BuildContext context) {
    final items = _basket.getItems();

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'Your basket is empty.',
                    style: TextStyle(color: cinemaFontWhite, fontSize: 18),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MY ORDER',
                      style: TextStyle(
                        color: cinemaFontWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _OrderTableHeader(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _OrderItemRow(
                            item: items[index],
                            onRemove: () {
                              setState(() {
                                _basket.removeItem(index);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: 'Service Charge',
                      amount: _basket.getServiceCharge(),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Total Due',
                      amount: _basket.getTotalDue(),
                      isEmphasized: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'UPDATE ORDER',
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/'),
                              );
                            },
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: PrimaryButton(
                            label: 'BUY TICKETS',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ticket checkout is not available yet.',
                                  ),
                                ),
                              );
                            },
                            minimumSize: const Size.fromHeight(44),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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

class _OrderTableHeader extends StatelessWidget {
  const _OrderTableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Item',
            style:
                TextStyle(color: cinemaFontWhite, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            'Details',
            style:
                TextStyle(color: cinemaFontWhite, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Price',
            textAlign: TextAlign.right,
            style:
                TextStyle(color: cinemaFontWhite, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 44),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final BasketItem item;
  final VoidCallback onRemove;

  const _OrderItemRow({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${item.quantity} ${item.quantity == 1 ? 'Ticket' : 'Tickets'}',
                style: const TextStyle(
                  color: cinemaBrand,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              '${item.quantity} Standard\n'
              '${item.movie.title}, ${item.movie.screeningTime}, '
              'Southsea Cinema Room',
              style: const TextStyle(color: cinemaFontWhite, height: 1.4),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _formatPrice(item.lineTotal),
                textAlign: TextAlign.right,
                style: const TextStyle(color: cinemaFontWhite),
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: IconButton(
              tooltip: 'Remove ${item.movie.title}',
              onPressed: onRemove,
              style: IconButton.styleFrom(
                backgroundColor: cinemaBrand,
                foregroundColor: cinemaFontWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isEmphasized;

  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isEmphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: cinemaFontWhite,
      fontSize: isEmphasized ? 18 : 16,
      fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(_formatPrice(amount), style: style),
      ],
    );
  }
}

String _formatPrice(double amount) => '£${amount.toStringAsFixed(2)}';
