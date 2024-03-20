import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarButton extends StatelessWidget {
  final double imageSize;
  const AvatarButton({
    super.key,
    this.imageSize = 100,
  });

  get responsive => null;
  
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black26,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: Image.network(
            'https://cdn.iconscout.com/icon/free/png-256/free-avatar-372-456324.png',
            width: imageSize,
            height: imageSize,
          ),
        ),
      ],
    );
  }
}
