import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;
  final List<CustomBottomNavItem> items;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00897B);
    final Color accent = Colors.deepPurple;
    final double iconSize = 28;
    final double centerSize = 56;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              if (i == 2) {
                // Placeholder for center button
                return SizedBox(width: centerSize);
              }
              final selected = currentIndex == i;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        items[i].icon,
                        color: selected ? primary : Colors.grey,
                        size: iconSize,
                      ),
                      const SizedBox(height: 4),
                      if (selected)
                        Text(
                          items[i].label,
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        // Floating Center Button
        Positioned(
          bottom: 18,
          child: GestureDetector(
            onTap: onCenterTap,
            child: Container(
              width: centerSize,
              height: centerSize,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.grid_view,
                  color: accent,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavItem {
  final IconData icon;
  final String label;
  CustomBottomNavItem({required this.icon, required this.label});
} 