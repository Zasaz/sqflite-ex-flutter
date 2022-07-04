import 'package:flutter/material.dart';

class AppBarBanner extends StatefulWidget {
  const AppBarBanner({Key key}) : super(key: key);

  @override
  State<AppBarBanner> createState() => _AppBarBannerState();
}

class _AppBarBannerState extends State<AppBarBanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Column(
            children: [
              Text(
                'AppBarBanner',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                width: double.infinity,
                height: 30,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
