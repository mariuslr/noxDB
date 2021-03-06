        
        //------------------------------------------------------------- *

        Ctl-Opt BndDir('NOXDB') dftactgrp(*NO) ACTGRP('QILE' );

        //------------------------------------------------------------- *

        /include 'headers/JSONPARSER.rpgle'
        Dcl-S pJson        Pointer;
        Dcl-S msg          Varchar(50);

        //------------------------------------------------------------- *

     C     *entry        plist
     C                   parm                    file            128
     C                   parm                    text             64
     C                   parm                    origin            3
        pJson = JSON_ParseFile   ( file);
        if JSON_Error(pJson) ;
           msg = JSON_Message(pJson);
           JSON_Close(pJson);
           return;
        endif;

        json_SetValue(pJson : '/session/preset/text'  : Text);
        json_SetValue(pJson : '/session/preset/origin': Origin);

        json_WriteStmf  (pJson : file  : 1208 : *OFF);
        JSON_Close(pJSON);
        *inlr = *on;
