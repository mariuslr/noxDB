        //------------------------------------------------------------- *
        //This sample shows the use of the buildin JSONparser in
        //IceBreak

        //Using SQL cursors

        //on a table like this:
        //create table QGPL/NOTE2 (
        //id     int generated always as Identity primary key,
        //title  varchar(16)      not null with default,
        //text1  clob with default,
        //text2  clob with default,
        //num    int not null with default,
        //mydate  date not null with default
        //)

        //trace: CHGCPATRC JOBNUMBER(*CURRENT) SEV(*INFO)
        //DSPCPATRC

        //http://www-03.ibm.com/systems/power/software/i/db2/support/tips/clifaq.
        //------------------------------------------------------------- *
        Ctl-Opt BndDir('NOXDB') dftactgrp(*NO) ACTGRP('QILE' );

        Dcl-S err          Ind;
        Dcl-S row          Varchar(32766);
        Dcl-S pRow         Pointer;
        Dcl-S id           Uns(10);

      /include 'headers/JSONPARSER.rpgle'


        // insert - note: subsequent object a serialized into the blobs / clobs
        row = ('{ -
           title: "tesing",                             -
           text1: {da:"Dansk Tekst" , en:"English"}     -
        }');

        err = json_sqlInsert  (
           'qgpl/note2'
           :row
        );

        // get ret unique ID generated
        id = json_sqlGetInsertId();

        // now get that row: here we use the a stringed object to build the where statement via the template
        pRow = json_sqlResultRow (('  -
              select * from qgpl/note2  -
              where id = $id           -
           ')
           :'{id:' + %char(id) +'}'
        );

        // manipulate data:
        json_setStr(pRow : 'text1.fr' : 'aussi en français');
        json_setInt(pRow : 'num'      : 123.56 );
        err = json_sqlUpdate(
           'qgpl/note2'
           :pRow                // the text object is updated with a extra tag
           :'where  id = $id'   // the where uses atemplate to the id, and the ide is retrived from the row itself
           :pRow
        );

        // Cleanup: Close the SQL cursor, dispose the rows, arrays and disconnect
        json_close(pRow);
        json_sqlDisconnect();

        // That's it..
        *inlr = *on;
