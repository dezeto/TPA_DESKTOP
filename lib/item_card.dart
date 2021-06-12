import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String restaurantName;
  final int maxPeople;
  final people = [];
  // final String status;
  final int age;
  //// Pointer to Update Function
  final Function onUpdate;
  //// Pointer to Delete Function
  final Function onDelete;

  ItemCard(this.title, this.age, this.restaurantName, this.maxPeople,
      {this.onUpdate, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            // images
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Container(
                width: double.infinity,
                height: 96,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Image.asset('assets/images/donuts.jpg'),
                  // child: Text('Image here'),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Flexible(
                          child: Container(
                              width: 140,
                              // color: Colors.blue,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                this.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          width: 100,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            this.restaurantName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        alignment: AlignmentDirectional.centerStart,
                        // color: Colors.blue,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: TextButton.icon(
                                  label: Text(
                                    this.maxPeople.toString(),
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  icon: Icon(
                                      Icons.supervised_user_circle_rounded)),
                            ),
                            Container(
                              child: TextButton.icon(
                                  label: Text(
                                    this.age.toString() + ' ago',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  icon: Icon(Icons.timer_rounded)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  // update & delete
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // update
                      TextButton.icon(
                        onPressed: () => {if (onUpdate != null) onUpdate()},
                        icon: Icon(Icons.update_rounded),
                        label: Text(''),
                      ),
                      TextButton.icon(
                        onPressed: () => {if (onDelete != null) onDelete()},
                        icon: Icon(Icons.delete_rounded),
                        label: Text(''),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // Container(
    //   width: double.infinity,
    //   // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //   padding: const EdgeInsets.all(5),
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8),
    //       border: Border.all(color: Colors.blue[900])),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(
    //             width: MediaQuery.of(context).size.width * 0.5,
    //             child: Text(title),
    //           ),
    //           Text(
    //             "$age ago",
    //           )
    //         ],
    //       ),
    //       Row(
    //         children: [
    //           SizedBox(
    //             height: 100,
    //             width: 60,
    //             child: RaisedButton(
    //                 shape: CircleBorder(),
    //                 color: Colors.green[900],
    //                 child: Center(
    //                     child: Icon(
    //                   Icons.arrow_upward,
    //                   color: Colors.white,
    //                 )),
    //                 onPressed: () {
    //                   if (onUpdate != null) onUpdate();
    //                 }),
    //           ),
    //           SizedBox(
    //             height: 40,
    //             width: 60,
    //             child: RaisedButton(
    //                 shape: CircleBorder(),
    //                 color: Colors.red[900],
    //                 child: Center(
    //                     child: Icon(
    //                   Icons.delete,
    //                   color: Colors.white,
    //                 )),
    //                 onPressed: () {
    //                   if (onDelete != null) onDelete();
    //                 }),
    //           )
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
