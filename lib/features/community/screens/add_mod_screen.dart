import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/common/error_text.dart';
import 'package:flutter_application_1/core/common/loader.dart';
import 'package:flutter_application_1/features/auth/controller/auth_controller.dart';
import 'package:flutter_application_1/features/community/controller/community_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class AddModScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModScreen({super.key , required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids={};
  int ctr=0;

void addUids(String uid){
  setState(() {
    uids.add(uid);
  });
}

void removeUids(String uid){
  setState(() {
    uids.remove(uid);
  });
}

void saveMods(){
  ref.read(CommunityControllerProvider.notifier).
  addMods(widget.name, uids.toList(), context);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        actions: [
          InkWell( 
            onTap: () => saveMods(),
            child: Icon(Icons.done),
          ),
      //IconButton(onPressed: (){saveMods;}, icon: const  Icon(Icons.done))

        ],
        
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(data: (communty)=> ListView.builder(
        
        itemCount: communty.members.length,

        itemBuilder: (BuildContext context, int index) {
          final member = communty.members[index];

          return ref.watch(getUserDataProvider(member)).when(data: (user){
            if(communty.mods.contains(member)&& ctr==0)
            {
              uids.add(member);
            }
            ctr++;
            
             return CheckboxListTile(
            value: uids.contains(user.uid), 
            onChanged: (val){
              if(val!)
              {
                addUids(user.uid);
              }
              else
              {
                removeUids(user.uid);
              }
            },
            title: Text(user.name),
            
            );},
          
          
           error: (error,StackTrace)=> ErrorText(error: error.toString()), loading: ()=> const Loader());
        
            
        }), 
      
      
      
      error: (error,StackTrace)=> ErrorText(error: error.toString()),
      
       loading:()=> const Loader())
    );
  }
}