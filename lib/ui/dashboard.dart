// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ///Variables
//     final txtTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//         leading: Icon(Icons.menu, color: Colors.black,),
//         title: Text('',
//           style: Theme.of(context).textTheme.headlineLarge),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         actions: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.blue,
//             ),
//             // child: IconButton(onPressed: (){}, icon: Icons.traffic,),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(1),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('data',
//               style: txtTheme.bodyMedium,),
//               Text('data',
//                 style: txtTheme.headlineLarge,),
//               SizedBox(height: 10,),
//
//               ///Search Box
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border(left: BorderSide(width: 4))
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Search',
//                     style: txtTheme.headlineMedium?.apply(color: Colors.grey.withOpacity(0.5)),),
//                     Icon(Icons.mic, size: 25,)
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10,),
//
//               ///Categories
//               SizedBox(
//                 height: 45,
//                 child: ListView(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     SizedBox(
//                       width: 170,
//                       height: 50,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             height: 45,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.black54
//                             ),
//                             child: Center(
//                               child: Text('TK', style: txtTheme.headlineMedium?.apply(color: Colors.white),),
//                             ),
//                           ),
//
//                           SizedBox(width: 5,),
//
//                           const Flexible(child:
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('Task',
//                                 overflow: TextOverflow.ellipsis,),
//                               Text('10 Assigned Tasks',
//                                 overflow: TextOverflow.ellipsis,)
//                             ],
//                           ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 170,
//                       height: 50,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             height: 45,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.black54
//                             ),
//                             child: Center(
//                               child: Text('TK', style: txtTheme.headlineMedium?.apply(color: Colors.white),),
//                             ),
//                           ),
//
//                           SizedBox(width: 5,),
//
//                           const Flexible(child:
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('Task',
//                                 overflow: TextOverflow.ellipsis,),
//                               Text('10 Assigned Tasks',
//                                 overflow: TextOverflow.ellipsis,)
//                             ],
//                           ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 170,
//                       height: 50,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             height: 45,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.black54
//                             ),
//                             child: Center(
//                               child: Text('TK', style: txtTheme.headlineMedium?.apply(color: Colors.white),),
//                             ),
//                           ),
//
//                           SizedBox(width: 5,),
//
//                           const Flexible(child:
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('Task',
//                                 overflow: TextOverflow.ellipsis,),
//                               Text('10 Assigned Tasks',
//                                 overflow: TextOverflow.ellipsis,)
//                             ],
//                           ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 10,),
//
//               ///Banners
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                       child: Container(
//                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
//                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                         child: const Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Flexible(child: Image(image: AssetImage('assets/images/fcm_logo.png'),),),
//                                 Flexible(child: Image(image: AssetImage('assets/images/fcm_logo.png'),))
//                               ],
//                             ),
//
//                             SizedBox(height: 25),
//                             Text('Text',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,),
//                             Text('Text',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,),
//                           ],
//                         ),
//                       )
//                   ),
//                   SizedBox(width: 10,),
//                   Expanded(
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                             child: const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Flexible(child: Image(image: AssetImage('assets/images/fcm_logo.png'),),),
//                                     Flexible(child: Image(image: AssetImage('assets/images/fcm_logo.png'),))
//                                   ],
//                                 ),
//                                 Text('Text',
//                                   overflow: TextOverflow.ellipsis,),
//                                 Text('Text',
//                                   overflow: TextOverflow.ellipsis,),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: double.infinity,
//                             child: OutlinedButton(onPressed: (){},
//                                 child: Text('Button')),
//                           )
//                         ],
//                       ),
//                   )
//                 ],
//               ),
//
//               SizedBox(height: 10,),
//
//               ///Top Tasks
//               Text('Data',
//               style: txtTheme.headlineMedium?.apply(fontSizeFactor: 1.2)),
//               SizedBox(
//                 width: 320,
//                   height: 200,
//                 child: Container(
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text('Pending Tasks',
//                             style: txtTheme.headlineLarge,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                   const Image(image: AssetImage('assets/images/fcm_logo.png'),
//                     height: 110,
//                   )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
