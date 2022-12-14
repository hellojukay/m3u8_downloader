import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  var started = false;
  var process = 0.0;
  var finished = false;
  void download(String url) async {
    setState(() {
      started = true;
    });
    try {
      await Dio().download(url, "dist.tar.gz",
          options: Options(headers: {
            "authority": "mirrors.tuna.tsinghua.edu.cn",
            "user-agent":
                "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"
          }), onReceiveProgress: (count, total) {
        setState(() {
          process = count / (total * 1.0);
          if (count == total) {
            debugPrint("finished");
            setState(() {
              finished = true;
            });
          }
          debugPrint("$count");
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('download')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: 'url'),
                    controller: controller,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      download(controller.text);
                    },
                    child:
                        started ? const Text('stop') : const Text('download'))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (started)
                  Expanded(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: LinearProgressIndicator(
                        minHeight: 20,
                        color: Colors.blue,
                        backgroundColor: Colors.grey,
                        value: process,
                      ),
                    ),
                  ),
                if (started)
                  SizedBox(
                      width: 60,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("${(process * 100).toStringAsFixed(2)}%"),
                      ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            if (finished)
              const Text(
                "Finished",
                style: TextStyle(fontSize: 30),
              )
          ],
        ),
      ),
    );
  }
}
