import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restapis_get_post_delete/Provider/user_provider.dart';
import 'package:restapis_get_post_delete/controller/data_service.dart';
import 'package:restapis_get_post_delete/list_data_card.dart';
import 'package:restapis_get_post_delete/models/data_model.dart';
import 'package:restapis_get_post_delete/size_config.dart';
import 'package:quds_ui_kit/quds_ui_kit.dart';
import 'package:restapis_get_post_delete/view/sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DataService dataService = DataService();


 // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.users = await DataService().getData();
      userProvider.notifyListeners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('hh:mm a').format(now);
      String formattedDate = DateFormat('EEE d MMM').format(now);
      String firstName,lastName,id,email,url;


      TextEditingController _firstName = TextEditingController();
      TextEditingController _lastName = TextEditingController();
      TextEditingController _email = TextEditingController();
      TextEditingController _id = TextEditingController();
      TextEditingController _avatar = TextEditingController();

      return Scaffold(
      backgroundColor: Colors.lightBlue[900],
     // key: _drawerKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("UserInfo Application", style: TextStyle(color: Colors.white),),
        leading:  Builder(builder: (context) => // Ensure Scaffold is in context
        IconButton(
            icon: Icon(Icons.menu,color: Colors.white70,),
            onPressed: () => Scaffold.of(context).openDrawer()
        ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Center(
            child: Column(
              children: <Widget>[

                Text(formattedTime, textAlign : TextAlign.center,style: TextStyle(color: Colors.white70, fontSize: 40, fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text(formattedDate, textAlign : TextAlign.center,style: TextStyle(color: Colors.white70, fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
              ],
            ),
          ),


          Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)), color: Colors.white),
                child: FutureBuilder(
                    future: dataService.getData(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.done) {
                        if(snapshot.hasData) return getListView();
                        else return Center(child: Text("No Data"),);
                      }
                      else if(snapshot.connectionState == ConnectionState.waiting) return getLoadingWidget();
                      else if(snapshot.connectionState == ConnectionState.none) return getLoadingWidget();
                      else if(snapshot.connectionState == ConnectionState.active) return getLoadingWidget();
                      else return getLoadingWidget();
                    }
                ),
              )
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showQudsModalBottomSheet(
              context,
                  (c) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                children: [
                  SizedBox(height: getProportionateScreenWidth(10),),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _firstName,
                      onChanged: (newValue) => firstName = newValue,
                      decoration: InputDecoration(
                        hintText: "Enter your first name",
                        suffixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(10),),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _lastName,
                      onChanged: (newValue) => lastName = newValue,
                      decoration: InputDecoration(
                        hintText: "Enter your last name",
                        suffixIcon: Icon(Icons.account_circle_outlined),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (Value) => email = Value,
                      decoration: InputDecoration(
                        hintText: "Enter your email.",
                        suffixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _id,
                      keyboardType: TextInputType.phone,
                      onChanged: (Value) => id = Value,
                      decoration: InputDecoration(
                        hintText: "Enter your id.",
                        suffixIcon: Icon(Icons.looks_one_outlined),
                      ),
                    ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _avatar,
                    keyboardType: TextInputType.text,
                    onChanged: (Value) => url = Value,
                    decoration: InputDecoration(
                      hintText: "Enter your avatar url",
                      suffixIcon: Icon(Icons.account_box_rounded),
                    ),
                  ),
                    SizedBox(height: 20,),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        Data user = new Data(
                          firstName: _firstName.text,
                          lastName: _lastName.text,
                          email: _email.text,
                          id: int.parse(_id.text),
                          avatar: "https://reqres.in/img/faces/7-image.jpg",
                        );
                        dataService.addData(context, user);

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "submit", style: TextStyle(color: Colors.white),),
                    ),
                ],
              ),
                  ),
              titleText: 'Add Data');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getListView() {
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider userProvider, Widget child) {
        if(userProvider.users.isEmpty) return Center(child: Text("No Data"),);

        return ListView.builder(
            itemCount: userProvider.users.length,
            itemBuilder: (_,index) {
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                    key: Key(userProvider.users[index].id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          SvgPicture.asset("assets/icons/Trash.svg"),
                        ],
                      ),
                    ),
                    onDismissed: (direction){
                      dataService.deleteData(context, userProvider.users[index]);
                      },
                    child: ListDataCard(data: userProvider.users[index], index: index + 1)
                ),
              );
            },
        );
      }
    );
  }

  Widget getLoadingWidget() {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QudsLightDrawer(
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          ListTile(
            leading: Icon(Icons.account_circle,color:Colors.blue ,),
            title: Text("Hello user",style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.arrow_back_ios_outlined,color:Colors.blue ,),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => SignIn()));
            },
          ),
        ],
      ),
    );
  }
}
