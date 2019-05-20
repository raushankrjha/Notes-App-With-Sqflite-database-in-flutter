import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notesappwithsqllite/database_helper.dart';
import 'package:notesappwithsqllite/note.dart';
import 'package:notesappwithsqllite/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {
	@override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
	int count = 0;
	@override
  Widget build(BuildContext context) {

		if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text('LCO TO_DO'),
        backgroundColor: Colors.pink,
	    ),

	    body: getNoteListView(),
	    floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
		    onPressed: () {
		      navigateToDetail(Note('', '', 2), 'Add Note');
		    },
		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getNoteListView() {
		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
          shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
					color: Colors.blueAccent,
					elevation: 4.0,
					child: ListTile(
						leading: CircleAvatar
            (  
             backgroundImage: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/85/41/e1/8541e185-7eb4-6955-a6d8-626b88e220e8/AppIcon-1x_U007emarketing-85-220-0-9.png/1200x630wa.png"),
						),

						title: Text(this.noteList[position].title,style:new TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25.0)),
						subtitle: Text(this.noteList[position].date,style:new TextStyle(color: Colors.white)),
						trailing: GestureDetector
            (
							child: Icon(Icons.open_in_new, color: Colors.white,),
						),
						onTap: () 
            {
							navigateToDetail(this.noteList[position],'Edit To-Do');
						},

					),
				);
			},
		);
  }


  void navigateToDetail(Note note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {
		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database)
     {
			Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) 
      {
				setState(()
         {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}







