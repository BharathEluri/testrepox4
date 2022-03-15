       IDENTIFICATION DIVISION.
       PROGRAM-ID.    HELLO6.
       ENVIRONMENT    DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
         COPY COPY1.
      *
         01 F240 PIC X VALUE '0'.
         01 F241 PIC X VALUE '1'.
         01 F242 PIC X VALUE '2'.
         01 F243 PIC X VALUE '3'.
         01 F244 PIC X VALUE '4'.
         01 F245 PIC X VALUE '5'.
         01 F246 PIC X VALUE '6'.
         01 F247 PIC X VALUE '7'.
         01 F248 PIC X VALUE '8'.
         01 F249 PIC X VALUE '9'.
         01 F239 PIC X VALUE X'4B'.

       PROCEDURE      DIVISION.
           DISPLAY 'Sample'.
           GOBACK.