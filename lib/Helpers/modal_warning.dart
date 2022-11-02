import 'package:flutter/material.dart';
import 'package:keep_notes/Widgets/text_plus.dart';

void pass(){}

void modalWarning(BuildContext context, String text,
    {bool cancelButton = false, dynamic function=pass}){
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (context) 
      => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.all(10),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: const[
              //     TextPlus(text: 'Frave ', color: Colors.amber, fontWeight: FontWeight.w500 ),
              //     TextPlus(text: 'Developer', fontWeight: FontWeight.w500),
              //   ],
              // ),

              //const SizedBox(height: 10.0),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    colors: [
                      Colors.white,
                      Colors.amber
                    ]
                  )
                ),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber
                  ),
                  child: const Icon(Icons.priority_high_rounded, color: Colors.white, size: 38),
                ),
              ),
              //const SizedBox(height: 35.0),
              const Divider(),
              TextPlus(text: text, fontSize: 17, fontWeight: FontWeight.w400 ),
              //const SizedBox(height: 20.0),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelButton ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: const TextPlus(text: 'تراجع', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold ),
                    ),
                  ) : SizedBox.fromSize(size: Size.zero,),
                  cancelButton ? SizedBox(width: 5,) : SizedBox.fromSize(size: Size.zero,),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      function();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      height: 35,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: const TextPlus(text: 'حسنًا', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold ),
                    ),
                  ),
                ],
              )
            ],
          ),
      ),
  );
}